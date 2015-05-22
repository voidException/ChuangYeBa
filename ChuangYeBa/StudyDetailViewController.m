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
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "LineNavigationBar.h"

typedef enum {
    StudyDetailStateNormal = 1,
    StudyDetailStateNoneMedia,
} StudyDetailState;

static NSString *articleTitleCellIdentifier = @"ArticleTitleCell";
static NSString *articleCellIdentifier = @"ArticleCell";
static NSString *mediaCellIdentifier = @"MediaCell";
static NSString *countCellIdentifier = @"CountingCell";
static NSString *commentCellIdentifier = @"CommentCell";

static NSInteger const kCommentInputViewHeight = 164;

static NSInteger const kPageSize = 2;


@interface StudyDetailViewController ()

@property (strong, nonatomic) NSNumber *articleId;
//@property (strong, nonatomic) PullUpRefreshView *refreshView;
@property (strong, nonatomic) CommentCell *deletingCommentCell;
@property (assign, nonatomic) StudyDetailState state;

@property (strong, nonatomic) UIButton *refreshButton;

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
    self.userInfo = [UserInfo loadUserInfoFromLocal];
    // 读取文章信息 读取文章信息后再请求评论列表
    [self requestArticleInfoFromServer];
    
    
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
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    
    // 注册xib的cell
    [self.tableView registerNib:[UINib nibWithNibName:@"ArticleTitleCell" bundle:nil] forCellReuseIdentifier:articleTitleCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"ArticleCell" bundle:nil] forCellReuseIdentifier:articleCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"MediaCell" bundle:nil] forCellReuseIdentifier:mediaCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"CountingCell" bundle:nil] forCellReuseIdentifier:countCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil] forCellReuseIdentifier:commentCellIdentifier];
    // 初始化CommentInputView
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommentInputView" owner:self options:nil];
    self.commentInputView = [nib objectAtIndex:0];
    self.commentInputView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, kCommentInputViewHeight);
    self.commentInputView.delegate = self;
    // 添加评论窗口并隐藏
    [self.view addSubview:self.commentInputView];
    self.commentInputView.hidden = YES;
    
    // 设置底端的评论按钮宽度
    self.toolBar.hidden = YES;
    [self.toolbarView setFrame:CGRectMake(0, 0, self.view.frame.size.width - 16, 44)];
    
    // 初始化自定义导航条
    self.customBar = [[LineNavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    //self.leftButton = [[UIBarButtonItem alloc] initWithTitle:@"学习" style:UIBarButtonItemStylePlain target:self action:@selector(clickOnLeftButton)];
    self.leftButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"lastButtonIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleBordered target:self action:@selector(clickOnLeftButton)];
    self.customItem = [[UINavigationItem alloc] initWithTitle:@"学习详情"];
    self.customBar.titleTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:20]};
    self.customBar.tintColor = [UIColor grayColor];
    [self.customBar pushNavigationItem:self.customItem animated:YES];
    self.customItem.leftBarButtonItem = self.leftButton;
    [self.view addSubview:self.customBar];
    // 初始化工具条按钮图片
    
    [self.likeButton setBackgroundImage:[UIImage imageNamed:@"likeIconNormal"] forState:UIControlStateNormal];
    
    [self.downLoadButton setBackgroundImage:[UIImage imageNamed:@"downloadIcon"] forState:UIControlStateNormal];
    [self.commentButton setBackgroundImage:[UIImage imageNamed:@"commentBG"] forState:UIControlStateNormal];
    
    // 增加上拉刷新
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [self requestCommentsFromServer:YES];
    }];
    self.tableView.footer.automaticallyRefresh = NO;
    self.tableView.footer.hidden = YES;
    
    // 添加返回手势
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(clickOnLeftButton)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGesture];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)loadMoreData {
    [self.tableView.footer endRefreshing];
}

- (void)setState:(StudyDetailState)state {
    if (_state == state) {
        return;
    }
    _state = state;
}

- (void)requestCommentsFromServer:(BOOL)isPullupRefresh {
    NSInteger requestPage;
    NSInteger requestPageSize;
    // 如果是上拉刷新
    if (isPullupRefresh) {
        if (self.comments.count) {
            requestPage = self.comments.count;
            requestPageSize = kPageSize;
        }
        else {
            requestPage = 0;
            requestPageSize = kPageSize;
        }
    }
    // 如果是直接刷新（添加评论所造成的刷新动作）
    else {
        requestPage = 0;
        requestPageSize = self.comments.count + 1;
    }
    
    [StudyNetworkUtils requestCommentsWithToken:self.userInfo.email userId:self.userInfo.userId articleId:self.articleId page:requestPage pageSize:requestPageSize andCallback:^(id obj) {
        if (self.tableView.footer == self.tableView.legendFooter) {
            [self.tableView.footer endRefreshing];
        }
        if (obj) {
            if (!self.comments) {
                self.comments = [[NSMutableArray alloc] init];
            }
            // 把解析好的评论列表赋给内存中的评论列表数组
            NSMutableArray *mArr = obj;
            if (!isPullupRefresh) {
                [self.comments removeAllObjects];
            } else {
                if (!mArr.count) {
                    //[self.refreshView noticeNoMoreData];
                    [self.tableView.footer noticeNoMoreData];
                }
            }
            for (int i = 0; i < mArr.count; i++) {
                CommentInfo *ci = mArr[i];
                [self.comments addObject:ci];
            }
            [self.tableView reloadData];
        }
    }];
}

- (void)requestArticleInfoFromServer {
    
    if (self.refreshButton) {
        [self.refreshButton removeFromSuperview];
        self.refreshButton = nil;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    
    [StudyNetworkUtils requestArticleDetailWithToken:self.userInfo.email userId:self.userInfo.userId articleId:self.articleId andCallback:^(id obj) {
        [hud hide:YES];
        if (obj) {
            // 有文章就显示评论的上拉刷新
            self.tableView.footer.hidden = NO;
            // 有文章就显示底端的评论条
            self.toolBar.hidden = NO;
            NSDictionary *dic = obj;
            NSNumber *error = [dic objectForKey:@"error"];
            NSString *errorMessage = [dic objectForKey:@"errorMessage"];
            if ([error isEqual: @1]) {
                self.articleInfo = [StudyJsonParser parseArticleInfo:[dic objectForKey:@"article"]];
                
                if ([self.articleInfo.articleType isEqual:@71]) {
                    [self setState:StudyDetailStateNoneMedia];
                } else {
                    [self setState:StudyDetailStateNormal];
                }
                
                [self.tableView reloadData];
                
                // 请求评论列表
                [self requestCommentsFromServer:YES];
                
                
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:errorMessage delegate:self cancelButtonTitle:@"好吧" otherButtonTitles:nil, nil];
                [alert show];
            }
        } else {
            
            if (!self.refreshButton) {
                self.refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
            }
            [self.refreshButton setImage:[UIImage imageNamed:@"errormarkBig"] forState:UIControlStateNormal];
            _refreshButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 200, 0);
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
            label.center = CGPointMake(self.view.center.x, 300);
            label.text = @"点击重新加载页面";
            label.font = [UIFont boldSystemFontOfSize:17];
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            [_refreshButton addSubview:label];
            
            [_refreshButton setBackgroundColor:[UIColor blackColor]];
            _refreshButton.alpha = 0.5;
            [_refreshButton addTarget:self action:@selector(requestArticleInfoFromServer) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:_refreshButton];
            
            
            
            MBProgressHUD *errorHud = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:errorHud];
            errorHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"errormark"]];
            // Set custom view mode
            errorHud.mode = MBProgressHUDModeCustomView;
            errorHud.animationType = MBProgressHUDAnimationZoomIn;
            //HUD.delegate = self;
            errorHud.labelText = @"网络出错了>_<";
            [errorHud show:YES];
            [errorHud hide:YES afterDelay:1.0];
        }
    }];
}

- (void)submitCommentToServer {
    NSDate *nowDate = [NSDate date];
    NSLog(@"%@", self.commentInputView.textView.text);
    [StudyNetworkUtils submitCommentWithArticleId:self.articleInfo userInfo:self.userInfo commitDate:nowDate content:self.commentInputView.textView.text andCallback:^(id obj){
        NSDictionary *dic = obj;
        
        // 注意：在这里error返回的居然是当前的评论数，WTF，真TM逗！
        NSNumber *error = [dic objectForKey:@"error"];
        NSString *errorMessage = [dic objectForKey:@"errorMessage"];
        if ([error integerValue] > 0) {
            // 重新请求一次评论的列表并且刷新
            [self requestCommentsFromServer:NO];
            // 隐藏评论席位,并清空TextView
            self.commentInputView.textView.text = @"";
            [self removeActivityBackgroundView];
            [self.commentInputView.textView resignFirstResponder];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:errorMessage delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

- (void)submitDeleteCommentToServer:(CommentCell *)commentCell {
    
}


#pragma mark 调整再键盘弹出时的Frame
- (CGFloat)keyboardEndFrameHeight:(NSDictionary *)userInfo//计算键盘的高度
{
    CGRect keyboardEndUncorrectedFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGRect keyboardBeginingFrame = [self.view convertRect:keyboardEndUncorrectedFrame fromView:nil];
    NSLog(@"keyB height = %f", keyboardBeginingFrame.size.height);
    return keyboardBeginingFrame.size.height;
}

// 键盘出现后调整视图
- (void)keyboardWillAppear:(NSNotification *)notification
{
    [self addActivityBackgroundView];
    CGFloat keyboardHeight = [self keyboardEndFrameHeight:[notification userInfo]];
    if (keyboardHeight) {
        self.commentInputView.frame = CGRectMake(0, self.view.frame.size.height - keyboardHeight - kCommentInputViewHeight, self.view.frame.size.width, kCommentInputViewHeight);
        self.commentInputView.hidden = NO;
        [self.view bringSubviewToFront:self.commentInputView];
    }
}

// 键盘消失后调整视图
- (void)keyboardWillDisappear:(NSNotification *)notification
{
    CGFloat keyboardHeight = [self keyboardEndFrameHeight:[notification userInfo]];
    [UIView animateWithDuration:1.0 animations:^{
        self.commentInputView.frame = CGRectOffset(self.commentInputView.frame, 0, keyboardHeight + kCommentInputViewHeight);
        //self.activityBackgroundView.blurRadius = 0;
    } completion:^(BOOL finished) {
        [self removeActivityBackgroundView];
    }];
}


#pragma mark - Action

- (IBAction)clickOnCommentButton:(id)sender {
    [self.commentInputView.textView becomeFirstResponder];
}

- (void)clickOnBlurView {
    [self.commentInputView.textView resignFirstResponder];
}

- (IBAction)clickOnLikeButton:(id)sender {
    if (isLiked) {
        isLiked = NO;
        [self.likeButton setBackgroundImage:[UIImage imageNamed:@"likeIconNormal"] forState:UIControlStateNormal];
        
    } else {
        isLiked = YES;
        [StudyNetworkUtils submitAddLoveWithToken:self.userInfo.email userId:self.userInfo.userId articleId:self.articleId andCallback:^(id obj) {
            
            // 更新ArticleInfo中的赞的数量
            self.articleInfo.likes = obj;
            
            // 改变likeButton的样子
            [self.likeButton setBackgroundImage:[UIImage imageNamed:@"likeIconSelected"] forState:UIControlStateNormal];
            
            // 给计算赞和评论的小区的赞label位置加1
            CountingCell *cell = [[CountingCell alloc] init];
            if (self.state == StudyDetailStateNormal) {
                cell = (CountingCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
            } else {
                cell = (CountingCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            }
            cell.likeCountingLabel.text = [NSString stringWithFormat:@"%@", self.articleInfo.likes];
        }];
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
    [self performSegueWithIdentifier:@"BackToMain" sender:self];
}


#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSLog(@"%f", [self.articleInfo getHeightOfArticleString:self.articleInfo.title
                                                         lineSpacing:4.0
                                                          fontOfSize:23.0
                                                         widthOffset:16]);
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
                    return 185;
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
        NSInteger row = [indexPath row];
        CommentInfo *ci = self.comments[row];
        NSInteger height = [self.articleInfo getHeightOfArticleString:ci.content
                                              lineSpacing:2.0
                                               fontOfSize:15.0
                                              widthOffset:80] + 48;
        
        if (height <= 84) {
            return 84;
        } else {
            return height;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
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
    NSLog(@"%lu", self.tableView.subviews.count);
    
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
    mediaCell.delegate = self;
    [mediaCell.mediaButton sd_setBackgroundImageWithURL:[NSURL URLWithString:_articleInfo.miniPhotoURL] forState:UIControlStateNormal];
    switch ([self.articleInfo.articleType integerValue]) {
        case 71:
            [mediaCell setState:MediaCellStateNormal];
            break;
        case 72:
            [mediaCell setState:MediaCellStateLongImage];
            break;
        case 73:
            [mediaCell setState:MediaCellStateVideo];
            break;
        default:
            [mediaCell setState:MediaCellStateNormal];
            break;
    }
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
    commentCell.delegate = self;
    NSInteger row = [indexPath row];
    commentCell.commentInfo = self.comments[row];
    commentCell.indexPath = indexPath;
    
    // 如果不是自己发送的，那么不要现实删除按键
    if (![self.userInfo.userId isEqual:commentCell.commentInfo.userId]) {
        [commentCell.deleteButton setHidden:YES];
    }
    return commentCell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
    
}

#pragma mark - CommentInputView Delegate
-(void)commentInputView:(CommentInputView *)commentInputView clickOnCommentButtonAtIndex:(NSInteger)index {
    // 没能测试
    if (index == 1) {
        [self submitCommentToServer];
    } else {
        //self.commentInputView.hidden = YES;
        [self removeActivityBackgroundView];
        [self.commentInputView.textView resignFirstResponder];
    }
}

// 添加透明指示栏
- (void)addActivityBackgroundView {
    if (self.activityBackgroundView == nil) {
        
        self.activityBackgroundView = [[FXBlurView alloc] initWithFrame:self.view.bounds];
        self.activityBackgroundView.tintColor = [UIColor blackColor];
        
        self.activityBackgroundView.blurRadius = 10;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOnBlurView)];
        self.activityBackgroundView.userInteractionEnabled = YES;
        [self.activityBackgroundView addGestureRecognizer:tapGesture];
        
        [self.view addSubview:self.activityBackgroundView];
        [UIView animateWithDuration:0.5 animations:^{
            self.activityBackgroundView.blurRadius = 40;
        }];
        
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

#pragma mark - CommentCell Delegate
- (void)clickOnCommentCellDeleteButton:(CommentCell *)commentCell {
    self.deletingCommentCell = commentCell;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除评论" otherButtonTitles:nil, nil];
    [actionSheet showInView:self.view];
}

#pragma mark - ActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [StudyNetworkUtils submitDeleteCommentWithToken:self.userInfo.email userId:self.userInfo.userId commentId:self.deletingCommentCell.commentInfo.commentId andCallback:^(id obj) {
            NSNumber *error = [obj objectForKey:@"error"];
            if ([error isEqual:@1]) {
                [self.tableView reloadData];
                [self.comments removeObjectAtIndex:self.deletingCommentCell.indexPath.row];
                [self.tableView deleteRowsAtIndexPaths:@[self.deletingCommentCell.indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }];
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString: @"ShowMedia"]) {
        id destinationVC = [segue destinationViewController];
        [destinationVC setValue:_articleInfo forKey:@"articleInfo"];
    }
}


@end
