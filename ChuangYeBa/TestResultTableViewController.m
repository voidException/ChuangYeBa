//
//  TestResultTableViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/23.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "TestResultTableViewController.h"
#import "ClassTableViewController.h"

static NSString *testScroeCellIdentifier = @"TestScoreCell";
static NSString *answerSheetCellIdentifier = @"AnswerSheetCell";
static NSString *articleCellIdentifier = @"ArticleCell";

@interface TestResultTableViewController ()

@property (nonatomic) NSNumber *numQuizNo;

@end


@implementation TestResultTableViewController
@synthesize testResultArray;

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
    [self parseTestResultArray];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.hidesBottomBarWhenPushed = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method
- (void)initUI {
    self.title = @"练习报告";
    // 注册Xib小区
    [self.tableView registerNib:[UINib nibWithNibName:@"TestScoreCell" bundle:nil] forCellReuseIdentifier:testScroeCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"AnswerSheetCell" bundle:nil] forCellReuseIdentifier:answerSheetCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"ArticleCell" bundle:nil] forCellReuseIdentifier:articleCellIdentifier];
    // 设置分割线的风格
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    UIBarButtonItem *quitButton = [[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:@selector(clickOnQuitButton)];
    self.navigationItem.leftBarButtonItem = quitButton;
}

- (void)parseTestResultArray {
    // 这里放到TestResultTVC中！
    // 初始化并分配内存
    self.userSelection = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.testResultArray.count; i++) {
        NSDictionary *testResultDic = self.testResultArray[i];
        // 解析有用的信息(用户对每个题目的选项),多余的信息就放弃了
        NSNumber *numSelection = [ClassJsonParser paresUserSelection:testResultDic];
        // 重要，因为在testTableViewController中的用户选择是用NSIndexPath对象来保存的(为了方便直接给TableViewCell赋值和操作)。所以在这里，提前把用户的的选择转换成NSIndexPath对象，并赋给section为1(在tableView中的section)。
        NSIndexPath *indexPathSelection = [NSIndexPath indexPathForRow:[numSelection integerValue] inSection:1];
        [self.userSelection addObject:indexPathSelection];
    }
}

#pragma mark - Action
- (void)clickOnQuitButton {
    //[self performSegueWithIdentifier:@"ShowClassScreen" sender:self];
    id vc = [self.navigationController.viewControllers objectAtIndex:0];
    [self.navigationController popToViewController:vc animated:YES];
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
            // TODO 在这里每一个小区的高度需要根据实际情况调整的
        case 0:
            return 225;
            break;
        case 1:
        {
            NSUInteger rowOfCollectionCell;
            if (self.quizs.count % 5) {
                rowOfCollectionCell = self.quizs.count/5 + 1;
            } else {
                rowOfCollectionCell = self.quizs.count/5;
            }
            return rowOfCollectionCell * 58 + 90;
            break;
        }
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
            testScoreCell.scoreLabel.text = [NSString stringWithFormat:@"%@",[[self.testResultArray objectAtIndex:0] objectForKey:@"itemresult"]];
        }
        return testScoreCell;
    } else if (indexPath.row == 1) {
        AnswerSheetCell *answerSheetCell = [tableView dequeueReusableCellWithIdentifier:answerSheetCellIdentifier];
        answerSheetCell.delegate = self;
        [answerSheetCell setValue:self.testResultArray forKey:@"testResultArray"];
        [answerSheetCell reloadData];
        return answerSheetCell;
    } else {
        ArticleCell *articleCell = [tableView dequeueReusableCellWithIdentifier:articleCellIdentifier];
        articleCell.content.text = @"蓝色回答正确，红色回答错误，点击题号查看题目的详细解析";
        articleCell.content.textColor = [UIColor colorWithRed:126.0/255 green:126.0/255 blue:126.0/255 alpha:1];
        articleCell.content.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
        return articleCell;
    }
}

#pragma mark - Answer Sheet Delegate
- (void)answerSheet:(AnswerSheetCell *)answerSheet didSelectedAtIndexPath:(NSIndexPath *)indexPath {
    // 因为题号是从1开始的，但是indexPath是从0开始算，所以要+1
    self.numQuizNo = [NSNumber numberWithInteger:indexPath.row + 1];
    [self performSegueWithIdentifier:@"ShowTestExplain" sender:self];
}
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowTestExplain"]) {
        id destinationVC = [segue destinationViewController];
        [destinationVC setValue:@YES forKey:@"isShowExplain"];
        [destinationVC setValue:self.quizs forKey:@"quizs"];
        [destinationVC setValue:self.numQuizNo forKey:@"numQuizNo"];
        [destinationVC setValue:self.userSelection forKey:@"userSelection"];
    }
}

@end
