//
//  NetworkUtils.m
//  ChuangYeBaDemo
//
//  Created by Developer on 15/3/30.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "LoginNetworkUtils.h"
#import "GlobalDefine.h"

static NSString *serverIP = SERVER_IP;

@implementation LoginNetworkUtils


// 用户登陆类方法
+ (void)loginUserName:(NSString *)userName loginUserPassword:(NSString *)userPassword andCallback:(Callback)callback {
    // 请求地址
    NSString *path = @"/startup/student/login";
    path = [serverIP stringByAppendingString:path];
    NSDictionary *params = @{@"studentEmail": userName, @"studentPassword":userPassword};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //申明请求和接收的数据都是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
        [manager POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSLog(@"登陆成功：%@",dic);
        callback(dic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"登陆失败, %@", [error localizedDescription]);
        //[LoginNetworkUtils failureAction:error];
        callback(nil);
    }];
}



// 用户注册类方法
+ (void)registerUserInfo:(UserInfo *)userInfo andCallBack:(Callback)callback {
    NSString *path = @"/startup/student/register";
    path = [serverIP stringByAppendingString:path];
     NSLog(@"Request Path = %@",path);
    
    NSDictionary *params = @{@"stuName": userInfo.name, @"stuNo": userInfo.userNo, @"stuPassword": userInfo.password, @"stuPasswordRepeat": userInfo.passwordConfirm, @"stuEmail": userInfo.email};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [manager POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSLog(@"注册成功: %@", dic);
        callback(dic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"注册失败: %@", [error localizedDescription]);
        //[LoginNetworkUtils failureAction:error];
        callback(nil);
    }];
}
 
+ (void)requestFindPasswordByEmail:(NSString *)email andCallback:(Callback)callback {
    NSString *path = @"/startup/student/findPassword";
    path = [serverIP stringByAppendingString:path];
    NSDictionary *params = @{@"stuEmail": email};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [manager GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSLog(@"找回密码成功: %@", dic);
        callback(dic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"找回密码失败: %@", [error localizedDescription]);
        //[LoginNetworkUtils failureAction:error];
        callback(nil);
    }];
}

// 辅助方法，处理失败请求
+ (void)failureAction:(NSError *) error {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请求失败了" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
    [alert show];
    NSLog(@"请求失败: %@", [error localizedDescription]);
    
}



@end
