//
//  RegisterViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/2.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)clickOnRegisterButton:(id)sender {
    UserInfo *userInfo = [[UserInfo alloc] init];
    userInfo.email = self.email.text;
    userInfo.password = self.password.text;
    userInfo.passwordConfirm = self.passwordConfirm.text;
    userInfo.name = self.userName.text;
    userInfo.studentNo = self.userID.text;
    [NetworkUtils registerUserInfo:userInfo andCallBack:^(id obj){
        NSLog(@"进入注册回调");
    }];
    // 返回到登陆菜单，需要点击登陆
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickOnHaveIDButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didEndOnExit:(id)sender {
    if (self.email.isFirstResponder) {
        [self.password becomeFirstResponder];
    }
    else {
        [self.passwordConfirm becomeFirstResponder];
    }

}

- (IBAction)backgroundTap:(id)sender {
    [self.email resignFirstResponder];
    [self.password resignFirstResponder];
    [self.passwordConfirm resignFirstResponder];
}
#pragma mark - 判断用户信息和邮箱有效性
// 在本地判断是否登陆信息有效
- (BOOL)isLoginInfoLegal {
    if (self.email.text.length > 30
        || self.password.text.length < 4
        || self.password.text.length > 10
        || ![self.password.text isEqualToString: self.passwordConfirm.text]) {
        
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

#pragma mark - Text Feild Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    static NSInteger illegalLength = 30;
    if (textField == self.email)
    {
        if (textField.text.length > illegalLength) {
            textField.textColor = [UIColor redColor];
            self.registerButton.enabled = NO;
            //textField.
        }
        else {
            textField.textColor = [UIColor blackColor];
            self.registerButton.enabled = YES;
        }
        NSLog(@"change one time");
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"textfield end editing");
    if (textField == self.email) {
        if (textField.text.length > 30 || ![self isValidateEmail:textField.text]) {
            UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"邮箱的长度请小于30个字符,或请输入有效的邮箱" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alerView show];
            //textField.textColor = [UIColor redColor];
        }
    }
}



@end
