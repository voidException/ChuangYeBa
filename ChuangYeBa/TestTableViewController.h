//
//  TestTableViewController.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/11.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Quiz.h"
#import "NewQuestionCell.h"
#import "NewOptionCell.h"
#import "ExplainCell.h"

@interface TestTableViewController : UITableViewController <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *lastButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *submitButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;

@property (strong, nonatomic) UIBarButtonItem *backButton;
// 点击导航条左上角的返回键的警告框
@property (strong, nonatomic) UIAlertView *backAlertView;
// 点击提交键的警告框
@property (strong, nonatomic) UIAlertView *submitAlertView;

// 用户在当前题目所选择的小区IndexPath
@property (nonatomic, strong) NSIndexPath *selectedCellIndexPath;

// 用户选择的答案保存
@property (nonatomic, strong) NSMutableArray *userSelection;

// 和题目相关的属性
// 题组
@property (strong, nonatomic) NSMutableArray *quizs;
// 实现测试题对象
@property (strong, nonatomic) Quiz *quiz;
// 题目号
@property (nonatomic) NSUInteger quizNo;

// 是否显示解析
@property (nonatomic) BOOL isDisplayExplain;

// 按钮的Action
- (IBAction)clickOnLastButton:(id)sender;
- (IBAction)clickOnNextButton:(id)sender;
- (IBAction)clickOnSubmitButton:(id)sender;
- (void)clickOnBackButton;

@end
