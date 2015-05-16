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
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
#ifdef STUDENT_VERSION
    NSString *path = @"/startup/student/login";
    NSDictionary *params = @{@"studentEmail": userName, @"studentPassword":userPassword};
#elif TEACHER_VERSION
    NSString *path = @"/startup/teacher/login";
    NSDictionary *params = @{@"teacherEmail": userName, @"teacherPassword":userPassword};
#endif
    
    path = [serverIP stringByAppendingString:path];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //申明请求和接收的数据都是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
        [manager POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSLog(@"登陆成功：%@",dic);
        callback(dic);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"登陆失败, %@", [error localizedDescription]);
        callback(nil);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}



// 用户注册类方法
+ (void)registerUserInfo:(UserInfo *)userInfo andCallBack:(Callback)callback {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
#ifdef STUDENT_VERSION
    NSString *path = @"/startup/student/register";
    NSDictionary *params = @{@"stuName": userInfo.name, @"stuNo": userInfo.userNo, @"stuPassword": userInfo.password, @"stuPasswordRepeat": userInfo.passwordConfirm, @"stuEmail": userInfo.email};
#elif TEACHER_VERSION
    NSString *path = @"/startup/teacher/register";
    NSDictionary *params = @{@"teacherName": userInfo.name, @"password": userInfo.password, @"passwordRepeat": userInfo.passwordConfirm, @"teacherEmail": userInfo.email};
#endif
    
    path = [serverIP stringByAppendingString:path];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [manager POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSLog(@"注册成功: %@", dic);
        callback(dic);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"注册失败: %@", [error localizedDescription]);
        callback(nil);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}
 
+ (void)requestFindPasswordByEmail:(NSString *)email andCallback:(Callback)callback {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *path = @"/startup/student/findPassword";
    path = [serverIP stringByAppendingString:path];
    NSDictionary *params = @{@"stuEmail": email};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [manager GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSLog(@"找回密码成功: %@", dic);
        callback(dic);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"找回密码失败: %@", [error localizedDescription]);
        callback(nil);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}




@end
