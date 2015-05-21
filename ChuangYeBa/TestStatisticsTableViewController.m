//
//  TestStatisticsTableViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/5/20.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "TestStatisticsTableViewController.h"
#import "AccuracyStatisticsCell.h"
#import "ClassNetworkUtils.h"
#import "TestGroup.h"
#import "Quiz.h"
#import <MBProgressHUD.h>

static NSString *accuracyCellIdentifier = @"AccuracyCell";

@interface TestStatisticsTableViewController ()

@property (nonatomic) BOOL isShowAccuracyAnimate;
@property (strong, nonatomic) NSArray *testStatistics;
// 显示动画用
//@property (strong, nonatomic) NSArray *displayStatistics;
@property (strong, nonatomic) NSMutableArray *quizs;
@property (strong, nonatomic) TestGroup *testGroup;
@property (strong, nonatomic) NSNumber *selectedQuiz;

@end

@implementation TestStatisticsTableViewController

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.quizs = [[NSMutableArray alloc] init];
    [self initUI];
    _isShowAccuracyAnimate = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    _isShowAccuracyAnimate = YES;
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    _isShowAccuracyAnimate = NO;
}

#pragma mark - Private method
- (void)initUI {
    self.title = @"答题报告";
    
    // 初始化tableView
    self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 初始化头视图
    float margin = 8.0;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, 15, self.view.frame.size.width - 2 * margin, 30)];
    titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    titleLabel.numberOfLines = 1;
    [headerView addSubview:titleLabel];
    titleLabel.text = _testGroup.itemTitle;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    NSLog(@"%@", _testGroup.itemTitle);
    
    self.tableView.tableHeaderView = headerView;
}

- (void)requestQuizsFromServer {
    if (self.quizs.count) {
        return;
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        [ClassNetworkUtils requestQuizsByitemId:_testGroup.itemId andCallback:^(id obj){
            // 隐藏HUD
            [hud hide:YES];
            // 接回调对象
            NSDictionary *dic = obj;
            // 接受错误信息
            NSNumber *error = [dic objectForKey:@"error"];
            NSString *errorMessage = [dic objectForKey:@"errorMessage"];
            
            if ([error integerValue] == 1) {
                // 给题组赋值
                NSArray *quizsArr = [dic objectForKey:@"test"];
                
                if (!self.quizs) {
                    self.quizs = [[NSMutableArray alloc] init];
                }
                // 从接收到的JSON对象解析出每个题目的信息，保存到quizs数组当中
                [self.quizs removeAllObjects];
                for (NSDictionary *quizsDic in quizsArr) {
                    Quiz *qz = [ClassJsonParser parseQuiz:quizsDic];
                    [self.quizs addObject:qz];
                }
                [self performSegueWithIdentifier:@"ShowTestGroup" sender:self];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:errorMessage delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
    }
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger interger = [indexPath row] + 1;
    _selectedQuiz = [NSNumber numberWithInteger:interger];
    if (_quizs.count) {
        [self performSegueWithIdentifier:@"ShowTestGroup" sender:self];
    } else {
        [self requestQuizsFromServer];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _testStatistics.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AccuracyStatisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:accuracyCellIdentifier];
    if (cell == nil) {
        cell = [[AccuracyStatisticsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:accuracyCellIdentifier];
    }
    cell.quizStatistics = _testStatistics[indexPath.row];
    if (_isShowAccuracyAnimate) {
        [cell beginAnimate];
    }
    return cell;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id destinationVC = [segue destinationViewController];
    if ([segue.identifier isEqualToString:@"ShowTestGroup"]) {
        // 把下载的题组信息传递给TestTVC
        [destinationVC setValue:self.quizs forKey:@"quizs"];
        // 把测试题组号传递给TestTVC，为了封装提交的测试结果
        [destinationVC setValue:self.testGroup.itemId forKey:@"itemId"];
        [destinationVC setValue:[NSNumber numberWithBool:YES] forKey:@"isShowExplain"];
        [destinationVC setValue:self.selectedQuiz forKey:@"numQuizNo"];

    }
}

@end
