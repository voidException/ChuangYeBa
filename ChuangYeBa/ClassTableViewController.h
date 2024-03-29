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
#import "CircleButton.h"
#import <NYSegmentedControl.h>
// 请求
#import "ClassNetworkUtils.h"
// 模型
#import "ClassInfo.h"
#import "UserInfo.h"


@interface ClassTableViewController : UITableViewController

//@property (strong, nonatomic) UISegmentedControl *segmentedControl;
@property (strong, nonatomic) NYSegmentedControl *segmentedControl;
@property (strong, nonatomic) UIButton *rightButton;
@property (strong, nonatomic) CircleButton *leftButton;

// 用于显示和保存列表的数组
@property (strong, nonatomic) NSMutableArray *allTestGroups;
@property (strong, nonatomic) NSMutableArray *testedGroup;
@property (strong, nonatomic) NSMutableArray *unTestedGroup;
@property (strong, nonatomic) NSMutableArray *displayTestGroup;

// 用户模型
@property (strong, nonatomic) UserInfo *userInfo;
@property (strong, nonatomic) ClassInfo *classInfo;
@property (strong, nonatomic) TestGroup *selectedTestGroup;


@end
