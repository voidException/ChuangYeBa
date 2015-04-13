//
//  TestViewController.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/8.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionCell.h"
#import "OptionCell.h"
#import "TestGroup.h"
#import "Quiz.h"

@interface TestViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *lastButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *submmitButton;

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

- (IBAction)clickOnNextButton:(id)sender;
- (IBAction)clickOnLastButton:(id)sender;
- (IBAction)clickOnSubmmitButton:(id)sender;

@end
