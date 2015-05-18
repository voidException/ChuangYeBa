//
//  StudyContentViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/2.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "StudyContentViewController.h"
#import "GlobalDefine.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImageManager.h>
#import "ArticleInfoDAO.h"
#import <MBProgressHUD.h>

static NSInteger const kPageSize = 8;

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
    
    // 从本地读取用户信息
    [self loadUserInfoFromLocal];
    
    // 从本地读取存储的cache
    [self loadArticleListCache];
    
    // 注册接受用户登陆的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadUserInfoFromLocal) name:@"UpdateUserInfo" object:nil];
}



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 重要！如果用户没有登陆，则不刷新列表，否则可能造成崩溃！
    if (userInfo.userId) {
        //[self.tableView.legendHeader beginRefreshing];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method
- (void)initUI {
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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
    self.tableView.footer.automaticallyRefresh = NO;
    self.tableView.footer.hidden = YES;
}



- (void)loadArticleListCache {
    ArticleInfoDAO *dao = [ArticleInfoDAO shareManager];
    self.articleList = [dao findAll:tag];
    if (!self.articleList.count) {
        // 防止
        if (self.userInfo) {
            [self.tableView.header beginRefreshing];
        }
    } else {
        [self.tableView reloadData];
        self.tableView.footer.hidden = NO;
    }
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
    
    // 创建文章列表缓存（最多7条）(以后文章多了改成20条)
    ArticleInfoDAO *dao = [ArticleInfoDAO shareManager];
    NSInteger max = 7;
    if (self.articleList.count > max) {
        NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[self.articleList objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, max)]]];
        [dao create:arr tag:tag];
    } else {
        [dao create:self.articleList tag:tag];
    }
}

- (void)loadUserInfoFromLocal {
    /*
    userInfo = [[UserInfo alloc] init];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *udObject = [ud objectForKey:@"userInfo"];
    userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:udObject];
     */
    self.userInfo = [[UserInfo alloc] initWithUserDefault];
    if (self.userInfo) {
        [self.tableView.footer beginRefreshing];
    }
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
    
    [StudyNetworkUtils requestArticlesWichToken:userInfo.email userId:userInfo.userId tag:tag page:requestPage pageSize:requestPageSize andCallback:^(id obj){
        
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        
        // 如果请求成功
        if (obj) {
            // 请求成功后显示上拉刷新的模块
            self.tableView.footer.hidden = NO;
            
            NSDictionary *dic = obj;
            NSArray *articleListArr = [dic objectForKey:@"article"];
            //NSArray *arr = [dic objectForKey:@"article"];
            // 如果是下拉刷新整个文章列表
            if (isPullDownReload) {
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
        } else { // 请求失败
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"errormark"]];
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.animationType = MBProgressHUDAnimationZoomIn;
            HUD.labelText = @"网络出错了>_<";
            [HUD show:YES];
            [HUD hide:YES afterDelay:1.0];
        }
    }];
}

#pragma mark - Table View delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
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
    //[studyContentCell.mainImage sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"studyContentPlaceholder"]];
    [studyContentCell.mainImage sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:path] andPlaceholderImage:[UIImage imageNamed:@"studyContentPlaceholder"] options:SDWebImageHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSLog(@"cacheType = %lu", cacheType);
    }];
    
    studyContentCell.likeLabel.text = [NSString stringWithFormat:@"%@", article.likes];
    studyContentCell.commentLabel.text = [NSString stringWithFormat:@"%@", article.comments];
    
    studyContentCell.introductionLabel.text = article.viceTitle;
    return studyContentCell;
}


@end
