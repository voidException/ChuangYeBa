//
//  TestViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/25.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "TestViewController.h"
#import <MBProgressHUD.h>

#define THEME_BLUE colorWithRed:44.0/255 green:149.0/255 blue:255.0/255 alpha:1

static NSString *questionCellIdentifer = @"NewQuestionCell";
static NSString *optionCellIdentifer = @"NewOptionCell";
static NSString *explainCellIdentifer = @"ExplainCell";
static NSString *testStateCellIdentifier = @"TestStateCell";


@interface TestViewController () <MBProgressHUDDelegate>
@property (strong, nonatomic) NSNumber *numQuizNo;
@end

@implementation TestViewController

@synthesize quizNo;
@synthesize isShowExplain;
@synthesize itemId;

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化委托
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    [self initUI];
    
    // 初始化用户选择答案的数组
    if (!isShowExplain) {
        self.userSelection = [[NSMutableArray alloc] init];
    }
    // 初始化题目对象
    self.quiz = [[Quiz alloc] init];
    
    // 初始化存储测试结果的数组
    self.testResultArray = [[NSMutableArray alloc] init];
    
    // 从本地取得教室信息
    [self loadClassInfoFromLocal];
    
    // 初始化测试题组,初始化当前题目号,如果是显示答案的情况就不需要初始化这个值,因为上一级视图会把值传过来
    if (!isShowExplain) {
        self.quizNo = 1;
        
    } else {
        self.quizNo = [self.numQuizNo integerValue];
    }
    // 根据题号初始化按钮状态，上一题按钮不可用
    if (quizNo == 1) {
        [self.lastButton setEnabled:NO];
    } else if (quizNo == self.quizs.count) {
        [self.nextButton setEnabled:NO];
    } else {
        [self.lastButton setEnabled:YES];
        [self.nextButton setEnabled:YES];
    }
    
    if (isShowExplain) {
        self.submitButton.hidden = YES;
    }
    
    // 加载题目
    [self loadQuiz:quizNo];
    
    // 初始化记录用户选择的数组,如果在答题状态,将用户选择数组全部装入NO
    if (!isShowExplain) {
        for (int i = 0; i < self.quizs.count; i++) {
            [self.userSelection addObject:[NSNumber numberWithBool:NO]];
        }
    } else {
        self.anwserSelection = [[NSMutableArray alloc] init];
        
    }
}

- (void)viewWillAppear:(BOOL)animated {
    if (isShowExplain) {
        // 加载题目的时候就可以立刻看到当前题目的用户选项
        [self changeQuizAction];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Method
- (void)initUI {
    // 初始化tableView设置
    self.title = @"练习题";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册xib的题干和选项的cell
    [self.tableView registerNib:[UINib nibWithNibName:@"QuestionCell" bundle:nil] forCellReuseIdentifier:questionCellIdentifer];
    [self.tableView registerNib:[UINib nibWithNibName:@"OptionCell" bundle:nil] forCellReuseIdentifier:optionCellIdentifer];
    [self.tableView registerNib:[UINib nibWithNibName:@"TestStateCell" bundle:nil] forCellReuseIdentifier:testStateCellIdentifier];
    // 如果需要显示答案，注册显示答案的cell
    if ([isShowExplain isEqual:@YES]) {
        [self.tableView registerNib:[UINib nibWithNibName:@"ExplainCell" bundle:nil] forCellReuseIdentifier:explainCellIdentifer];
    }
    // 初始化导航条左键
    self.backButton = [[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:@selector(clickOnBackButton)];
    self.navigationItem.leftBarButtonItem = self.backButton;
    
    // 设置提交键状态
    [self.submitButton setBackgroundImage:[UIImage imageNamed:@"submitTestButtonDisableBG"] forState:UIControlStateDisabled];
    [self.submitButton setBackgroundImage:[UIImage imageNamed:@"submitTestButtonNormalBG"] forState:UIControlStateNormal];
    [self.submitButton setBackgroundImage:[UIImage imageNamed:@"submitTestButtonSelectedBG"] forState:UIControlStateSelected];
    [self.submitButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [self.submitButton setTitleColor:[UIColor THEME_BLUE] forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
#warning 一般 很奇怪这里为什么没法修改？
    [self.lastButton setImage:[UIImage imageNamed:@"lastButtonIconSelected"] forState:UIControlStateSelected];
    [self.nextButton setImage:[UIImage imageNamed:@"nextButtonIconSelected"] forState:UIControlStateSelected];
    [self.lastButton setTitleColor:[UIColor THEME_BLUE] forState:UIControlStateSelected];
    [self.nextButton setTitleColor:[UIColor THEME_BLUE] forState:UIControlStateSelected];
    
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
        return 49;
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return [self.quiz getHeightOfQuizString:self.quiz.question
                                        lineSpacing:8
                                         fontOfSize:17
                                        widthOffset:44.0];
        } else {
            float heigth = [self.quiz getHeightOfQuizString:self.quiz.options[indexPath.row - 1]
                                                lineSpacing:6
                                                 fontOfSize:15
                                                widthOffset:67.0];
            if (heigth < 52) {
                return 52;
            } else {
                return heigth;
            }
        }
    } else {
        // 加上除了解析的textView的另外两个控件的高度
        float extraHeigth = 53.0;
        return [self.quiz getHeightOfQuizString:self.quiz.answerExplain
                                    lineSpacing:10
                                     fontOfSize:18
                                    widthOffset:16.0] + extraHeigth;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OptionCell *cell = (OptionCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if (self.selectedCellIndexPath) {
        OptionCell *lastSelectedCell = (OptionCell *)[self.tableView cellForRowAtIndexPath:self.selectedCellIndexPath];
        if (![self.selectedCellIndexPath isEqual:indexPath]) {
            [lastSelectedCell setState:OptionCellStateUnselected];
        }
    }
    if (cell.state == OptionCellStateUnselected) {
        [cell setState:OptionCellStateSelected];
        self.selectedCellIndexPath = indexPath;
        [self.userSelection replaceObjectAtIndex:(quizNo - 1) withObject:self.selectedCellIndexPath];
    } else {
        [cell setState:OptionCellStateUnselected];
        self.selectedCellIndexPath = nil;
        [self.userSelection replaceObjectAtIndex:(quizNo - 1) withObject:[NSNumber numberWithBool:NO]];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.quizs.count) {
        if ([isShowExplain isEqual:@YES]) {
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
        // 答题状态条小区
        return [self tableView:tableView testStateCellForRowAtIndexPath:indexPath];
    } else if (indexPath.section == 1) {
        // 题干小区
        if (indexPath.row == 0) {
            return [self tableView:tableView questionCellForRowAtIndexPath:indexPath];
        } else {
            // 选项小区
            return [self tableView:tableView  optionCellForRowAtIndexPath:indexPath];
        }
    } else {
        // 解释小区
        return [self tableView:tableView explainCellForRowAtIndexPath:indexPath];
    }
}

- (TestStateCell *)tableView:(UITableView *)tableView testStateCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TestStateCell *testStateCell = [tableView dequeueReusableCellWithIdentifier:testStateCellIdentifier];
    testStateCell.typeLabel.text = @"单项选择练习";
    testStateCell.currentLabel.text = [NSString stringWithFormat:@"%lu", quizNo];
    testStateCell.totalLabel.text = [NSString stringWithFormat:@"%lu", self.quizs.count];
    return testStateCell;

}

- (QuestionCell *)tableView:(UITableView *)tableView questionCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QuestionCell *questionCell = [tableView dequeueReusableCellWithIdentifier:questionCellIdentifer];
    questionCell.quizNoLabel.text = [NSString stringWithFormat:@"%lu", quizNo];
    questionCell.textView.text = self.quiz.question;
    return questionCell;
}

- (ExplainCell *)tableView:(UITableView *)tableView explainCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExplainCell *explainCell = [tableView dequeueReusableCellWithIdentifier:explainCellIdentifer];
    
    // 显示解析
    explainCell.explainTextView.text = self.quiz.answerExplain;
    NSIndexPath *userSelected = self.userSelection[quizNo - 1];

    if (userSelected.row == [self.quiz.answerOption integerValue]) {
        [explainCell setState:ExplainCellStateCorrect];
    } else {
        [explainCell setState:ExplainCellStateError];
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
        // 显示用户选择的答案
        switch ([userSelected row]) {
            case 1:
                explainCell.optionLabel.text = @"A";
                break;
            case 2:
                explainCell.optionLabel.text = @"B";
                break;
            case 3:
                explainCell.optionLabel.text = @"C";
                break;
            case 4:
                explainCell.optionLabel.text = @"D";
                break;
            default:
                explainCell.optionLabel.text = nil;
                break;
        }
    }
        return explainCell;
}

- (OptionCell *)tableView:(UITableView *)tableView optionCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OptionCell *optionCell = [tableView dequeueReusableCellWithIdentifier:optionCellIdentifer];
    // 设置显示
    switch (indexPath.row) {
        case 1:
            optionCell.checkLabel.text = @"A";
            break;
        case 2:
            optionCell.checkLabel.text = @"B";
            break;
        case 3:
            optionCell.checkLabel.text = @"C";
            break;
        case 4:
            optionCell.checkLabel.text = @"D";
            break;
        default:
            optionCell.checkLabel.text = nil;
            break;
    }
    // 显示选项题干
    optionCell.textView.text = self.quiz.options[indexPath.row - 1];
    
    if (isShowExplain) {
        // 在显示解释的状态下，用户是不能选择小区的
        optionCell.userInteractionEnabled = NO;
        [optionCell setState:OptionCellStateUnable];
        NSIndexPath *userSelected = self.userSelection[quizNo - 1];
        NSIndexPath *answerOption = [NSIndexPath indexPathForRow:[self.quiz.answerOption integerValue] inSection:1];
        if ([userSelected isEqual:answerOption]) {
            if ([userSelected isEqual:indexPath]) {
                [optionCell setState:OptionCellStateCorrect];
            }
        } else {
            if ([userSelected isEqual:indexPath]) {
                [optionCell setState:OptionCellStateError];
            } else if ([answerOption isEqual:indexPath]) {
                [optionCell setState:OptionCellStateCorrect];
            }
        }
    } else {
        // 设置默认的状态为未选择状态
        [optionCell setState:OptionCellStateUnselected];
        // 读取该题用户是否已经做过选择，如果有则帮助用户选取已经选过的选项
        if (![self.userSelection[quizNo - 1] isEqual:[NSNumber numberWithBool:NO]]) {
            self.selectedCellIndexPath = self.userSelection[quizNo - 1];
            if ([self.selectedCellIndexPath isEqual:indexPath]) {
                [optionCell setState:OptionCellStateSelected];
            }
        }
    }
    return optionCell;

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

- (void)changeQuizAction {
    // 加载下一个题目
    [self loadQuiz:quizNo];
    [self.tableView reloadData];
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

- (IBAction)clickOnSubmitButton:(id)sender {
    if (!isShowExplain) {
        BOOL isFinishedAllTest = YES;
        for (int i = 0; i < self.quizs.count; i++) {
            if ([self.userSelection[i] isEqual:[NSNumber numberWithBool:NO]]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有做完全部的测试，请您仔细检查" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                [alert show];
                isFinishedAllTest = NO;
                break;
            }
        }
        if (isFinishedAllTest) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您已经完成全部测试，确定要提交吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 1;
            [alert show];
            
        }
    }
}

- (void)clickOnBackButton {
    if ([isShowExplain isEqual:@YES]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要离开测试吗？您刚刚的测试结果将不会被保存。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 0;
        [alert show];
    }
}

#pragma mark - Alert View Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 0) {
        if (buttonIndex == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
            HUD.tag = 0;
            HUD.labelText = @"正在提交";
            [HUD show:YES];
            [self packageAction];
            [ClassNetworkUtils submitTestResult:self.testResultArray andCallback:^(id obj) {
                [self.navigationController.view addSubview:HUD];
                HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark"]];
                HUD.mode = MBProgressHUDModeCustomView;
                HUD.animationType = MBProgressHUDAnimationZoomIn;
                HUD.delegate = self;
                HUD.labelText = @"提交成功";
                [HUD hide:YES afterDelay:1.0];
            }];
        }
    }
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    if (hud.tag == 0) {
        [self performSegueWithIdentifier:@"ShowTestResult" sender:self];
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowTestResult"]) {
        id destinationVC = [segue destinationViewController];
        [destinationVC setValue:self.testResultArray forKey:@"testResultArray"];
        [destinationVC setValue:self.quizs forKey:@"quizs"];
    }
}

@end
