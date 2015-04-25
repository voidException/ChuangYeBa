//
//  StudyDetailTableViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/16.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "StudyDetailTableViewController.h"

static NSString *articleTitleCellIdentifier = @"ArticleTitleCell";
static NSString *articleCellIdentifier = @"ArticleCell";
static NSString *mediaCellIdentifier = @"MediaCell";
static NSString *countCellIdentifier = @"CountingCell";
static NSString *commentCellIdentifier = @"CommentCell";


@interface StudyDetailTableViewController ()

@end

@implementation StudyDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"学习详情";
    
    self.navigationController.navigationBar.hidden = YES;
    UINavigationBar *testBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 64)];
    
    [self.view addSubview:testBar];
    
    // 注册xib的cell
    [self.tableView registerNib:[UINib nibWithNibName:@"ArticleTitleCell" bundle:nil] forCellReuseIdentifier:articleTitleCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"ArticleCell" bundle:nil] forCellReuseIdentifier:articleCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"MediaCell" bundle:nil] forCellReuseIdentifier:mediaCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"CountingCell" bundle:nil] forCellReuseIdentifier:countCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil] forCellReuseIdentifier:commentCellIdentifier];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommentInputView" owner:self options:nil];
    self.commentInputView = [nib objectAtIndex:0];
    
    self.commentInputView.delegate = self;
    
    
    [self.view addSubview:self.commentInputView];
    self.commentInputView.hidden = YES;
    
    
    self.commentButton.width = 200;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 读取文章
    [self loadArticle];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavigationBarAttributes {
#warning 普通！导航条修改颜色有问题
    /*
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
     */
}


- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setToolbarHidden:NO animated:NO];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 7, 200, 30)];
    imageView.image = [UIImage imageNamed:@"commentBG"];
    [self.navigationController.toolbar insertSubview:imageView aboveSubview:self.navigationController.toolbar];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setToolbarHidden:YES animated:YES];
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
        
        return mediaCell;

    } else if (indexPath.row == 3) {
        CountingCell *countingCell = [tableView dequeueReusableCellWithIdentifier:countCellIdentifier];
        countingCell.likeCountingLabel.text = @"68";
        countingCell.commentCountingLabel.text = @"32";
        return countingCell;
    }
    return nil;
}

#pragma mark - CommentInputView Delegate
-(void)commentInputView:(CommentInputView *)commentInputView clickOnCommentButtonAtIndex:(NSInteger)index {
    if (index == 1) {
        self.commentInputView.hidden = YES;
        [self removeActivityBackgroundView];
        self.tableView.scrollEnabled = YES;
        [self.commentInputView.textView resignFirstResponder];
    } else {
        NSLog(@"cancel");
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickOnCommentButton:(id)sender {
    NSLog(@"commentButton clicked");
    [self addActivityBackgroundView];
    self.commentInputView.frame = CGRectMake(self.tableView.contentOffset.x, self.tableView.contentOffset.y + 180, self.view.frame.size.width, 150);
    [self.view addSubview:self.commentInputView];
    self.commentInputView.hidden = NO;
    self.tableView.scrollEnabled = NO;
    [self.commentInputView.textView becomeFirstResponder];
    //[self.view bringSubviewToFront:self.commentInputView];

}

- (IBAction)clickOnLikeButton:(id)sender {
    
}
@end
