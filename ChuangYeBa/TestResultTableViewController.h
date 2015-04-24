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


@interface TestResultTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *testResultArray;

@end
