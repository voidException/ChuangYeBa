//
//  TestResultTableViewController.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/23.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>
// 视图
#import "ArticleCell.h"
#import "TestScoreCell.h"
#import "AnswerSheetCell.h"


@interface TestResultTableViewController : UITableViewController <AnswerSheetDelegate>

@property (strong, nonatomic) NSMutableArray *testResultArray;
@property (strong, nonatomic) NSMutableArray *userSelection;

// 用来传递下载下来的题组数组
@property (strong, nonatomic) NSMutableArray *quizs;

@end
