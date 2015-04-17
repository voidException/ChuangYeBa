//
//  TestTableViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/11.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "TestTableViewController.h"

static NSString *questionCellIdentifer = @"NewQuestionCell";
static NSString *optionCellIdentifer = @"NewOptionCell";
static NSString *explainCellIdentifer = @"ExplainCell";

@interface TestTableViewController ()

@end

@implementation TestTableViewController

@synthesize quizNo;
@synthesize isDisplayExplain;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 注册xib的题干和选项的cell
    [self.tableView registerNib:[UINib nibWithNibName:@"NewQuestionCell" bundle:nil] forCellReuseIdentifier:questionCellIdentifer];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"NewOptionCell" bundle:nil] forCellReuseIdentifier:optionCellIdentifer];
    // 如果需要显示答案，注册显示答案的cell
    if (isDisplayExplain) {
        [self.tableView registerNib:[UINib nibWithNibName:@"ExplainCell" bundle:nil] forCellReuseIdentifier:explainCellIdentifer];
    }
    // 初始化导航条左键
    self.backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(clickOnBackButton)];
    self.navigationItem.leftBarButtonItem = self.backButton;
    
    // 初始化用户选择答案的数组
    self.userSelection = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithBool:NO], nil];
    
    // 初始化题目对象
    self.quiz = [[Quiz alloc] init];
    // 初始化题组对象
    self.quizs = [[NSMutableArray alloc] init];
    // 初始化测试题组，初始化当前题目号
    self.quizNo = 1;
    // 初始化上一题按钮，上一题按钮不可用
    [self.lastButton setEnabled:NO];
    
    // 从服务器请求题组
    [self requestQuizs];
    
    NSLog(@"is displayexplain = %d", isDisplayExplain);
}


// 从服务器请求题组
- (void)requestQuizs {
    // 模拟了Quizs模型从网络获取并解析的过程。实际上self.quiz应该由经过网络请求后的Quiz对象的属性获得
    /*
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"quizs" ofType:@"plist"];
    self.quizs = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    */
    NSNumber *itemId = [NSNumber numberWithInteger:1];
    [ClassNetworkUtils requestQuizsByitemId:itemId andCallback:^(id obj){
        
        // 延时函数，模拟读取比较久的过程。
        [NSThread sleepForTimeInterval:2.0];
        
        // 接回调对象
        NSDictionary *dic = obj;
        // 接受错误信息
        NSNumber *error = [dic objectForKey:@"error"];
        NSString *errorMessage = [dic objectForKey:@"errorMessage"];
        
        if ([error integerValue] == 1) {
            // 给题组赋值
            self.quizs = [dic objectForKey:@"test"];
            // 加载题目
            [self loadQuiz:self.quizNo];
            
            // 初始化记录用户选择的数组
            for (int i = 1; i < self.quizs.count; i++) {
                [self.userSelection addObject:[NSNumber numberWithBool:NO]];
            }
            // 重新加载tabelview
            [self.tableView reloadData];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:errorMessage delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

- (void)loadQuiz:(NSUInteger)interger {
    NSDictionary *dic = [self.quizs objectAtIndex:interger - 1];
    self.quiz = [ClassJsonParser parseQuiz:dic];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.toolbarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.toolbarHidden = YES;
}

#pragma mark - Table View Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [self.quiz getHeightOfQuizString:self.quiz.question];
    } else if (indexPath.section == 1) {
        // TODO
        float heigth = [self.quiz getHeightOfQuizString:self.quiz.options[indexPath.row]];
        if (heigth < 50) {
            return 50;
        } else {
            return heigth;
        }
    } else {
        // TODO 需要增加explainCell两个label的高度。
        return [self.quiz getHeightOfQuizString:self.quiz.answerExplain] + 40;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NewOptionCell *cell = (NewOptionCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if (self.selectedCellIndexPath) {
         NewOptionCell *lastSelectedCell = (NewOptionCell *)[self.tableView cellForRowAtIndexPath:self.selectedCellIndexPath];
        if (![self.selectedCellIndexPath isEqual:indexPath]) {
            lastSelectedCell.checkImage.hidden = YES;
        }
    }
    if (cell.checkImage.isHidden) {
        cell.checkImage.hidden = NO;
        self.selectedCellIndexPath = indexPath;
        [self.userSelection replaceObjectAtIndex:(quizNo - 1) withObject:self.selectedCellIndexPath];
    } else {
        cell.checkImage.hidden = YES;
        self.selectedCellIndexPath = nil;
        [self.userSelection replaceObjectAtIndex:(quizNo - 1) withObject:[NSNumber numberWithBool:NO]];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.quizs) {
        if (isDisplayExplain) {
            return 3;
        } else {
            return 2;
        }
    } else return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.quizs) {
        switch (section) {
            case 0:
                return 1;
                break;
            case 1:
                return 4;
                break;
            case 2:
                return 1;
                break;
            default:
                return 0;
                break;
        }
    } else return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        NewQuestionCell *questionCell = [tableView dequeueReusableCellWithIdentifier:questionCellIdentifer];
        questionCell.textView.text = self.quiz.question;
        return questionCell;
    } else if (indexPath.section == 1) {
        NewQuestionCell *optionCell = [tableView dequeueReusableCellWithIdentifier:optionCellIdentifer];
        optionCell.textView.text = self.quiz.options[indexPath.row];
        return optionCell;
    } else {
        ExplainCell *explainCell = [tableView dequeueReusableCellWithIdentifier:explainCellIdentifer];
        explainCell.explainTextView.text = self.quiz.answerExplain;
        
        // 显示正确答案
        switch ([self.quiz.answerOption integerValue]) {
            case 1:
                explainCell.anwserLabel.text = @"A";
                break;
            case 2:
                explainCell.anwserLabel.text = @"B";
                break;
            case 3:
                explainCell.anwserLabel.text = @"C";
                break;
            case 4:
                explainCell.anwserLabel.text = @"D";
                break;
            default:
                explainCell.anwserLabel.text = nil;
                break;
        }
        return explainCell;
    }
}


- (IBAction)clickOnLastButton:(id)sender {
    if (quizNo > 1) {
        // 题号减小
        quizNo --;
        // 设置button是否可用
        [self.nextButton setEnabled:YES];
        if (quizNo == 1) {
            [self.lastButton setEnabled:NO];
        } else {
            [self.lastButton setEnabled:YES];
        }
        [self changeQuizAction];
    }
}

- (IBAction)clickOnNextButton:(id)sender {
    if (quizNo < self.quizs.count) {
        // 题号增加
        quizNo ++;
        // 设置button是否可用
        [self.lastButton setEnabled:YES];
        if (quizNo == self.quizs.count) {
            [self.nextButton setEnabled:NO];
        } else {
            [self.nextButton setEnabled:YES];
        }
        [self changeQuizAction];
    }
}

- (void)changeQuizAction {
    // 加载下一个题目
    [self loadQuiz:quizNo];
    [self.tableView reloadData];
    
     NewOptionCell *thisOption = (NewOptionCell *)[self.tableView cellForRowAtIndexPath:self.selectedCellIndexPath];
    thisOption.checkImage.hidden = YES;
    self.selectedCellIndexPath = nil;
    
    // 读取该题用户是否已经做过选择，如果有则帮助用户选取已经选过的选项
    if (![self.userSelection[quizNo - 1] isEqual:[NSNumber numberWithBool:NO]]) {
        self.selectedCellIndexPath = self.userSelection[quizNo - 1];
        NewOptionCell *cell = (NewOptionCell *)[self.tableView cellForRowAtIndexPath:self.selectedCellIndexPath];
        cell.checkImage.hidden = NO;
    }
}

- (IBAction)clickOnSubmitButton:(id)sender {
    for (int i = 0; i < self.quizs.count; i++) {
        if ([self.userSelection[i] isEqual:[NSNumber numberWithBool:NO]]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention" message:@"You didn't finish all tests!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            break;
            // 是否提交数据 = NO
        }
    }
    // IF是否提交数据，如果为YES，则提交数据
}

- (void)clickOnBackButton {
    self.backAlertView = [[UIAlertView alloc] initWithTitle:@"attention" message:@"Are you sure? Your selection would not be save unless you submit them!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sure", nil];
    [self.backAlertView show];
    //[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Alert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView == self.backAlertView) {
        if (buttonIndex == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

@end
