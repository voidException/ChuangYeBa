//
//  UserEditedTableViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/5/8.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "UserEditedTableViewController.h"
#import "EditedInfoCell.h"
#import "UserInfo.h"
#import "BorderRadiusButton.h"
#import "EditedPhotoView.h"
#import "MeNetworkUtils.h"
#import <MBProgressHUD.h>

static NSString *editedInfoCellIdentifier = @"EditedInfoCell";

@interface UserEditedTableViewController () <UIAlertViewDelegate, UIActionSheetDelegate, MBProgressHUDDelegate>

@property (strong, nonatomic) NSArray *detailList;
@property (strong, nonatomic) NSArray *userInfoList;
@property (strong, nonatomic) UserInfo *userInfo;
@property (strong, nonatomic) NSMutableArray *textFields;

@end

@implementation UserEditedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self loadUserInfoFormLocal];
    
    self.textFields = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method
- (void)initUI {
    self.title = @"修改个人信息";
    
    NSBundle *bundle = [NSBundle mainBundle];
#ifdef STUDENT_VERSION
    NSString *plistPath = [bundle pathForResource:@"userDetailListStudent" ofType:@"plist"];
#elif TEACHER_VERSION
    NSString *plistPath = [bundle pathForResource:@"userDetailListTeacher" ofType:@"plist"];
#endif
    self.detailList = [[NSArray alloc] initWithContentsOfFile:plistPath];
    
    float screenWidth = self.view.frame.size.width;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 75)];
    float buttonMargin = 13.0;
    BorderRadiusButton *exitButton = [[BorderRadiusButton alloc] initWithFrame:CGRectMake(0, 0, screenWidth - 2 * buttonMargin, 45)];
    exitButton.center = footerView.center;
    [exitButton setTitle:@"保存修改" forState:UIControlStateNormal];
    [exitButton addTarget:self action:@selector(clickOnSaveButton:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:exitButton];
    self.tableView.tableFooterView = footerView;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EditedInfoCell" bundle:nil] forCellReuseIdentifier:editedInfoCellIdentifier];
    
    // 初始化左上角的按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(clickOnLeftButton)];
    self.navigationItem.leftBarButtonItem = leftButton;
}


- (void)loadUserInfoFormLocal {
    self.userInfo = [UserInfo loadUserInfoFromLocal];
#ifdef STUDENT_VERSION
    NSArray *arrSection0 = @[_userInfo.name, _userInfo.email];
    NSArray *arrSection1 = @[_userInfo.userNo, _userInfo.sex, _userInfo.school, _userInfo.department];
    self.userInfoList = @[arrSection0, arrSection1];
#elif TEACHER_VERSION
    NSArray *arrSection0 = @[_userInfo.name, _userInfo.email];
    NSArray *arrSection1 = @[_userInfo.universityName, _userInfo.tel];
    self.userInfoList = @[arrSection0, arrSection1];
#endif
}

// 准备弃用
- (void)saveUserInfoToLocal:(UserInfo *)ui {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *udObject = [NSKeyedArchiver archivedDataWithRootObject:ui];
    [ud setObject:udObject forKey:@"userInfo"];
    [ud synchronize];
}


- (void)submitUserInfoToServer {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i<self.textFields.count; i++) {
        UITextField *tf=self.textFields[i];
        [arr addObject:tf.text];
    }
    
#ifdef STUDENT_VERSION
    UserInfo *copyUserInfo = [[UserInfo alloc] init];;
    copyUserInfo = [self.userInfo copy];
    copyUserInfo.name = arr[0];
    copyUserInfo.email = arr[1];
    copyUserInfo.userNo = arr[2];
    copyUserInfo.sex = arr[3];
    copyUserInfo.school = arr[4];
    copyUserInfo.department = arr[5];
#elif TEACHER_VERSION
    UserInfo *copyUserInfo = [[UserInfo alloc] init];;
    copyUserInfo = [self.userInfo copy];
    copyUserInfo.name = arr[0];
    copyUserInfo.email = arr[1];
    copyUserInfo.universityName = arr[2];
    copyUserInfo.tel = arr[3];
#endif
    
    // 显示HUD
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = @"正在提交";
    HUD.minSize = CGSizeMake(135.f, 135.f);
    [HUD show:YES];
    HUD.animationType = MBProgressHUDAnimationZoomIn;
    
    [MeNetworkUtils submitModifiedUserInfo:copyUserInfo andCallback:^(id obj) {
        NSDictionary *dic = obj;
        NSNumber *error = [dic objectForKey:@"error"];
        //NSString *errorMessage = [dic objectForKey:@"errorMessage"];
        if ([error isEqualToNumber:@1]) {
            // 先保存用户信息到local
            [UserInfo saveUserInfoToLocal:copyUserInfo];
            // 再发送更新用户信息的通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateClassInfo" object:self];
            
            
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark"]];
            // Set custom view mode
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.animationType = MBProgressHUDAnimationZoomIn;
            HUD.delegate = self;
            HUD.labelText = @"修改成功";
            //[HUD show:YES];
            [HUD hide:YES afterDelay:1.0];

        } else {
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"errormark"]];
            // Set custom view mode
            HUD.mode = MBProgressHUDModeCustomView;
            //HUD.delegate = self;
            HUD.labelText = @"网络错误";
            [HUD hide:YES afterDelay:1.0];
        }
        NSLog(@"提交成功");
    }];
}

#pragma mark - Action
- (void)clickOnBackground {
    for (int i = 0; i < self.textFields.count; i++) {
        UITextField *tf = self.textFields[i];
        [tf resignFirstResponder];
    }
}

- (void)clickOnSaveButton:(id)sender {
    [self submitUserInfoToServer];
    
}

- (void)clickOnLeftButton {
    [self clickOnBackground];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否放弃当前的修改信息" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    alert.tag = 0;
    [alert show];
}

#pragma mark - AlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 0) {
        if (buttonIndex == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - ActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 0) {
        UITextField *tf = _textFields[3];
        if (buttonIndex == 1) {
            tf.text = @"男";
        } else if (buttonIndex == 0) {
            tf.text = @"女";
        }
    }
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

#ifdef STUDENT_VERSION
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"s = %@", indexPath);
    // 在这里只能直接写死了性别的小区是哪一个。之后可能需要加一个判断，从设置的list中识别出来。
    if ([indexPath isEqual:[NSIndexPath indexPathForRow:1 inSection:1]]) {
        [self clickOnBackground];
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"女", @"男", nil];
        actionSheet.tag = 0;
        //[actionSheet showFromTabBar:self.tabBarController.tabBar];
        [actionSheet showInView:self.view];
    } else {
        [self clickOnBackground];
    }
}
#elif TEACHER_VERSION
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self clickOnBackground];
}
#endif

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_detailList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = _detailList[section];
    return [arr count];
}

#ifdef STUDENT_VERSION
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EditedInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:editedInfoCellIdentifier forIndexPath:indexPath];
    NSArray *arr = _detailList[indexPath.section];
    NSDictionary *dic = arr[indexPath.row];
    NSArray *arrUser = _userInfoList[indexPath.section];
    NSString *title = [dic objectForKey:@"title"];
    cell.label.text = title;
    
    if ([title isEqualToString:@"性别"]||[title isEqualToString:@"邮箱"]) {
        [cell.textField setEnabled:NO];
    }
    
    
    // 在这里用stringWithFormat是为了防止NSNumber不方便显示的问题
    NSString *str = [NSString stringWithFormat:@"%@", arrUser[indexPath.row]];

    if (str.length) {
        cell.textField.text = str;
    } else {
        cell.textField.placeholder = [dic objectForKey:@"placeholder"];
    }
    
    NSInteger sum = 0;
    for (int i = 0; i < _detailList.count; i++) {
        NSInteger sumOfSection = [_detailList[i] count];
        sum += sumOfSection;
    }
    if (_detailList.count < sum) {
        UITextField *textField = cell.textField;
        [self.textFields addObject:textField];
    }
    return cell;
}
#elif TEACHER_VERSION
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EditedInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:editedInfoCellIdentifier forIndexPath:indexPath];
    NSArray *arr = _detailList[indexPath.section];
    NSDictionary *dic = arr[indexPath.row];
    NSArray *arrUser = _userInfoList[indexPath.section];
    NSString *title = [dic objectForKey:@"title"];
    cell.label.text = title;
    if ([title isEqualToString:@"邮箱"]) {
        [cell.textField setEnabled:NO];
    }
    // 在这里用stringWithFormat是为了防止NSNumber不方便显示的问题
    NSString *str = [NSString stringWithFormat:@"%@", arrUser[indexPath.row]];
    if (str.length) {
        cell.textField.text = str;
    } else {
        cell.textField.placeholder = [dic objectForKey:@"placeholder"];
    }
    
    NSInteger sum = 0;
    for (int i = 0; i < _detailList.count; i++) {
        NSInteger sumOfSection = [_detailList[i] count];
        sum += sumOfSection;
    }
    if (_detailList.count < sum) {
        UITextField *textField = cell.textField;
        [self.textFields addObject:textField];
    }
    return cell;

}


#endif

- (void)hudWasHidden:(MBProgressHUD *)hud {
    if ([hud.labelText isEqualToString:@"修改成功"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
