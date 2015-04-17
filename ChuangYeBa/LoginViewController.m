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

- (void)modifiedFont {
    if (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(320, 568))) {
        self.forgetPasswordButton.titleLabel.font = [UIFont systemFontOfSize:14];
        self.registerButton.titleLabel.font = [UIFont systemFontOfSize:14];
    } else if (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(414, 736))){
        self.forgetPasswordButton.titleLabel.font = [UIFont systemFontOfSize:20];
        self.registerButton.titleLabel.font = [UIFont systemFontOfSize:20];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)clickOnLoginButton:(id)sender {
    if ([self isLoginInfoLegal]) {
        
        if (!self.userInfo) {
            self.userInfo = [[UserInfo alloc]init];
        }
        
        //[self addActivityBackgroundView];
        
      
        [LoginNetworkUtils loginUserName:self.email.text loginUserPassword:self.password.text andCallback:^(id obj) {
            NSDictionary *dic = obj;
            NSNumber *error = [dic objectForKey:@"error"];
            NSString *errorMessage = [dic objectForKey:@"errorMessage"];
            if ([error isEqualToNumber:[NSNumber numberWithInteger:1]]) {
                self.userInfo = [LoginJsonParser parseUserInfoInLogin:[dic objectForKey:@"student"] isTeacher:NO];
                [self saveUserInfoToLocal:self.userInfo];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:errorMessage delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
        
        
        // 跳转到主屏幕，或者回到“我”界面
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        NSLog(@"返回错误警告");
    }

}

// 添加透明指示栏
- (void)addActivityBackgroundView {
    if (self.activityBackgroundView == nil) {
        self.activityBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
        self.activityBackgroundView.backgroundColor = [UIColor blackColor];
        self.activityBackgroundView.alpha = 0.1f;
        [self.view addSubview:self.activityBackgroundView];
    }
    if (![self.activityBackgroundView isDescendantOfView:self.view]) {
        [self.view addSubview:self.activityBackgroundView];
    }
}

// 移除透明指示栏
- (void)removeActivityBackgroundView {
    if (self.activityBackgroundView) {
        if ([self.activityBackgroundView isDescendantOfView:self.view]) {
            [self.activityBackgroundView removeFromSuperview];
        }
        self.activityBackgroundView = nil;
    }
}

- (IBAction)clickOnRegisterButton:(id)sender {
    [self performSegueWithIdentifier:@"ShowRegister" sender:self];
}

- (IBAction)clickOnForgetPasswordButton:(id)sender {
    [self performSegueWithIdentifier:@"ShowFindPassword" sender:self];
}

- (IBAction)didEndOnExit:(id)sender {
    [self.password becomeFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [self.email resignFirstResponder];
    [self.password resignFirstResponder];
}
#pragma mark - 判断用户信息和邮箱有效性
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



#pragma mark - 保存用户信息至NSUserDefault，同时记录登陆状态
- (void)saveUserInfoToLocal:(UserInfo *)ui{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *udObject = [NSKeyedArchiver archivedDataWithRootObject:ui];
    [ud setObject:udObject forKey:@"userInfo"];
    NSNumber *isUserDidLogin = [[NSNumber alloc]initWithBool:YES];
    [ud setObject:isUserDidLogin forKey:@"isUserDidLogin"];
    [ud synchronize];
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
