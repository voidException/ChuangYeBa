//
//  TestGroupsTableViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/5/19.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "TestGroupsTableViewController.h"
#import "TestGroup.h"
#import "UserInfo.h"
#import "ClassInfo.h"
#import "ClassNetworkUtils.h"
#import "ClassJsonParser.h"
#import "Quiz.h"
#import <MBProgressHUD.h>

@interface TestGroupsTableViewController ()

@property (strong, nonatomic) NSMutableDictionary *testGroups;
@property (strong, nonatomic) UserInfo *userInfo;
@property (strong, nonatomic) NSMutableDictionary *addDic;
@property (strong, nonatomic) NSMutableDictionary *addIndexPath;
@property (strong, nonatomic) NSArray *addedTestGroupId;
@property (strong, nonatomic) TestGroup *selectedTestGroup;
@property (strong, nonatomic) ClassInfo *classInfo;
@property (strong, nonatomic) NSMutableArray *quizs;

@end

@implementation TestGroupsTableViewController

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化数据
    self.userInfo = [UserInfo loadUserInfoFromLocal];
    self.testGroups = [[NSMutableDictionary alloc] init];
    self.addIndexPath = [[NSMutableDictionary alloc] init];
    // 初始化UI
    [self initUI];
    
    [self requestAllTestGroupsFromServer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method
- (void)initUI {
    
    self.title = @"练习题库";
    // 初始化Tableview属性
    self.clearsSelectionOnViewWillAppear = NO;
    
    // 初始化导航条右上角编辑按键
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    UIButton *toolbarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 86, 30)];
    //toolbarButton.center = self.navigationController.toolbar.center;
    toolbarButton.center = CGPointMake(self.view.frame.size.width/2, 44/2);
    [toolbarButton addTarget:self action:@selector(clickOnAddButton:) forControlEvents:UIControlEventTouchUpInside];
    [toolbarButton setBackgroundImage:[UIImage imageNamed:@"loginButtonBG"] forState:UIControlStateNormal];
    [toolbarButton setTitle:@"添加" forState:UIControlStateNormal];
    [self.navigationController.toolbar addSubview:toolbarButton];
    self.navigationController.toolbar.autoresizesSubviews = YES;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"lastButtonIcon"] landscapeImagePhone:nil style:UIBarButtonItemStyleDone target:self action:@selector(clickOnBackButton:)];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)requestAllTestGroupsFromServer {
    [ClassNetworkUtils requestAllTestGroupByTeacherId:_userInfo.userId andCallback:^(id obj) {
        NSDictionary *dic = obj;
        NSNumber *error = [dic objectForKey:@"error"];
        if ([error isEqual:@1]) {
            NSArray *testGroupArr = [dic objectForKey:@"itemTest"];
            for (NSDictionary *testGroup in testGroupArr) {
                TestGroup *tg = [ClassJsonParser parseTestGropu:testGroup];
                [_testGroups setObject:tg forKey:tg.itemId];
            }
            // 去掉已经添加在班级中的题组
            [_testGroups removeObjectsForKeys:_addedTestGroupId];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Action
- (void)clickOnBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickOnAddButton:(id)sender {
    NSArray *arrValues = [_addDic allValues];
    __block NSInteger sum = 0;
    for (int i = 0; i < arrValues.count; i++) {
        TestGroup *tg = arrValues[i];
        [ClassNetworkUtils submitAddTestGroupWithClassId:_classInfo.classId itemId:tg.itemId andCallback:^(id obj) {
            NSLog(@"itemId = %@成功加入题组", tg.itemId);
            sum ++;
            if (sum == arrValues.count) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UserAddedTestGroups" object:nil];
                [_testGroups removeObjectsForKeys:[_addDic allKeys]];
                NSArray *indexPathArr = [_addIndexPath allValues];
                [self.tableView deleteRowsAtIndexPaths:indexPathArr withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView setEditing:NO animated:YES];
                // 退出编辑状态
                self.editing = NO;
                [_addDic removeAllObjects];
                [_addIndexPath removeAllObjects];
            }
        }];
    }
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    if (editing) {
        // 进入编辑状态
        self.addDic = [[NSMutableDictionary alloc] init];
        
        [self.navigationController setToolbarHidden:NO animated:animated];
        
    } else {
        // 退出编辑状态
        self.addDic = nil;
        [self.navigationController setToolbarHidden:YES animated:animated];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.editing) {
        NSArray *arr = [self.testGroups allValues];
        TestGroup *tg = arr[indexPath.row];
        [self.addDic setObject:tg forKey:tg.itemId];
        [self.addIndexPath setObject:indexPath forKey:tg.itemId];
    } else {
        // 打开Hud
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSArray *arr = [self.testGroups allValues];
        TestGroup *tg = arr[indexPath.row];
        self.selectedTestGroup = tg;
        [ClassNetworkUtils requestQuizsByitemId:tg.itemId andCallback:^(id obj){
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

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.editing) {
        NSArray *arr = [self.testGroups allValues];
        TestGroup *tg = arr[indexPath.row];
        [self.addDic removeObjectForKey:tg.itemId];
        [self.addIndexPath removeObjectForKey:tg.itemId];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_testGroups allValues] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSArray *arr = [_testGroups allValues];
    TestGroup *tg = arr[indexPath.row];
    cell.textLabel.text = tg.itemTitle;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id destinationVC = [segue destinationViewController];
    if ([segue.identifier isEqualToString:@"ShowTestGroup"]) {
        // 把下载的题组信息传递给TestTVC
        [destinationVC setValue:self.quizs forKey:@"quizs"];
        // 把测试题组号传递给TestTVC，为了封装提交的测试结果
        [destinationVC setValue:self.selectedTestGroup.itemId forKey:@"itemId"];
        [destinationVC setValue:[NSNumber numberWithBool:YES] forKey:@"isShowExplain"];
        [destinationVC setValue:[NSNumber numberWithInteger:1] forKey:@"numQuizNo"];
    }
}


@end
