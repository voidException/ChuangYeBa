//
//  ClassViewController.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/2.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestViewController.h"
#import "ClassSettingViewController.h"
#import "ClassInfoCell.h"
#import "TestInfoCell.h"

@interface ClassViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ClassInfoCellDelegate, TestInfoCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UILabel *addClassLabel;
// 点击tableView的手势动作
@property (strong, nonatomic) UITapGestureRecognizer *singleTap;

// 是否已经加入班级
@property (nonatomic) BOOL isUserAddedClass;
// 临时变量
@property (nonatomic) BOOL isTested;

@end
