//
//  TestViewController.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/25.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>
// 模型文件
#import "ClassInfo.h"
#import "Quiz.h"
#import "UserInfo.h"
// 视图
#import "QuestionCell.h"
#import "OptionCell.h"
#import "ExplainCell.h"
#import "TestStateCell.h"
// 网络和解析
#import "ClassNetworkUtils.h"
#import "ClassJsonParser.h"

@interface TestViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *lastButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

// 左上角的返回按钮
@property (strong, nonatomic) UIBarButtonItem *backButton;
// 用户在当前题目所选择的小区IndexPath
@property (nonatomic, strong) NSIndexPath *selectedCellIndexPath;
// 用户选择的答案保存
@property (nonatomic, strong) NSMutableArray *userSelection;
// 正确的答案保存
@property (nonatomic, strong) NSMutableArray *anwserSelection;

// 和题目相关的属性
// 题组号，用来请求下载题组
@property (strong, nonatomic) NSNumber *itemId;
// 题组，修改成普通Array
@property (strong, nonatomic) NSMutableArray *quizs;
// 实现测试题对象
@property (strong, nonatomic) Quiz *quiz;
// 题目号
@property (nonatomic) NSInteger quizNo;

// 班级对象
@property (strong, nonatomic) ClassInfo *classInfo;
// 学生对象
@property (strong, nonatomic) UserInfo *userInfo;

@property (strong, nonatomic) NSMutableArray *testResultArray;

// 是否显示解析
@property (nonatomic, strong) NSNumber *isShowExplain;

// 按钮的Action
- (IBAction)clickOnLastButton:(id)sender;
- (IBAction)clickOnNextButton:(id)sender;
- (IBAction)clickOnSubmitButton:(id)sender;
- (void)clickOnBackButton;


@end
