//
//  ClassViewController.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/2.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>
// 小区
#import "ClassInfoCell.h"
#import "TestInfoCell.h"
// 网络请求类
#import "ClassNetworkUtils.h"
// 模型
#import "ClassInfoCell.h"
#import "TestGroup.h"
#import "UserInfo.h"

@interface ClassViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ClassInfoCellDelegate, TestInfoCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

// 临时字符
@property (strong, nonatomic) UILabel *addClassLabel;

// 点击tableView的手势动作
@property (strong, nonatomic) UITapGestureRecognizer *singleTap;

@property (strong, nonatomic) ClassInfoCell *classInfo;

@property (strong, nonatomic) TestGroup *testGroup;

@property (strong, nonatomic) NSMutableArray *testGroupArray;

// 是否已经加入班级
@property (nonatomic) BOOL isUserAddedClass;
// 临时变量
@property (nonatomic) BOOL isTested;

@end
