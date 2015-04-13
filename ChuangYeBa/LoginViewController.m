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
    
    // 添加临时登陆信息
    self.email.text = @"zachary0513@126.com";
    self.password.text = @"aaaaaa";
    
    // 初始化TextField的委托对象
    self.email.delegate = self;
    self.password.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickOnLoginButton:(id)sender {
    if ([self isLoginInfoLegal]) {
        
        // 测试登陆请求
        // 使用封装的请求类 NetworkUtils
        [NetworkUtils loginUserName:self.email.text loginUserPassword:self.password.text andCallback:^(id obj) {
            
            // TO do 可以把登陆返回信息加入并存储至本地
            //NSDictionary *dic = obj;
            
            // 模拟成功加载了用户数据
            
        }];
        [self loadUserInfo];
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSNumber *isUserDidLogin = [[NSNumber alloc]initWithBool:YES];
        [ud setObject:isUserDidLogin forKey:@"isUserDidLogin"];
        [ud synchronize];
        // 跳转到主屏幕
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        
        //[self performSegueWithIdentifier:@"ShowMainScreen" sender:sender];
    }
    else {
        NSLog(@"返回错误警告");
    }

}

- (IBAction)clickOnRegisterButton:(id)sender {
    
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



#pragma mark - 零时添加测试数据
- (void)loadUserInfo {
    
    // 基本信息
    self.userInfo = [[UserInfo alloc]init];
    self.userInfo.name = @"张三";
    self.userInfo.sex = @"男";
    self.userInfo.studentNo = @"12112112";
    self.userInfo.email = @"zacharyapple001@126.com";
    self.userInfo.school = @"北京大学";
    self.userInfo.major = @"通信工程";
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *udObject = [NSKeyedArchiver archivedDataWithRootObject:self.userInfo];
    [ud setObject:udObject forKey:@"userInfo"];
    [ud synchronize];
    NSLog(@"成功加入UserDefault");
    
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

@end
