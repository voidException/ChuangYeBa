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
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <AFNetworking/UIKit+AFNetworking.h>

@interface StudyContentViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSInteger tag;
@property (nonatomic) NSInteger page;
@property (nonatomic) NSInteger pageSize;


@end
