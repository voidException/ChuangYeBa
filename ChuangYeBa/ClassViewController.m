//
//  ClassViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/2.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "ClassViewController.h"


@interface ClassViewController ()

@end

@implementation ClassViewController

@synthesize isUserAddedClass;
@synthesize isTested;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"教室";
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // 用于初始化测试变量
    isTested = YES;
    
    [self setNavigationBarAttributes];
}

- (void)setNavigationBarAttributes {
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:46.0/255 green:149.0/255 blue:251.0/255 alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated {
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    // 读取用户默认设置是否已经加入班级
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *number = [ud objectForKey:@"isUserAddedClass"];
    if (number == nil) {
        isUserAddedClass = NO;
    } else {
        isUserAddedClass = [number isEqualToNumber:[NSNumber numberWithBool:YES]];
    }
    
    if (!isUserAddedClass) {
        
        // 使得tableView可以响应点击的动作，待改进
        self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOnTableViewBlank)];
        [self.tableView addGestureRecognizer:self.singleTap];
        
        // 临时字符，需要改进
        self.addClassLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 300, 200, 50)];
        self.addClassLabel.text = @"点击加入班级";
        [self.tableView addSubview:self.addClassLabel];
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 请求加入班级
- (void)requestAddClass:(NSString *)classNo{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *udObject = [ud objectForKey:@"userInfo"];
    UserInfo *userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:udObject];
    
    [ClassNetworkUtils requestTestGroupByStudentId:userInfo.userNo andClassNo:classNo andCallback:^(id obj) {
        NSLog(@"callback");
    }];
}

- (void)clickOnTableViewBlank {
    [self addClass];
}

- (void)addClass {
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"输入添加班级" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 150;
            break;
        case 1:
            return 100;
            break;
        default:
            return 150;
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            if (isUserAddedClass) {
                // 返回实际测试的个数
                return 1;
            } else {
                return 0;
            }
            break;
        default:
            return 0;
            break;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *testInfoCellIndentifier = @"TestInfoCell";
    static NSString *classInfoCellIndentifier = @"ClassInfoCell";
    NSLog(@"section = %lu, row = %lu", indexPath.section, indexPath.row);
    if (indexPath.section == 0) {
        ClassInfoCell *classInfoCell = [tableView dequeueReusableCellWithIdentifier:classInfoCellIndentifier];
        classInfoCell.delegate = self;
        
        classInfoCell.photoImage.image = [UIImage imageNamed:@"USA.png"];
        classInfoCell.name.text = @"小明";
        classInfoCell.schoolName.text = @"北京大学";
                if (isUserAddedClass) {
            classInfoCell.numberOfPeopleInClass.hidden = NO;
            [classInfoCell.button setTitle:@"班级设置" forState:UIControlStateNormal];
        } else {
            classInfoCell.numberOfPeopleInClass.hidden = YES;
            [classInfoCell.button setTitle:@"加入班级" forState:UIControlStateNormal];
        }
        
        return classInfoCell;
    } else {
        TestInfoCell *testInfoCell = [tableView dequeueReusableCellWithIdentifier:testInfoCellIndentifier];
        testInfoCell.delegate = self;
        testInfoCell.testImage.image = [UIImage imageNamed:@"USA.png"];
        testInfoCell.title.text = @"测试1";
        testInfoCell.introduction.text = @"测试1的简介";
        if (isTested) {
            testInfoCell.testAndResultButton.titleLabel.text = @"查看结果";
        } else {
            testInfoCell.testAndResultButton.titleLabel.text = @"测试";
        }
        return testInfoCell;
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    // 用户输入的班级号
    NSString *inputClassNumber = [alertView textFieldAtIndex:0].text;
    if (buttonIndex == 1 && ![inputClassNumber isEqualToString:@""]) {
        isUserAddedClass = YES;
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSNumber *number = [[NSNumber alloc]initWithBool:YES];
        [ud setObject:number forKey:@"isUserAddedClass"];
        [ud synchronize];
        
        [self requestAddClass:inputClassNumber];
        
        // 移除点击动作的手势
        [self.tableView removeGestureRecognizer:self.singleTap];
        // 移除添加课程的标签（Label）
        [self.addClassLabel removeFromSuperview];
        // 重新载入TableView
        [self.tableView reloadData];
    }
}


#pragma mark - ClassInfoCellDelegate
- (void)userClickOnaddAndSettingButton:(ClassInfoCell *)classInfoCell {
    if (isUserAddedClass) {
        [self performSegueWithIdentifier:@"ShowClassSetting" sender:self];
        
    } else {
        [self addClass];
    }
}

#pragma mark - TestInfoCellDelegate
- (void)clickOnTestAndResultButton:(TestInfoCell *)testInfoCell {
    self.hidesBottomBarWhenPushed = YES;
    //[self performSegueWithIdentifier:@"ShowTestDetail1" sender:self];
    [self performSegueWithIdentifier:@"ShowTestDetail" sender:self];
    self.hidesBottomBarWhenPushed = NO;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual: @"ShowTestDetail"]) {
        id destinationVC = [segue destinationViewController];
        [destinationVC setValue:[NSNumber numberWithBool:isTested] forKey:@"isDisplayExplain"];
    }
}


@end
