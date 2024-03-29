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
#import "GlobalDefine.h"

static NSInteger const kPageSize = 20;

static NSString *studyContentCellIndentifier = @"StudyContentCell";

@interface StudyContentViewController ()

@end

@implementation StudyContentViewController
@synthesize tagNo;
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
    NSLog(@"tag = %ld", (long)tagNo);
    page = 1;
    pageSize = kPageSize;
    
    // 从本地读取用户信息
    self.userInfo = [UserInfo loadUserInfoFromLocal];
    
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private Method
- (void)initUI {
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"StudyContentCell" bundle:nil] forCellReuseIdentifier:studyContentCellIndentifier];
    // 增加下啦刷新（并保存上次刷新时的时间）
    NSString *dateKey = [NSString stringWithFormat:@"StudyContentHeaderDateKey%ld", (long)tagNo];
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        // YES说明是下拉刷新
        [self requestArticleListFromServer:YES];
    } dateKey:dateKey];
    // 增加上啦刷新
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        NSLog(@"上啦刷新");
        // NO说明是上拉刷新
        [self requestArticleListFromServer:NO];
    }];
    self.tableView.footer.automaticallyRefresh = NO;
    self.tableView.footer.hidden = YES;
}

- (void)loadUserInfoFromLocal {
    self.userInfo = [UserInfo loadUserInfoFromLocal];
    [self.tableView.header beginRefreshing];
}

/**
 *  读取本地缓存的文章列表
 *  如果本地缓存的文章的日期比当前日期相聚一天以上，则主动刷新重新缓存
 */
- (void)loadArticleListCache {
    ArticleInfoDAO *dao = [ArticleInfoDAO shareManager];
    NSString *fileName = [NSString stringWithFormat:@"AriticleListCache%lu.archive", tagNo];
    self.articleList = [dao findAll:fileName];

    // 检查本地是否有缓存，没有缓存则主动刷新，有缓存则判断是否缓存过时，过时了则主动刷新
    if (!self.articleList.count) {
        // 防止在用户没有登陆的情况下刷新列表造成崩溃
        if (self.userInfo) {
            [self.tableView.header beginRefreshing];
        }
    } else {
        NSDate *lastCachedDate = [[NSUserDefaults standardUserDefaults] objectForKey:self.tableView.header.dateKey];
        NSTimeInterval secondsInterval = [lastCachedDate timeIntervalSinceNow];
        if (secondsInterval < - 24 * 60 * 60) {
            [self.tableView.header beginRefreshing];
        } else {
            // 由于重新加载了articleList，所以需要reloadData
            [self.tableView reloadData];
            self.tableView.footer.hidden = NO;
        }
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
    NSInteger max = 20;
    NSString *fileName = [NSString stringWithFormat:@"AriticleListCache%lu.archive", tagNo];
    if (self.articleList.count > max) {
        NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[self.articleList objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, max)]]];
        [dao create:arr flieName:fileName];
    } else {
        [dao create:self.articleList flieName:fileName];
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
    
    [StudyNetworkUtils requestArticlesWichToken:userInfo.email userId:userInfo.userId tag:tagNo page:requestPage pageSize:requestPageSize andCallback:^(id obj){
        
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        
        // 如果请求成功
        if (obj) {
            // 请求成功后显示上拉刷新的模块
            self.tableView.footer.hidden = NO;
            
            NSDictionary *dic = obj;
            NSArray *articleListArr = [dic objectForKey:@"article"];
            NSNumber *error = [dic objectForKey:@"error"];
            if ([error isEqual:@1]) {
                // 如果是下拉刷新整个文章列表
                if (isPullDownReload) {
                    [self pullDownReload:articleListArr];
                }
                // 如果是上拉刷新增加文章列表
                else {
                    if (articleListArr.count) {
                        [self.tableView.footer endRefreshing];
                        [self pullUpReload:articleListArr];
                    }
                }
            } else {
                [self.tableView.footer noticeNoMoreData];
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
    if (iPhone4 || iPhone5) {
        return 77;
    } else {
        return 90;
    }
}

#pragma mark -  Table View DataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ArticleInfo *article = self.articleList[indexPath.row];
    NSNumber *articleId = article.articleId;
    NSDictionary *dic = @{@"articleId":articleId, @"tagNo":[NSNumber numberWithInteger:tagNo]};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowStudyDetail" object:self userInfo:dic];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.articleList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    StudyContentCell *studyContentCell = [tableView dequeueReusableCellWithIdentifier:studyContentCellIndentifier];
    ArticleInfo *article = self.articleList[indexPath.row];
    studyContentCell.titleLabel.text = article.title;
    
    NSString *path = article.miniPhotoURL;
    [studyContentCell.mainImage sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"studyContentPlaceholderSmall"]];
    
    studyContentCell.likeLabel.text = [NSString stringWithFormat:@"%@", article.likes];
    studyContentCell.commentLabel.text = [NSString stringWithFormat:@"%@", article.comments];
    
    // 如果副标题超过25个字符，则需要截断
    NSString *viceTitle = article.viceTitle;
    NSUInteger maxLength = 27;
    if (article.viceTitle.length > maxLength) {
        viceTitle = [article.viceTitle stringByReplacingCharactersInRange: NSMakeRange(maxLength, article.viceTitle.length - maxLength) withString:@"..."];
    }
    studyContentCell.introductionLabel.text = viceTitle;
    
    
    return studyContentCell;
}


@end
