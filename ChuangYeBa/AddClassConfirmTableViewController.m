//
//  AddClassConfirmTableViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/21.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "AddClassConfirmTableViewController.h"

static NSString *classInfoCellIdentifier = @"ClassInfoCell";

@interface AddClassConfirmTableViewController ()

@end

@implementation AddClassConfirmTableViewController
@synthesize classInfo;

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"加入班级";
    self.buttonView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 150);
    // 注册xib，班级信息的小区
    [self.tableView registerNib:[UINib nibWithNibName:@"ClassInfoCell" bundle:nil] forCellReuseIdentifier:classInfoCellIdentifier];
    self.userInfo = [[UserInfo alloc] initWithUserDefault];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method

- (void)saveClassInfoToLocal {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    self.userInfo.hasAddedClass = @"1";
    [self.userInfo saveUserInfoToLocal];
    NSData *udObject = [NSKeyedArchiver archivedDataWithRootObject:self.classInfo];
    [ud setObject:udObject forKey:@"classInfo"];
    [ud synchronize];
}

#pragma mark - Action
- (IBAction)clickOnAddClassButton:(id)sender {
    
    [ClassNetworkUtils requestAddClassByStudentId:self.userInfo.userId andClassNo:classInfo.classNo andCallback:^(id obj) {
        if (obj) {
            NSDictionary *dic = obj;
            NSNumber *error = [dic objectForKey:@"error"];
            NSString *errorMessage = [dic objectForKey:@"errorMessage"];
            
            if ([error isEqual:@3]||[error isEqual:@2]) {
                // 保存教室的信息到本地同时修改isUserAddedClass的值
                [self saveClassInfoToLocal];
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:errorMessage delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }];
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 176;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ClassInfoCell *classInfoCell = [tableView dequeueReusableCellWithIdentifier:classInfoCellIdentifier];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSString *classNoString = [formatter stringFromNumber:classInfo.classNo];
    classInfoCell.classNoLabel.text = classNoString;
    classInfoCell.classNameLabel.text = classInfo.classroomName;
    classInfoCell.teacherNameLabel.text = classInfo.teacher.name;
    classInfoCell.universityNameLabel.text = classInfo.universityName;
    return classInfoCell;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}



@end
