//
//  RegisterTableViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/13.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "RegisterTableViewController.h"
#import <MBProgressHUD.h>

@interface RegisterTableViewController () <MBProgressHUDDelegate, UITextFieldDelegate>

@property (strong, nonatomic) MBProgressHUD *HUD;

@end

@implementation RegisterTableViewController
@synthesize HUD;

#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化标题
    self.title = @"注册";
    
    // 初始化buttonView的高度
    self.buttonView.frame = CGRectMake(0, 0, self.view.frame.size.width, 80);
    self.tableView.tableFooterView = _buttonView;
    
    // 初始化取消按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(clickOnCancelButton)];
    self.navigationItem.leftBarButtonItem = leftButton;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    
    // 初始化tableView的点击动作
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)];
    [self.tableView addGestureRecognizer:tapGesture];
    
    // 初始化委托对象
    self.email.delegate = self;
    
    // TEST USE
    self.email.text = @"zachary@126.com";
    self.userName.text = @"小明";
    self.userNo.text = @"111111112";
    self.password.text = @"1111111";
    self.passwordConfirm.text = @"1111111";
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Private Method
// 计算键盘的高度
- (CGFloat)keyboardEndingFrameHeight:(NSDictionary *)userInfo
{
    CGRect keyboardEndUncorrectedFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGRect keyboardEndingFrame = [self.view convertRect:keyboardEndUncorrectedFrame fromView:nil];
    return keyboardEndingFrame.size.height;
}

// 键盘出现后调整视图
-(void)keyboardWillAppear:(NSNotification *)notification
{
    CGRect originFrame = [UIScreen mainScreen].bounds;
    CGRect currentFrame = originFrame;
    CGFloat change = [self keyboardEndingFrameHeight:[notification userInfo]];
    if (change) {
        currentFrame.size.height = currentFrame.size.height - change;
        self.tableView.frame = currentFrame;
    }
}

// 键盘消失后调整视图
-(void)keyboardWillDisappear:(NSNotification *)notification
{
    CGRect currentFrame = self.tableView.frame;
    CGFloat change = [self keyboardEndingFrameHeight:[notification userInfo]];
    currentFrame.size.height = currentFrame.size.height + change;
    self.tableView.frame = currentFrame;
}

// 在本地判断是否登陆信息有效
- (BOOL)isRegisterInfoLegal {
    if (![self isValidateEmail:self.email.text]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请输入有效的邮箱" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alertView show];
        self.email.textColor = [UIColor redColor];
        return NO;
    }
    if (self.email.text.length > 30) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"邮箱的长度不能超过30个字符" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    } else if (self.password.text.length < 4 || self.password.text.length > 10) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"密码的长度在4到10位之间" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    } else if ( ![self.password.text isEqualToString: self.passwordConfirm.text]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"两次输入的密码不一致，请重新输入。" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    }
    return YES;
}

// 判断是否是邮箱
- (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    return [emailTest evaluateWithObject:email];
}



#pragma mark - Action
- (void)clickOnCancelButton {
    [self.navigationController popViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickOnRegisterButton:(id)sender {
    if ([self isRegisterInfoLegal]) {
        UserInfo *userInfo = [[UserInfo alloc] init];
        userInfo.email = self.email.text;
        userInfo.password = self.password.text;
        userInfo.passwordConfirm = self.passwordConfirm.text;
        userInfo.userNo = self.userNo.text;
        userInfo.name = self.userName.text;
        
        HUD = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        [HUD show:YES];
        
        [LoginNetworkUtils registerUserInfo:userInfo andCallBack:^(id obj) {
            if (obj) {
                NSDictionary *dic = obj;
                NSNumber *error = [dic objectForKey:@"error"];
                if ([error isEqual:@9]) {
                    HUD.mode = MBProgressHUDModeCustomView;
                    HUD.animationType = MBProgressHUDAnimationZoomOut;
                    HUD.tag = 0;
                    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark"]];
                    HUD.labelText = @"注册成功";
                    //[HUD show:YES];
                    HUD.delegate = self;
                    [HUD hide:YES afterDelay:1.5];
                    // 保存用户登陆邮箱
                    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                    [ud setObject:self.email.text forKey:@"loginEmail"];
                    [ud synchronize];
                } else {
                    [HUD hide:YES];
                    NSString *errorMessage = [dic objectForKey:@"errorMessage"];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:errorMessage delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                    [alert show];
                }
            } else {
                HUD.mode = MBProgressHUDModeCustomView;
                HUD.animationType = MBProgressHUDAnimationZoomIn;
                HUD.tag = 1;
                HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"errormark"]];
                HUD.labelText = @"网络出错了>_<";
                [HUD show:YES];
                [HUD hide:YES afterDelay:1.0];
            }
        }];
    }
}

- (IBAction)didEndOnExit:(id)sender {
    if (self.email.isFirstResponder) {
        [self.userName becomeFirstResponder];
    } else if (self.userName.isFirstResponder) {
        [self.userNo becomeFirstResponder];
    } else if (self.userNo.isFirstResponder) {
        [self.password becomeFirstResponder];
    } else if (self.password.isFirstResponder) {
        [self.passwordConfirm becomeFirstResponder];
    }
}

- (void)backgroundTap:(id)sender {
    [self.email resignFirstResponder];
    [self.userName resignFirstResponder];
    [self.userNo resignFirstResponder];
    [self.password resignFirstResponder];
    [self.passwordConfirm resignFirstResponder];
}

#pragma mark - Textfield delegate 
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.textColor = [UIColor blackColor];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
#ifdef STUDENT_VERSION
        return 3;
#elif TEACHER_VERSION
        return 2;
#endif
    } else {
        return 2;
    }
}

#pragma mark - MBProgressHUD delegate
- (void)hudWasHidden:(MBProgressHUD *)hud {
    if (hud.tag == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}



@end
