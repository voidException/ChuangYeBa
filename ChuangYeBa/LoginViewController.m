//
//  LoginViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/2.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize HUD;

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 隐藏导航条
    [self.navigationController setNavigationBarHidden:YES];
    
    // 添加临时登陆信息
    self.email.text = @"zachary0513@126.com";
    self.password.text = @"1111111";
    
    // 初始化TextField的委托对象
    self.email.delegate = self;
    self.password.delegate = self;
    
    [self modifiedFont];
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadLoginEmailFromLocal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method
- (void)modifiedFont {
    if (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(320, 568))) {
        self.forgetPasswordButton.titleLabel.font = [UIFont systemFontOfSize:14];
        self.registerButton.titleLabel.font = [UIFont systemFontOfSize:14];
    } else if (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(414, 736))){
        self.forgetPasswordButton.titleLabel.font = [UIFont systemFontOfSize:20];
        self.registerButton.titleLabel.font = [UIFont systemFontOfSize:20];
    }
}

- (void)requestLogin {
    if (!self.userInfo) {
        self.userInfo = [[UserInfo alloc] init];
    }
    [LoginNetworkUtils loginUserName:self.email.text loginUserPassword:self.password.text andCallback:^(id obj) {
        
        if (obj) {
            // 隐藏HUD
            [HUD hide:YES];
            NSDictionary *dic = obj;
            NSNumber *error = [dic objectForKey:@"error"];
            NSString *errorMessage = [dic objectForKey:@"errorMessage"];
            if ([error isEqualToNumber:[NSNumber numberWithInteger:1]]) {
                self.userInfo = [LoginJsonParser parseUserInfoInLogin:[dic objectForKey:@"student"] isTeacher:NO];
                [self saveUserInfoToLocal:self.userInfo];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateUserInfo" object:nil];
                [self dismissViewControllerAnimated:YES completion:nil];
                
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:errorMessage delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                [alert show];
            }
        } else {
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.animationType = MBProgressHUDAnimationZoomIn;
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"errormark"]];
            HUD.labelText = @"网络出错了>_<";
            [HUD show:YES];
            [HUD hide:YES afterDelay:1.0];
        }
    }];
}

#pragma mark  判断用户信息和邮箱有效性
// 在本地判断是否登陆信息有效
- (BOOL)isLoginInfoLegal {
    if (self.email.text.length > 30 || self.password.text.length < 4 || self.password.text.length > 10) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"警告" message:@"登陆信息出错了" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
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


- (void)loadLoginEmailFromLocal {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    self.email.text = [ud objectForKey:@"loginEmail"];
}

// 保存用户信息至NSUserDefault，同时记录登陆状态
- (void)saveUserInfoToLocal:(UserInfo *)ui{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *udObject = [NSKeyedArchiver archivedDataWithRootObject:ui];
    [ud setObject:udObject forKey:@"userInfo"];
    NSNumber *isUserDidLogin = [[NSNumber alloc]initWithBool:YES];
    [ud setObject:isUserDidLogin forKey:@"isUserDidLogin"];
    [ud setObject:ui.email forKey:@"loginEmail"];
    [ud synchronize];
}

#pragma mark - Action
- (IBAction)clickOnLoginButton:(id)sender {
    if ([self isLoginInfoLegal]) {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.removeFromSuperViewOnHide = YES;
        [self requestLogin];
    }
    else {
        NSLog(@"返回错误警告");
    }
}

- (IBAction)clickOnRegisterButton:(id)sender {
    [self performSegueWithIdentifier:@"ShowRegister" sender:self];
}

- (IBAction)clickOnForgetPasswordButton:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"找回密码", nil];
    [actionSheet showInView:self.view];
}

- (IBAction)didEndOnExit:(id)sender {
    [self.password becomeFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [self.email resignFirstResponder];
    [self.password resignFirstResponder];
}

#pragma mark - Text Feild Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    static NSInteger illegalLength = 30;
    if (textField == self.email)
    {
        if (textField.text.length > illegalLength) {
            textField.textColor = [UIColor redColor];
            self.loginButton.enabled = NO;
            //textField.
        }
        else {
            textField.textColor = [UIColor blackColor];
            self.loginButton.enabled = YES;
        }
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.email) {
        if (textField.text.length > 30 || ![self isValidateEmail:textField.text]) {
            UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"邮箱的长度请小于30个字符,或请输入有效的邮箱" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alerView show];
            //textField.textColor = [UIColor redColor];
        }
    }
}

#pragma mark - Action Sheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self performSegueWithIdentifier:@"ShowFindPassword" sender:self];
    }
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
