//
//  RegisterTableViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/13.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "RegisterTableViewController.h"

@interface RegisterTableViewController ()

@end

@implementation RegisterTableViewController

#pragma mark - 视图生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化标题
    self.title = @"注册";
    
    // 初始化buttonView的高度
    self.buttonView.frame = CGRectMake(0, 0, self.view.frame.size.width, 80);
    
    // 初始化取消按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(clickOnCancelButton)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    
     
    
    // 初始化tableView的点击动作
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)];
    [self.tableView addGestureRecognizer:tapGesture];
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


#pragma mark - 调整再键盘弹出时的Frame
- (CGFloat)keyboardEndingFrameHeight:(NSDictionary *)userInfo//计算键盘的高度
{
    //CGRect keyboardEndingUncorrectedFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
#warning 重要！真机测试中切换不同的键盘时会出现高度BUG。
    CGRect keyboardBeginingUncorrectedFrame = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey]CGRectValue];
    CGRect keyboardEndingFrame = [self.view convertRect:keyboardBeginingUncorrectedFrame fromView:nil];
    NSLog(@"keyB height = %f", keyboardEndingFrame.size.height);
    NSLog(@"keyB orgin X = %f", keyboardEndingFrame.origin.y);
    return keyboardEndingFrame.size.height;
}

// 键盘出现后调整视图
-(void)keyboardWillAppear:(NSNotification *)notification
{
    CGRect currentFrame = self.tableView.frame;
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

#pragma mark - 判断用户信息和邮箱有效性
// 在本地判断是否登陆信息有效
- (BOOL)isRegisterInfoLegal {
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
        [LoginNetworkUtils registerUserInfo:userInfo andCallBack:^(id obj) {
            NSDictionary *dic = obj;
#warning 重要！！功能没有做完！！！！！
            //NSNumber *error = [dic objectForKey:@"error"];
            NSString *errorMessage = [dic objectForKey:@"errorMessage"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:errorMessage delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alert show];
            NSLog(@"注册成功");
        }];
    } else {
        NSLog(@"返回本地警告信息");
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else {
        return 2;
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
