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
static NSString *testStateCellIdentifier = @"TestStateCell";

@interface TestTableViewController ()

@end

@implementation TestTableViewController

@synthesize quizNo;
@synthesize isDisplayExplain;
@synthesize itemId;

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 注册xib的题干和选项的cell
    [self.tableView registerNib:[UINib nibWithNibName:@"NewQuestionCell" bundle:nil] forCellReuseIdentifier:questionCellIdentifer];
    [self.tableView registerNib:[UINib nibWithNibName:@"NewOptionCell" bundle:nil] forCellReuseIdentifier:optionCellIdentifer];
    [self.tableView registerNib:[UINib nibWithNibName:@"TestStateCell" bundle:nil] forCellReuseIdentifier:testStateCellIdentifier];
    // 如果需要显示答案，注册显示答案的cell
    if (isDisplayExplain) {
        [self.tableView registerNib:[UINib nibWithNibName:@"ExplainCell" bundle:nil] forCellReuseIdentifier:explainCellIdentifer];
    }
    // 初始化导航条左键
    self.backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(clickOnBackButton)];
    self.navigationItem.leftBarButtonItem = self.backButton;
    // 初始化tableView设置
    self.title = @"练习题";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.tableView.backgroundColor = [UIColor whiteColor];
    
    // 初始化用户选择答案的数组
    self.userSelection = [[NSMutableArray alloc] init];
    // 初始化题目对象
    self.quiz = [[Quiz alloc] init];
    // 初始化题组对象
    self.quizs = [[NSMutableArray alloc] init];
    // 初始化测试题组，初始化当前题目号
    self.quizNo = 1;
    // 初始化存储测试结果的数组
    self.testResultArray = [[NSMutableArray alloc] init];
    // 初始化上一题按钮，上一题按钮不可用
    [self.lastButton setEnabled:NO];
    
    // 从本地取得教室信息
    [self loadClassInfoFromLocal];
    // 从服务器请求题
    [self requestQuizsFromServer];
    
    NSLog(@"is displayexplain = %d", isDisplayExplain);
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.toolbarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.toolbarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Private Method
// 从服务器请求题组
- (void)requestQuizsFromServer {
    [ClassNetworkUtils requestQuizsByitemId:itemId andCallback:^(id obj){
        // 接回调对象
        NSDictionary *dic = obj;
        // 接受错误信息
        NSNumber *error = [dic objectForKey:@"error"];
        NSString *errorMessage = [dic objectForKey:@"errorMessage"];
        
        if ([error integerValue] == 1) {
            // 给题组赋值
            NSArray *quizsArr = [dic objectForKey:@"test"];
            
            for (NSDictionary *quizsDic in quizsArr) {
                Quiz *qz = [ClassJsonParser parseQuiz:quizsDic];
                [self.quizs addObject:qz];
            }
            // 加载题目
             [self loadQuiz:quizNo];
            // 初始化记录用户选择的数组,和记录用户存储的数组
            for (int i = 0; i < self.quizs.count; i++) {
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

- (void)loadClassInfoFromLocal {
    self.classInfo = [[ClassInfo alloc] init];
    self.userInfo = [[UserInfo alloc] init];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *udObject = [ud objectForKey:@"classInfo"];
    self.classInfo = [NSKeyedUnarchiver unarchiveObjectWithData:udObject];
    udObject = [ud objectForKey:@"userInfo"];
    self.userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:udObject];
}

- (void)loadQuiz:(NSUInteger)interger {
    self.quiz = [self.quizs objectAtIndex:interger - 1];
}

#pragma mark 封装需要请求提交的数据
- (NSMutableDictionary *)packageTestResultWithState:(NSNumber *)state testNo:(NSNumber *)testNo anwserOption:(NSNumber *)anwserOption userOption:(NSNumber *)userOption itemResult:(NSNumber *)itemResult{
    NSMutableDictionary *aResultDic = [[NSMutableDictionary alloc] init];
    // 参数1 classid
    [aResultDic setObject:self.classInfo.classId forKey:@"classid"];
    // 参数2 itemid
    [aResultDic setObject:self.itemId forKey:@"itemid"];
    // 参数3 state
    [aResultDic setObject:state forKey:@"state"];
    // 参数4 testno
    [aResultDic setObject:testNo forKey:@"testno"];
    // 参数5 stuid
    [aResultDic setObject:self.userInfo.userId forKey:@"stuid"];
    // 参数6 testresult
    NSInteger isCorrect;
    if ([anwserOption isEqual:userOption]) {
        isCorrect = 1;
    } else {
        isCorrect = 0;
    }
    NSInteger testResult;
    //用户如果没有选的话userOption会是空
    if (userOption) {
        testResult = [userOption integerValue] * 10 + isCorrect;
    } else {
        testResult = isCorrect;
    }
    [aResultDic setObject:[NSNumber numberWithInteger:testResult] forKey:@"testresult"];
    // 参数7 itemresult
    [aResultDic setObject:itemResult forKey:@"itemresult"];
    // 返回
    return aResultDic;
}


#pragma mark - Table View Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 44;
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return [self.quiz getHeightOfQuizString:self.quiz.question];
        } else {
            float heigth = [self.quiz getHeightOfQuizString:self.quiz.options[indexPath.row - 1]];
            if (heigth < 50) {
                return 50;
            } else {
                return heigth;
            }
        }
    } else {
        // TODO 需要增加explainCell两个label的高度。
        return [self.quiz getHeightOfQuizString:self.quiz.answerExplain] + 40;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
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
    if (self.quizs.count) {
        if (isDisplayExplain) {
            return 3;
        } else {
            return 2;
        }
    } else return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.quizs.count) {
        switch (section) {
            case 0:
                return 1;
                break;
            case 1:
                return 5;
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
        TestStateCell *testStateCell = [tableView dequeueReusableCellWithIdentifier:testStateCellIdentifier];
        testStateCell.typeLabel.text = @"单项选择题";
        testStateCell.currentLabel.text = [NSString stringWithFormat:@"%lu", quizNo];
        testStateCell.totalLabel.text = [NSString stringWithFormat:@"%lu", self.quizs.count];
        return testStateCell;
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            NewQuestionCell *questionCell = [tableView dequeueReusableCellWithIdentifier:questionCellIdentifer];
            questionCell.textView.text = self.quiz.question;
            return questionCell;
        } else {
            NewQuestionCell *optionCell = [tableView dequeueReusableCellWithIdentifier:optionCellIdentifer];
            optionCell.textView.text = self.quiz.options[indexPath.row - 1];
            return optionCell;
        }
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

#pragma mark - Action
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

// 重要！封装用户选择到testResultArrat
- (void)packageAction {
    // 为了防止可能出现的意外情况，先清空存储的数组
    [self.testResultArray removeAllObjects];
    // 记录用户的正确选项的个数
    NSInteger numberOfCorrectQuiz = 0;
    // 声明3个需要不断使用的变量
    NSNumber *userOption = [[NSNumber alloc] init];
    Quiz *quizForAnswerOption = [[Quiz alloc] init];
    NSIndexPath *indexPathForUserSelection = [[NSIndexPath alloc] init];
    // 声明结束，开始计算用户选择正确的题目个数
    for (int i = 0; i < self.quizs.count; i++) {
        
        if (![self.userSelection[i] isEqual:[NSNumber numberWithBool:NO]]) {
            indexPathForUserSelection = self.userSelection[i];
            userOption = [NSNumber numberWithInteger:indexPathForUserSelection.row];
        } else {
            userOption = [NSNumber numberWithInteger:0];
        }
        quizForAnswerOption = self.quizs[i];
        if ([userOption isEqual:quizForAnswerOption.answerOption]) {
            numberOfCorrectQuiz++;
        }
    }
    // 根据选择正确的题目个数算出用户的分数
    NSInteger score = (numberOfCorrectQuiz * 100)/self.quizs.count;
    
    // 最后封装测试结果数组
    for (int i = 0; i < self.quizs.count; i++) {
        quizForAnswerOption = self.quizs[i];
        if (![self.userSelection[i] isEqual:[NSNumber numberWithBool:NO]]) {
            indexPathForUserSelection = self.userSelection[i];
            userOption = [NSNumber numberWithInteger:indexPathForUserSelection.row];
        } else {
            userOption = [NSNumber numberWithInteger:0];
        }
        NSMutableDictionary *testResultDic = [self packageTestResultWithState:[NSNumber numberWithInteger:1] testNo:[NSNumber numberWithInteger:i + 1] anwserOption:quizForAnswerOption.answerOption userOption:userOption itemResult:[NSNumber numberWithInteger:score]];
        [self.testResultArray addObject:testResultDic];
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
    BOOL isFinishedAllTest = YES;
    for (int i = 0; i < self.quizs.count; i++) {
        if ([self.userSelection[i] isEqual:[NSNumber numberWithBool:NO]]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention" message:@"You didn't finish all tests!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            isFinishedAllTest = NO;
            break;
        }
    }
    if (isFinishedAllTest) {
        [self packageAction];
        [ClassNetworkUtils submitTestResult:self.testResultArray andCallback:^(id obj) {
            NSLog(@"提交成功");
            [self performSegueWithIdentifier:@"ShowTestResult" sender:self];
        }];
    }
}

- (void)clickOnBackButton {
    self.backAlertView = [[UIAlertView alloc] initWithTitle:@"attention" message:@"Are you sure? Your selection would not be save unless you submit them!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sure", nil];
    [self.backAlertView show];
}

#pragma mark - Alert View Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView == self.backAlertView) {
        if (buttonIndex == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowTestResult"]) {
        id destinationVC = [segue destinationViewController];
        [destinationVC setValue:self.testResultArray forKey:@"testResultArray"];
    }
}


@end
