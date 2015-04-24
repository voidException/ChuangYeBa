//
//  TestResultTableViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/23.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "TestResultTableViewController.h"

static NSString *testScroeCellIdentifier = @"TestScoreCell";
static NSString *answerSheetCellIdentifier = @"AnswerSheetCell";
static NSString *articleCellIdentifier = @"ArticleCell";

@interface TestResultTableViewController ()

@end


@implementation TestResultTableViewController
@synthesize testResultArray;

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 注册Xib小区
    [self.tableView registerNib:[UINib nibWithNibName:@"TestScoreCell" bundle:nil] forCellReuseIdentifier:testScroeCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"AnswerSheetCell" bundle:nil] forCellReuseIdentifier:answerSheetCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"ArticleCell" bundle:nil] forCellReuseIdentifier:articleCellIdentifier];
    // 设置分割线的风格
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return 220;
            break;
        case 1:
            return 300;
            break;
        case 2:
            return 100;
            break;
        default:
            return 44;
            break;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 固定的3个小区
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        TestScoreCell *testScoreCell = [tableView dequeueReusableCellWithIdentifier:testScroeCellIdentifier];
        if (self.testResultArray) {
            testScoreCell.scoreLabel.text = [[self.testResultArray objectAtIndex:0] objectForKey:@"itemresult"];
        }
        return testScoreCell;
    } else if (indexPath.row == 1) {
        AnswerSheetCell *answerSheetCell = [tableView dequeueReusableCellWithIdentifier:answerSheetCellIdentifier];
        [answerSheetCell setValue:self.testResultArray forKey:@"testResultArray"];
        [answerSheetCell reloadData];
        return answerSheetCell;
    } else {
        ArticleCell *articleCell = [tableView dequeueReusableCellWithIdentifier:articleCellIdentifier];
        articleCell.content.text = @"蓝色回答正确，红色回答错误，点击题号查看题目的详细解析";
        return articleCell;
    }
}

@end
