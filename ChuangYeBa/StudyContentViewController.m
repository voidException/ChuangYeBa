//
//  StudyContentViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/2.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "StudyContentViewController.h"
#import "GlobalDefine.h"

static NSInteger const kPageSize = 5;

@interface StudyContentViewController ()

@end



@implementation StudyContentViewController
@synthesize tag;
@synthesize page;
@synthesize pageSize;
@synthesize articleInfo;
@synthesize userInfo;


#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self initUI];
    
    // 初始化Article模型
    articleInfo = [[ArticleInfo alloc] init];
    
    // 初始化数组
    self.articleList = [[NSMutableArray alloc] init];
    
    // TEST
    NSLog(@"tag = %ld", (long)tag);
    page = 1;
    pageSize = kPageSize;
    tag = 12;
    
    // 从本地读取用户信息
    [self loadUserInfoFromLocal];
    // TEST 请求
    // 注册接受用户登陆的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadUserInfoFromLocal) name:@"UserLogin" object:nil];
}



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 如果用户没有登陆，则不刷新列表
    if (userInfo.userId) {
        [self.tableView.legendHeader beginRefreshing];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method
- (void)initUI {
    // 增加下啦刷新
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        // YES说明是下拉刷新
        [self requestArticleListFromServer:YES];
    }];
    
    
    // 增加上啦刷新
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        NSLog(@"上啦刷新");
        // NO说明是上拉刷新
        [self requestArticleListFromServer:NO];
    }];
    self.tableView.footer.hidden = YES;
}

- (void)pullUpReload:(NSArray *)articleListArr{
    // 不移除全部数据
    for (NSDictionary *articleDic in articleListArr) {
        ArticleInfo *article = [StudyJsonParser parseArticleList:articleDic];
        [self.articleList addObject:article];
    }
    [self.tableView reloadData];
}

- (void)pullDownReload:(NSArray *)articleListArr{
    // 移除原来全部数据，并刷新
    [self.articleList removeAllObjects];
    for (NSDictionary *articleDic in articleListArr) {
        ArticleInfo *article = [StudyJsonParser parseArticleList:articleDic];
        [self.articleList addObject:article];
    }
    [self.tableView reloadData];
}

- (void)loadUserInfoFromLocal {
    userInfo = [[UserInfo alloc] init];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *udObject = [ud objectForKey:@"userInfo"];
    userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:udObject];
}

- (void)requestArticleListFromServer:(BOOL)isPullDownReload{
    NSInteger requestPage;
    NSInteger requestPageSize;
    page = self.articleList.count;
    if (self.articleList.count) {
        if (isPullDownReload) {
            requestPage = 0;
            requestPageSize = self.articleList.count;
        }
        
        else {
            requestPage = self.articleList.count;
            requestPageSize = kPageSize;
        }
    }
    else {
        requestPage = 0;
        requestPageSize = kPageSize;
    }
    
    [StudyNetworkUtils requestArticalWichToken:userInfo.email userId:userInfo.userId tag:tag page:requestPage pageSize:requestPageSize andCallback:^(id obj){
        
        if (obj) {
            // 请求成功后显示上拉刷新的模块
            self.tableView.footer.hidden = NO;
            
            NSDictionary *dic = obj;
            NSArray *articleListArr = [dic objectForKey:@"article"];
            //NSArray *arr = [dic objectForKey:@"article"];
            // 如果是下拉刷新整个文章列表
            if (isPullDownReload) {
                [self.tableView.header endRefreshing];
                [self pullDownReload:articleListArr];
            }
            // 如果是上拉刷新增加文章列表
            else {
                if (articleListArr.count) {
                    [self.tableView.footer endRefreshing];
                    [self pullUpReload:articleListArr];
                } else {
                    [self.tableView.footer noticeNoMoreData];
                }
            }
        }
    }];
}

#pragma mark -  Table View DataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 发送通知
    NSLog(@"send notif");
    ArticleInfo *article = self.articleList[indexPath.row];
    NSNumber *articleId = article.articleId;
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:articleId,@"articleId", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowStudyDetail" object:self userInfo:dic];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.articleList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *studyContentCellIndentifier = @"StudyContentCell";
    StudyContentCell *studyContentCell = [tableView dequeueReusableCellWithIdentifier:studyContentCellIndentifier];
    ArticleInfo *article = self.articleList[indexPath.row];
    studyContentCell.titleLabel.text = article.title;
    
    NSString *path = article.miniPhotoURL;
    static NSString *serverIP = SERVER_IP;
    path = [serverIP stringByAppendingString:path];

    [studyContentCell.mainImage setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"USA.png"]];
    
    studyContentCell.introductionLabel.text = article.viceTitle;
    return studyContentCell;
}


@end
