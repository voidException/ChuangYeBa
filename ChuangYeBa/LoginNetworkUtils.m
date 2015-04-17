//
//  NetworkUtils.m
//  ChuangYeBaDemo
//
//  Created by Developer on 15/3/30.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "LoginNetworkUtils.h"

//static NSString *serverIP = @"http://localhost:8080";
static NSString *serverIP = @"http://10.174.90.146:8080/";


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
    }];
}


// 用户提交修改基本信息的类方法
+ (void)subbmitEditedUserInfo:(UserInfo *)userInfo andCallback:(Callback)callback {
    NSString *path = @"http://localhost:8080/startup/student/register";
    
    //提交的参数写在这里⬇️
    NSDictionary *params = nil;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    
    [manager GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"提交成功：%@",dic);
        callback(dic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"提交失败");
        // 没有回调
        callback(nil);
    }];
}



@end
