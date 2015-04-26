//
//  TestDetailViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/24.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "TestDetailViewController.h"
#import "UserInfo.h"
#import "ClassInfo.h"

@interface TestDetailViewController ()

@property (nonatomic) BOOL isShowExplain;
@property (strong, nonatomic) UserInfo *userInfo;
@property (strong, nonatomic) ClassInfo *classInfo;

@end

@implementation TestDetailViewController
@synthesize isShowExplain;
#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    // 根据是否已经测试，加载对应的数据
    if ([self.testGroup.activity isEqual: @3]) {
        isShowExplain = NO;
        [self requestQuizsFromServer];
    } else {
        isShowExplain = YES;
        [self loadUserInfoAndClassInfoFromLocal];
        [self requestTestResultFromServer];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma Private Method
- (void)initUI {
    // 设置导航条题目
    self.title = @"试卷详情";
    // 设置题目开头
    self.titleLabel.text = self.testGroup.itemTitle;
    // 没有加载的时候两个键都不可用
    self.startTestButton.enabled = NO;
    self.showTestResultButton.enabled = NO;
}

- (void)loadUserInfoAndClassInfoFromLocal {
    self.userInfo = [[UserInfo alloc] init];
    self.classInfo = [[ClassInfo alloc] init];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *udObject = [ud objectForKey:@"userInfo"];
    self.userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:udObject];
    udObject = [ud objectForKey:@"classInfo"];
    self.classInfo = [NSKeyedUnarchiver unarchiveObjectWithData:udObject];
}


- (void)requestQuizsFromServer {
    // 打开Hud
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    [ClassNetworkUtils requestQuizsByitemId:self.testGroup.itemId andCallback:^(id obj){
        // 隐藏HUD
        [hud hide:YES];
        
        
        // 根据是否已经测试，加载相应的状态
        if ([self.testGroup.activity isEqual: @3]) {
            self.startTestButton.enabled = YES;
        } else {
            self.showTestResultButton.enabled = YES;
        }

        
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
            for (NSDictionary *quizsDic in quizsArr) {
                Quiz *qz = [ClassJsonParser parseQuiz:quizsDic];
                [self.quizs addObject:qz];
            }
            // 刷新题目数量
            self.numOfTestLabel.text = [NSString stringWithFormat:@"题数：%lu题",self.quizs.count];
            self.testCategoryLabel.text = @"题目类型：单项选择题";
            self.totalScoreLabel.text = @"总分：100分";
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:errorMessage delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

- (void)requestTestResultFromServer {
    // 打开HUD
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    [ClassNetworkUtils requestTestResultByStuId:self.userInfo.userId andClassId:self.classInfo.classId andItemId:self.testGroup.itemId andCallback:^(id obj) {
        // 停止HUD
        [hud hide:YES];
        // 请求完成后立刻再请求题组信息
        [self requestQuizsFromServer];
        
        NSDictionary *dic = obj;
        NSNumber *error = [dic objectForKey:@"error"];
        NSString *errorMessage = [dic objectForKey:@"errorMessage"];
        if ([error isEqual:@1]) {
            self.testResultArray = [dic objectForKey:@"testResult"];
            
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:errorMessage delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}


#pragma mark - Action
- (IBAction)clickOnStartTestButton:(id)sender {
    [self performSegueWithIdentifier:@"ShowTestGroup" sender:self];
}

- (IBAction)clickOnTestResultButton:(id)sender {
    [self performSegueWithIdentifier:@"ShowTestResult" sender:self];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id destinationVC = [segue destinationViewController];
    if ([segue.identifier isEqualToString:@"ShowTestGroup"]) {
        // 把下载的题组信息传递给TestTVC
        [destinationVC setValue:self.quizs forKey:@"quizs"];
        // 把测试题组号传递给TestTVC，为了封装提交的测试结果
        [destinationVC setValue:self.testGroup.itemId forKey:@"itemId"];
    } else if ([segue.identifier isEqualToString:@"ShowTestResult"]) {
        [destinationVC setValue:self.testResultArray forKey:@"testResultArray"];
        [destinationVC setValue:self.quizs forKey:@"quizs"];
    }
}


@end
