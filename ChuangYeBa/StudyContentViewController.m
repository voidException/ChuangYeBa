//
//  StudyContentViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/2.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "StudyContentViewController.h"

@interface StudyContentViewController ()

@end



@implementation StudyContentViewController
@synthesize tag;
@synthesize page;
@synthesize pageSize;
@synthesize articleInfo;
@synthesize userInfo;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    
    // 初始化Article模型
    articleInfo = [[ArticleInfo alloc] init];
    userInfo = [[UserInfo alloc] init];
    
    // 增加下啦刷新
    
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        NSLog(@"load refresh");
        [self.tableView.header endRefreshing];
    }];
    [self.tableView.legendHeader beginRefreshing];
    
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        NSLog(@"上啦刷新");
        //[self.tableView.footer endRefreshing];
    }];
    
    // TEST
    NSLog(@"tag = %ld", (long)tag);
    page = 0;
    pageSize = 10;

    
    // 从本地读取用户信息
    [self loadUserInfoFromLocal];
    // TEST 请求
    
#warning 严重！以下的方法在当用户在没有登陆过的情况下，第一次启动应用的时候会产生崩溃！因此暂时注释掉
    //[self requestArticleList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loadUserInfoFromLocal {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *udObject = [ud objectForKey:@"userInfo"];
    userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:udObject];
}

- (void)requestArticleList {
    [StudyNetworkUtils requestArticalWichToken:userInfo.email userId:userInfo.userId tag:tag page:page pageSize:pageSize andCallback:^(id obj){
        self.articleInfo = obj;
        NSLog(@"article callback");
    }];
}

#pragma mark - UITableViewDataSource

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 发送通知
    NSLog(@"send notif");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowStudyDetail" object:self userInfo:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *studyContentCellIndentifier = @"StudyContentCell";
    StudyContentCell *studyContentCell = [tableView dequeueReusableCellWithIdentifier:studyContentCellIndentifier];
    studyContentCell.titleLabel.text = @"什么是生涯";
    NSURL *imageURL = [[NSURL alloc]initWithString:@"http://cdn.cocimg.com/bbs/images/face/none.gif"];
    [studyContentCell.mainImage setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"USA.png"]];
    studyContentCell.introductionLabel.text = @"大学生生涯是职业生涯积累也是一个过程……";
    return studyContentCell;
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
