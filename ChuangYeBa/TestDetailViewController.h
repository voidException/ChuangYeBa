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

@interface TestDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *showTestResultButton;
@property (weak, nonatomic) IBOutlet UIButton *startTestButton;
@property (weak, nonatomic) IBOutlet UILabel *publishTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *testCategoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *numOfTestLabel;
// 用来传递参数
@property (strong, nonatomic) TestGroup *testGroup;
@property (strong, nonatomic) NSMutableArray *quizs;

- (IBAction)clickOnStartTestButton:(id)sender;
- (IBAction)clickOnTestResultButton:(id)sender;

@end
