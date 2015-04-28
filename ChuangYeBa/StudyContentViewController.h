//
//  StudyContentViewController.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/2.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh.h>
#import "StudyContentCell.h"
#import "StudyNetworkUtils.h"
#import "StudyJsonParser.h"
#import "ArticleInfo.h"
#import "UserInfo.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <AFNetworking/UIKit+AFNetworking.h>

@interface StudyContentViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) ArticleInfo *articleInfo;
@property (strong, nonatomic) UserInfo *userInfo;
@property (strong, nonatomic) NSMutableArray *articleList;

// 当前的VC属于哪一个分类Tag
@property (nonatomic) NSInteger tag;
// 当前的Page
@property (nonatomic) NSInteger page;
// 每下拉刷新出现的个数
@property (nonatomic) NSInteger pageSize;


@end
