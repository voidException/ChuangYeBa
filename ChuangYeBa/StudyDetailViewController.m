//
//  StudyDetailViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/17.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "StudyDetailViewController.h"
#import "StudyNetworkUtils.h"
#import "StudyJsonParser.h"
#import <MBProgressHUD.h>
#import <MJRefresh.h>

typedef enum {
    StudyDetailStateNormal = 1,
    StudyDetailStateNoneMedia,
} StudyDetailState;

static NSString *articleTitleCellIdentifier = @"ArticleTitleCell";
static NSString *articleCellIdentifier = @"ArticleCell";
static NSString *mediaCellIdentifier = @"MediaCell";
static NSString *countCellIdentifier = @"CountingCell";
static NSString *commentCellIdentifier = @"CommentCell";

static NSInteger const kPageSize = 2;


@interface StudyDetailViewController ()

@property (strong, nonatomic) NSNumber *articleId;

@property (assign, nonatomic) StudyDetailState state;

@end

@implementation StudyDetailViewController

@synthesize isLiked;
@synthesize isDownloaded;


#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化UI
    [self initUI];
    
    // 注册键盘出现通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    
    // 初始化Bool参数，应该从网络和本地确定
    isDownloaded = NO;
    isLiked = NO;
    
    // 读取用户信息
    [self loadUserInfoFromLocal];
    // 读取文章信息
    [self requestArticleInfoFromServer];
    // 读取用户评论
    [self requestCommentsFromServer];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    // 隐藏系统自带导航条
#warning 普通！隐藏时会造成上一个界面的侧滑滚动条消失
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private Method
// 初始化UI
- (void)initUI {
    self.title = @"学习详情";
    // TableView初始化设置
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 注册xib的cell
    [self.tableView registerNib:[UINib nibWithNibName:@"ArticleTitleCell" bundle:nil] forCellReuseIdentifier:articleTitleCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"ArticleCell" bundle:nil] forCellReuseIdentifier:articleCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"MediaCell" bundle:nil] forCellReuseIdentifier:mediaCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"CountingCell" bundle:nil] forCellReuseIdentifier:countCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil] forCellReuseIdentifier:commentCellIdentifier];
    // 初始化CommentInputView
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommentInputView" owner:self options:nil];
    self.commentInputView = [nib objectAtIndex:0];
    self.commentInputView.delegate = self;
    
    // 添加评论窗口并隐藏
    [self.view addSubview:self.commentInputView];
    self.commentInputView.hidden = YES;
    
    // 初始化自定义导航条
    self.customBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    self.leftButton = [[UIBarButtonItem alloc] initWithTitle:@"学习" style:UIBarButtonItemStylePlain target:self action:@selector(clickOnLeftButton)];
    self.customItem = [[UINavigationItem alloc] initWithTitle:@"学习详情"];
    self.customBar.titleTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:20]};
    self.customBar.tintColor = [UIColor grayColor];
    [self.customBar pushNavigationItem:self.customItem animated:YES];
    self.customItem.leftBarButtonItem = self.leftButton;
    [self.view addSubview:self.customBar];
    // 初始化工具条按钮图片
    [self.likeButton setBackgroundImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    [self.downLoadButton setBackgroundImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
    [self.commentButton setBackgroundImage:[UIImage imageNamed:@"commentBG"] forState:UIControlStateNormal];
    // 设置底端的评论按钮宽度
    [self.toolbarView setFrame:CGRectMake(0, 0, self.view.frame.size.width - 16, 44)];
    
    // 增加上拉刷新
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [self requestCommentsFromServer];
    }];
    self.tableView.footer.automaticallyRefresh = NO;
    
}

- (void)setState:(StudyDetailState)state {
    if (_state == state) {
        return;
    }
    _state = state;
}

- (void)requestCommentsFromServer {
    NSInteger requestPage;
    NSInteger requestPageSize;
    if (self.comments.count) {
        requestPage = self.comments.count;
        requestPageSize = kPageSize;
    }
    else {
        requestPage = 0;
        requestPageSize = kPageSize;
    }
    
    [StudyNetworkUtils requestCommentsWithToken:self.userInfo.email userId:self.userInfo.userId articleId:self.articleId page:requestPage pageSize:requestPageSize andCallback:^(id obj) {
        
        if (self.tableView.footer == self.tableView.legendFooter) {
            [self.tableView.footer endRefreshing];
        }
        
        // 把解析好的评论列表赋给内存中的评论列表数组
        self.comments = obj;
        [self.tableView reloadData];
        
#warning 可选！可以研究一下怎么reload一个section。
        //[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}

- (void)loadUserInfoFromLocal {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    self.userInfo = [[UserInfo alloc]init];
    NSData *udObject = [ud objectForKey:@"userInfo"];
    self.userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:udObject];
}

- (void)requestArticleInfoFromServer {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    [StudyNetworkUtils requestArticleDetailWithToken:self.userInfo.email userId:self.userInfo.userId articleId:self.articleId andCallback:^(id obj) {
        [hud hide:YES];
        if (obj) {
            NSDictionary *dic = obj;
            NSNumber *error = [dic objectForKey:@"error"];
            NSString *errorMessage = [dic objectForKey:@"errorMessage"];
            if ([error isEqual: @1]) {
                self.articleInfo = [StudyJsonParser parseArticleInfo:[dic objectForKey:@"article"]];
                
                if ([self.articleInfo.articleType isEqual:@1]) {
                    [self setState:StudyDetailStateNoneMedia];
                } else {
                    [self setState:StudyDetailStateNormal];
                }
                
                [self.tableView reloadData];
                
                // 请求评论列表
                [self requestCommentsFromServer];
                
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:errorMessage delegate:self cancelButtonTitle:@"好吧" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }];
}

- (void)submitCommentToServer {
    NSDate *nowDate = [NSDate date];
    NSLog(@"%@", self.commentInputView.textView.text);
    [StudyNetworkUtils submitCommentWithArticleId:self.articleInfo userInfo:self.userInfo commitDate:nowDate content:self.commentInputView.textView.text andCallback:^(id obj){
        NSDictionary *dic = obj;
        NSNumber *error = [dic objectForKey:@"error"];
        NSString *errorMessage = [dic objectForKey:@"errorMessage"];
        if ([error integerValue] == 1) {
            
            // 添加评论并且更新视图
            
            [self.tableView beginUpdates];
            
            // 把刚刚提交的
            CommentInfo *commentInfo = [[CommentInfo alloc] init];
            commentInfo.userName = self.userInfo.name;
            commentInfo.content = self.commentInputView.textView.text;
            commentInfo.commentTime = nowDate;
            
            [self.comments insertObject:commentInfo atIndex:0];
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationBottom];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            [self.tableView endUpdates];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
            // 隐藏评论席位
            self.commentInputView.hidden = YES;
            [self removeActivityBackgroundView];
            [self.commentInputView.textView resignFirstResponder];
            
            
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:errorMessage delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

#pragma mark 调整再键盘弹出时的Frame
- (CGFloat)keyboardBeginingFrameHeight:(NSDictionary *)userInfo//计算键盘的高度
{
    CGRect keyboardBeginingUncorrectedFrame = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey]CGRectValue];
    CGRect keyboardBeginingFrame = [self.view convertRect:keyboardBeginingUncorrectedFrame fromView:nil];
    NSLog(@"keyB height = %f", keyboardBeginingFrame.size.height);
    return keyboardBeginingFrame.size.height;
}

// 键盘出现后调整视图
-(void)keyboardWillAppear:(NSNotification *)notification
{
    CGFloat keyboardHeight = [self keyboardBeginingFrameHeight:[notification userInfo]];

    if (keyboardHeight) {
        self.commentInputView.frame = CGRectMake(0, self.view.frame.size.height - keyboardHeight - 150, self.view.frame.size.width, 150);
        self.commentInputView.hidden = NO;
        [self.view bringSubviewToFront:self.commentInputView];
    }
}

// 键盘消失后调整视图
-(void)keyboardWillDisappear:(NSNotification *)notification
{
    [self removeActivityBackgroundView];
    self.commentInputView.hidden = YES;
}


#pragma mark - Action
- (IBAction)clickOnCommentButton:(id)sender {
    [self addActivityBackgroundView];
    //[self.view addSubview:self.commentInputView];
    [self.commentInputView.textView becomeFirstResponder];
}

- (IBAction)clickOnLikeButton:(id)sender {
    if (isLiked) {
        isLiked = NO;
        [self.likeButton setBackgroundImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        
    } else {
        isLiked = YES;
        [self.likeButton setBackgroundImage:[UIImage imageNamed:@"likeClicked"] forState:UIControlStateNormal];
    }
}

- (IBAction)clickOnDownloadButton:(id)sender {
    if (isDownloaded) {
        isDownloaded = NO;
        [self.downLoadButton setBackgroundImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
        
    } else {
        isDownloaded = YES;
        [self.downLoadButton setBackgroundImage:[UIImage imageNamed:@"downloadClicked"] forState:UIControlStateNormal];
    }

}

- (void)clickOnLeftButton {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return [self.articleInfo getHeightOfArticleString:self.articleInfo.title
                                                  lineSpacing:4.0
                                                   fontOfSize:23.0
                                                  widthOffset:16] + 16;
        } else if (indexPath.row == 1) {
            return [self.articleInfo getHeightOfArticleString:self.articleInfo.content
                                                  lineSpacing:4
                                                   fontOfSize:17.0
                                                  widthOffset:24];
        } else if (indexPath.row == 2) {
            switch (_state) {
                case StudyDetailStateNormal:
                    return 150;
                    break;
                case StudyDetailStateNoneMedia:
                    return 44;
                    break;
                default:
                    break;
            }
        } else if (indexPath.row == 3) {
            return 44;
        }
        return 44;
    } else {
        // 最小值为89 字数多的时候行数会增加。
        return 89;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // 如果有文章就返回2 没有文章则什么都不显示
    if (self.articleInfo) {
        return 2;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (_state) {
        case StudyDetailStateNormal:
            if (self.articleInfo) {
                if (section == 0) {
                    return 4;
                } else {
                    return self.comments.count;
                }
            } else {
                return 0;
            }
            break;
        case StudyDetailStateNoneMedia:
            if (self.articleInfo) {
                if (section == 0) {
                    return 3;
                } else {
                    return self.comments.count;
                }
            }
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return [self tableView:tableView articleTitleCellForRowAtIndexPath:indexPath];
        } else if (indexPath.row == 1) {
            return [self tableView:tableView articleCellForRowAtIndexPath:indexPath];
        } else if (indexPath.row == 2){
            switch (_state) {
                case StudyDetailStateNormal:
                    return [self tableView:tableView mediaCellForRowAtIndexPath:indexPath];
                    break;
                case StudyDetailStateNoneMedia:
                    return [self tableView:tableView countingCellForRowAtIndexPath:indexPath];
            }
        } else if (indexPath.row == 3) {
            return [self tableView:tableView countingCellForRowAtIndexPath:indexPath];
        }
        return nil;
    } else {
        return [self tableView:tableView commentCellForRowAtIndexPath:indexPath];
    }
}



- (ArticleTitleCell *)tableView:(UITableView *)tableView articleTitleCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArticleTitleCell *articleTitleCell = [tableView dequeueReusableCellWithIdentifier:articleTitleCellIdentifier];
    articleTitleCell.title.text = self.articleInfo.title;
    articleTitleCell.category.text = @"自我管理";
    articleTitleCell.publishDate.text = @"05-14 5:04";
    return articleTitleCell;
}

- (ArticleCell *)tableView:(UITableView *)tableView articleCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArticleCell *articleCell = [tableView dequeueReusableCellWithIdentifier:articleCellIdentifier];
    articleCell.content.text = self.articleInfo.content;
    return articleCell;
}

- (MediaCell *)tableView:(UITableView *)tableView mediaCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MediaCell *mediaCell = [tableView dequeueReusableCellWithIdentifier:mediaCellIdentifier];
    [mediaCell setState:MediaCellStateNormal];
    mediaCell.delegate = self;
    return mediaCell;
}

- (CountingCell *)tableView:(UITableView *)tableView countingCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CountingCell *countingCell = [tableView dequeueReusableCellWithIdentifier:countCellIdentifier];
    countingCell.likeCountingLabel.text = [NSString stringWithFormat:@"%@", self.articleInfo.likes];
    countingCell.commentCountingLabel.text = [NSString stringWithFormat:@"%@", self.articleInfo.comments];
    return countingCell;
}

- (CommentCell *)tableView:(UITableView *)tableView commentCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:commentCellIdentifier];
    NSInteger row = [indexPath row];
    CommentInfo *commentInfo = self.comments[row];
    commentCell.userInfoLabel.text = commentInfo.userName;
    commentCell.commentTextView.text = commentInfo.content;
    return commentCell;
}


#pragma mark - CommentInputView Delegate
-(void)commentInputView:(CommentInputView *)commentInputView clickOnCommentButtonAtIndex:(NSInteger)index {
    // 没能测试
    if (index == 1) {
        [self submitCommentToServer];
    } else {
        self.commentInputView.hidden = YES;
        [self removeActivityBackgroundView];
        [self.commentInputView.textView resignFirstResponder];
    }
}

// 添加透明指示栏
- (void)addActivityBackgroundView {
    if (self.activityBackgroundView == nil) {
        self.activityBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
        self.activityBackgroundView.backgroundColor = [UIColor blackColor];
        self.activityBackgroundView.alpha = 0.5f;
        [self.view addSubview:self.activityBackgroundView];
    }
    if (![self.activityBackgroundView isDescendantOfView:self.view]) {
        [self.view addSubview:self.activityBackgroundView];
    }
}

// 移除透明指示栏
- (void)removeActivityBackgroundView {
    if (self.activityBackgroundView) {
        if ([self.activityBackgroundView isDescendantOfView:self.view]) {
            [self.activityBackgroundView removeFromSuperview];
        }
        self.activityBackgroundView = nil;
    }
}

#pragma mark - Media Cell Delegate
- (void)clickOnMedia:(MediaCell *)mediaCell{
    [self performSegueWithIdentifier:@"ShowMedia" sender:self];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString: @"ShowMedia"]) {
        id destinationVC = [segue destinationViewController];
        NSInteger mediaType = 1;
        [destinationVC setValue:[NSNumber numberWithInteger:mediaType] forKey:@"mediaType"];
    }
}


@end
