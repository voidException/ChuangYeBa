//
//  TestDetailViewController.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/24.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestGroup.h"
#import <MBProgressHUD.h>
#import "ClassNetworkUtils.h"
#import "ClassJsonParser.h"
#import "Quiz.h"
#import "BorderRadiusButton.h"

@interface TestDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet BorderRadiusButton *showTestResultButton;
@property (weak, nonatomic) IBOutlet BorderRadiusButton *startTestButton;
@property (weak, nonatomic) IBOutlet UILabel *publishTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *testCategoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *numOfTestLabel;

// 用来传递参数和接受参数
// 开始测试时，给TestTableViewController的测试结果封装提供参数
@property (strong, nonatomic) TestGroup *testGroup;
// 开始测试时，传递给TestTableViewController
@property (strong, nonatomic) NSMutableArray *quizs;
// 查看结果时，传递给TestResultTableViewController
@property (strong, nonatomic) NSMutableArray *testResultArray;

- (IBAction)clickOnStartTestButton:(id)sender;
- (IBAction)clickOnTestResultButton:(id)sender;

@end
