//
//  StudyDetailViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/17.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "StudyDetailViewController.h"

static NSString *articleTitleCellIdentifier = @"ArticleTitleCell";
static NSString *articleCellIdentifier = @"ArticleCell";
static NSString *mediaCellIdentifier = @"MediaCell";
static NSString *countCellIdentifier = @"CountingCell";
static NSString *commentCellIdentifier = @"CommentCell";


@implementation StudyDetailViewController

@synthesize isLiked;
@synthesize isDownloaded;


#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    // 设置底端的评论按钮宽度
    [self.toolbarView setFrame:CGRectMake(0, 0, self.view.frame.size.width - 16, 44)];
    
    // 初始化UI
    [self initUI];
    
    // 读取用户评论
    [self requestCommentsFromServer];
    
    // 读取文章
    [self loadArticle];
    
    // 读取用户信息
    [self loadUserInfoFromLocal];
    
    // 注册键盘出现通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    
    // 初始化Bool参数，应该从网络和本地确定
    isDownloaded = NO;
    isLiked = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    // 隐藏系统自带导航条
#warning 普通！隐藏时会造成上一个界面的侧滑滚动条消失
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark - Private Method
// 初始化UI
- (void)initUI {
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
    
    //self.commentButton.showsTouchWhenHighlighted = YES;
}

- (void)requestCommentsFromServer {
    //模拟数据
    self.comment = [[NSDictionary alloc] init];
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"userComment" ofType:@"plist"];
    self.comments = [[NSArray alloc] initWithContentsOfFile:plistPath];
}

- (void)loadUserInfoFromLocal {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    self.userInfo = [[UserInfo alloc]init];
    NSData *udObject = [ud objectForKey:@"userInfo"];
    self.userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:udObject];
}

- (void)loadArticle {
    self.articleInfo = [[ArticleInfo alloc] init];
    self.articleInfo.articleId = @"1";
    self.articleInfo.title = @"习近平接受九国新任驻华大使递交国书国书国书国书国书国书国书国书";
    self.articleInfo.viceTitle = @"木有东西";
    self.articleInfo.content = @"央视网消息(新闻联播)：国家主席习近平4月14日在人民大会堂接受9国新任驻华大使递交国书。他们是：马拉维驻华大使纳蒙德维、中非驻华大使姆巴佐阿、汤加驻华大使乌塔阿图、英国驻华大使吴百纳、泰国驻华大使醍乐堃、南非驻华大使姆西曼、哈萨克斯坦驻华大使努雷舍夫、韩国驻华大使金章洙、安提瓜和巴布达驻华大使斯图亚特-杨。\n\n习近平欢迎外国使节们来华履新，请他们转达对各有关国家领导人和人民的诚挚问候和良好祝愿。习近平表示，中国愿继续加强与各国的友好务实合作，并共同为维护人类和平、促进世界繁荣而努力。中国政府将为各位使节履职提供便利和支持，希望各位使节为推动中国同有关国家双边关系发展、促进中国同有关国家人民之间的友谊作出积极贡献。\n\n外国使节们转达了各自国家领导人对习近平的亲切问候，祝愿中国繁荣富强，并在国际事务中发挥越来越重要的作用。使节们表示，中国的发展对世界是重要机遇，各国高度重视对华关系，赞赏和支持中方发起的“一带一路”和亚洲基础设施投资银行等倡议。使节们表示，能够在此时出使中国深感荣幸，将为增进各自国家同中国的友谊与合作积极努力。";
    self.articleInfo.comments = @"9";
    self.articleInfo.likes = @"8";
    self.articleInfo.publishDate = [NSDate date];
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
            return [self.articleInfo getHeightOfArticleString:self.articleInfo.title fontOfSize:20] + 36;
        } else if (indexPath.row == 1) {
            return [self.articleInfo getHeightOfArticleString:self.articleInfo.content fontOfSize:16] + 20;
        } else if (indexPath.row == 2) {
            return 150;
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
    if (self.comments.count) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    } else {
        return self.comments.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ArticleTitleCell *articleTitleCell = [tableView dequeueReusableCellWithIdentifier:articleTitleCellIdentifier];
            articleTitleCell.title.text = self.articleInfo.title;
            articleTitleCell.category.text = @"自我管理";
            articleTitleCell.publishDate.text = @"05-14 5:04";
            return articleTitleCell;
        } else if (indexPath.row == 1) {
            ArticleCell *articleCell = [tableView dequeueReusableCellWithIdentifier:articleCellIdentifier];
            articleCell.content.text = self.articleInfo.content;
            return articleCell;
        } else if (indexPath.row == 2){
            MediaCell *mediaCell = [tableView dequeueReusableCellWithIdentifier:mediaCellIdentifier];
            mediaCell.delegate = self;
            return mediaCell;
            
        } else if (indexPath.row == 3) {
            CountingCell *countingCell = [tableView dequeueReusableCellWithIdentifier:countCellIdentifier];
            countingCell.likeCountingLabel.text = @"68";
            countingCell.commentCountingLabel.text = @"32";
            return countingCell;
        }
        return nil;
    } else {
        CommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:commentCellIdentifier];
        NSInteger row = [indexPath row];
        self.comment = [self.comments objectAtIndex:row];
        commentCell.userInfoLabel.text = [self.comment objectForKey:@"userName"];
        commentCell.commentTextView.text = [self.comment objectForKey:@"comment"];
        return commentCell;
    }
}

#pragma mark - CommentInputView Delegate
-(void)commentInputView:(CommentInputView *)commentInputView clickOnCommentButtonAtIndex:(NSInteger)index {
    
    // 没能测试
    if (index == 1) {
        //NSDate *date = [NSDate date];
        //nsdate
        
        
        [StudyNetworkUtils submitCommentWithArticleId:self.articleInfo userInfo:self.userInfo commitDate:nil content:self.commentInputView.textView.text andCallback:^(id obj){
            NSDictionary *dic = obj;
            NSNumber *error = [dic objectForKey:@"error"];
            NSString *errorMessage = [dic objectForKey:@"errorMessage"];
            if ([error integerValue] == 1) {
                // 隐藏评论席位
                self.commentInputView.hidden = YES;
                [self removeActivityBackgroundView];
                [self.commentInputView.textView resignFirstResponder];
                // 添加评论并且更新视图
                [self.tableView beginUpdates];
                //[self.userComment insertObject:dic atIndex:0];
                [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationBottom];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
                [self.tableView endUpdates];
                
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                
                
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:errorMessage delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
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
