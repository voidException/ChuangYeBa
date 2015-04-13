//
//  TestViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/8.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//


#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

@synthesize quizNo;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.nextButton.title = @"下一题";
    self.lastButton.title = @"上一题";
    self.submmitButton.title = @"提交";
    
    
    self.navigationController.delegate = self;
    //[self.submmitButton setEnabled:NO];
    
    
    
    [self.tableView setEditing:YES animated:NO];
    
    // 初始化用户选择答案的数组
    self.userSelection = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithBool:NO], nil];
    
    

    
    // 初始化测试题组，初始化当前题目号
    self.quizNo = 1;
    [self initQuizs];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    //self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    NSLog(@"viewDidAppear");
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    //self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 初始化测试题组
- (void)initQuizs {
    self.quiz = [[Quiz alloc] init];
    // 模拟了Quizs模型从网络获取并解析的过程。实际上self.quiz应该由经过网络请求后的Quiz对象的属性获得
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"quizs" ofType:@"plist"];
    self.quizs = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    
    for (int i = 1; i < self.quizs.count; i++) {
        [self.userSelection addObject:[NSNumber numberWithBool:NO]];
    }
    
    [self loadQuiz:self.quizNo];
    
}

- (void)loadQuiz:(NSUInteger)interger {
    NSDictionary *dic = [self.quizs objectAtIndex:interger - 1];
    self.quiz.question = [dic objectForKey:@"question"];
    NSLog(@"test %@", self.quiz.question);
    NSArray *optionArray = [[NSArray alloc]initWithObjects:[dic objectForKey:@"optionA"] ,[dic objectForKey:@"optionB"] ,[dic objectForKey:@"optionC"] ,[dic objectForKey:@"optionD"] , nil];
    self.quiz.options = optionArray;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [self.quiz getHeightOfQuizString:self.quiz.question] + 10;
    } else {
        // TODO
        return [self.quiz getHeightOfQuizString:self.quiz.options[indexPath.row]];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return UITableViewCellEditingStyleNone;
    }
    else {
        return UITableViewCellEditingStyleInsert|UITableViewCellEditingStyleDelete;
    }
}


/*
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"will select");
    NSLog(@"select section = %ld, row = %ld", (long)indexPath.section, (long)indexPath.row);
    // 在这里可以实现单选的功能
    // 和下一题和上一题两个键有矛盾。有BUG！！
 
    if (self.selectedCellIndexPath) {
        
        OptionCell *optionCell = (OptionCell *)[self.tableView cellForRowAtIndexPath:self.selectedCellIndexPath];
        optionCell.selected = NO;
        
        // [self.tableView deselectRowAtIndexPath:self.selectedCellIndexPath animated:NO];
        self.selectedCellIndexPath = indexPath;
    } else {
        self.selectedCellIndexPath = indexPath;
    }
 
    return indexPath;
}
*/
// cell被反选时的委托


- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    //OptionCell *optionCell = (OptionCell *)[self.tableView cellForRowAtIndexPath:self.selectedCellIndexPath];
    OptionCell *nowOptionCell = (OptionCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if (nowOptionCell.selected) {
        if (self.selectedCellIndexPath) {
            self.selectedCellIndexPath = nil;
            nowOptionCell.selected = NO;
            [self.userSelection replaceObjectAtIndex:(quizNo - 1) withObject:[NSNumber numberWithBool:NO]];
        }
    }
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"highlight");
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedCellIndexPath) {
        
        OptionCell *optionCell = (OptionCell *)[self.tableView cellForRowAtIndexPath:self.selectedCellIndexPath];
        optionCell.selected = NO;
        
        // [self.tableView deselectRowAtIndexPath:self.selectedCellIndexPath animated:NO];
        self.selectedCellIndexPath = indexPath;
    } else {
        self.selectedCellIndexPath = indexPath;
    }

    if (self.selectedCellIndexPath != nil) {
        [self.userSelection replaceObjectAtIndex:(quizNo - 1) withObject:self.selectedCellIndexPath];
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // 2个section，0为question，1为option
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        // 暂定4个选项
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *questionCellIndentifier = @"QuestionCell";
    static NSString *optionCellIndentifier = @"OptionCell";
    if (indexPath.section == 0) {
        // 重用题干小区
        QuestionCell *questionCell = [tableView dequeueReusableCellWithIdentifier:questionCellIndentifier];
        if (questionCell == nil) {
            questionCell = [[QuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:questionCellIndentifier];
        }
        questionCell.heightOfTextView = [self.quiz getHeightOfQuizString:self.quiz.question];
        questionCell.textView.text = self.quiz.question;
        
        return questionCell;
    } else {
        // 重用选项小区
        OptionCell *optionCell = [tableView dequeueReusableCellWithIdentifier:optionCellIndentifier];
        if (optionCell == nil) {
            optionCell =[[OptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:optionCellIndentifier];
        }
        optionCell.heightOfTextView = [self.quiz getHeightOfQuizString:self.quiz.options[indexPath.row]];
        optionCell.textView.text = self.quiz.options[indexPath.row];
        return optionCell;
    }
}

- (IBAction)clickOnNextButton:(id)sender {
    if (quizNo < self.quizs.count) {
        // 如果用户有做出选择，则保存用户已经选的选项
        /*
        if (self.selectedCellIndexPath != nil) {
            [self.userSelection replaceObjectAtIndex:(quizNo - 1) withObject:self.selectedCellIndexPath];
        } else {
            [self.userSelection replaceObjectAtIndex:(quizNo - 1) withObject:[NSNumber numberWithBool:NO]];
        }
         */
        // 题号增加
        quizNo ++;
        // 加载下一个题目
        [self loadQuiz:quizNo];
        [self.tableView reloadData];
        //self.selectedCellIndexPath = nil;
        
        // 读取该题用户是否已经做过选择，如果有则帮助用户选取已经选过的选项
        if (![self.userSelection[quizNo - 1] isEqual:[NSNumber numberWithBool:NO]]) {
            self.selectedCellIndexPath = self.userSelection[quizNo - 1];
            OptionCell *optionCell = (OptionCell *)[self.tableView cellForRowAtIndexPath:self.selectedCellIndexPath];
            optionCell.selected = YES;
        }
    }
}

- (IBAction)clickOnLastButton:(id)sender {
    if (quizNo > 1) {
        // 如果用户有做出选择，则保存用户已经选的选项
        /*
        if (self.selectedCellIndexPath != nil) {
            [self.userSelection replaceObjectAtIndex:(quizNo - 1) withObject:self.selectedCellIndexPath];
        } else {
            [self.userSelection replaceObjectAtIndex:(quizNo - 1) withObject:[NSNumber numberWithBool:NO]];
        }
         */
        // 题号减小
        quizNo --;
                // 加载上一个题目
        [self loadQuiz:quizNo];
        [self.tableView reloadData];
        //self.selectedCellIndexPath = nil;

        
        // 读取该题用户是否已经做过选择，如果有则帮助用户选取已经选过的选项
        if (![self.userSelection[quizNo - 1] isEqual:[NSNumber numberWithBool:NO]]) {
            self.selectedCellIndexPath = self.userSelection[quizNo - 1];
            OptionCell *optionCell = (OptionCell *)[self.tableView cellForRowAtIndexPath:self.selectedCellIndexPath];
            optionCell.selected = YES;
        }
    }
}


- (IBAction)clickOnSubmmitButton:(id)sender {
    for (int i = 0; i < self.quizs.count; i++) {
        if ([self.userSelection[i] isEqual:[NSNumber numberWithBool:NO]]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention" message:@"You didn't finish all tests!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            break;
            // 不提交数据
        }
    }
}

#pragma mark - NavigationControllerDelegate
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSLog(@"navigation Controller delegate");
    //self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
