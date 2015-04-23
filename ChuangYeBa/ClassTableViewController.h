//
//  ClassTableViewController.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/20.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>
// 视图
#import <MJRefresh.h>
#import "TestGroupCell.h"
#import "TestGroup.h"
// 请求
#import "ClassNetworkUtils.h"
// 模型
#import "ClassInfo.h"
#import "UserInfo.h"


@interface ClassTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftButton;

@property (strong, nonatomic) NSMutableArray *allTestGroups;
@property (strong, nonatomic) NSMutableArray *testedGroup;
@property (strong, nonatomic) NSMutableArray *unTestedGroup;
@property (strong, nonatomic) NSMutableArray *displayTestGroup;

@property (strong, nonatomic) UserInfo *userInfo;

@property (strong, nonatomic) NSNumber *selectedTestGroupId;

@property (nonatomic) BOOL isUserAddedClass;


@end