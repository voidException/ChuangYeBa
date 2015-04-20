//
//  ClassNetworkUtils.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/14.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "ClassNetworkUtils.h"
#import "GlobalDefine.h"
// 公司
//static NSString *serverIP = @"http://10.174.90.146:8080/";
// 家
static NSString *serverIP = SERVER_IP;

@implementation ClassNetworkUtils

// 接口1
+ (void)requestQuizsByitemId:(NSString *)quizsID andCallback:(Callback)callback {
    NSString *path = @"/startup/student/test/getTest";
    path = [serverIP stringByAppendingString:path];
    
    // 修改这里的参数
    quizsID = @"1";
    
    NSDictionary *params = @{@"itemId":quizsID};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    [manager GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        callback(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ClassNetworkUtils failureAction:error];
    }];
}

// 接口2
+ (void)requestTestGroupByStudentId:(NSString *)stuId andClassNo:(NSString *)classNo andCallback:(Callback)callback {
    NSString *path = @"/startup/student/class/addClass";
    path = [serverIP stringByAppendingString:path];
    
    // 修改这里的参数
    NSDictionary *params = @{@"classNo": classNo, @"stuId": stuId};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    [manager GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        callback(responseObject);
        NSLog(@"请求成功 返回参数为 = %@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ClassNetworkUtils failureAction:error];
    }];

}

// 接口3
+ (void)requestClassByStudentId:(NSString *)stuId andCallback:(Callback)callback {
    NSString *path = @"/startup/student/class/getItemtest";
    path = [serverIP stringByAppendingString:path];
    
    // 修改这里的参数
    NSDictionary *params = @{@"stuId":stuId};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    [manager GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 测试，打印读取的结果
        NSLog(@"请求的结果为 = %@", responseObject);
        callback(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ClassNetworkUtils failureAction:error];
    }];
}

// 接口4
+ (void)requestTestResultByStuId:(NSString *)stuId andClassId:(NSString *)classId andItemId:(NSString *)itemId andCallback:(Callback)callback {
    NSString *path = @"/startup/student/test/getTestResult";
    path = [serverIP stringByAppendingString:path];
    
    // 修改这里的参数
    NSDictionary *params = @{@"stuId": stuId, @"classId": classId, @"itemId": itemId};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    [manager POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 测试，打印读取的结果
        NSLog(@"请求的结果为 = %@", responseObject);
        callback(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ClassNetworkUtils failureAction:error];
    }];
}

// 接口5
+ (void)submitTestResult:(NSArray *)testResult andCallback:(Callback)callback {
    NSString *path = @"/startup/student/test/addTestResult";
    path = [serverIP stringByAppendingString:path];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    [manager POST:path parameters:testResult success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 测试，打印读取的结果
        NSLog(@"请求的结果为 = %@", responseObject);
        callback(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ClassNetworkUtils failureAction:error];
    }];
}

// 接口6
+ (void)requestClassInfoByClassNo:(NSString *)classNo andCallback:(Callback)callback {
    NSString *path = @"/startup/student/class/getClassMessage";
    path = [serverIP stringByAppendingString:path];
    
    // 修改这里的参数
    NSDictionary *params = @{@"classNo":classNo};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    [manager GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 测试，打印读取的结果
        NSLog(@"请求的结果为 = %@", responseObject);
        callback(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ClassNetworkUtils failureAction:error];
    }];
}

// 接口7
+ (void)submitQuitClassWithUserId:(NSString *)stuId andClassId:(NSString *)classId andCallback:(Callback)callback {
    NSString *path = @"/startup/student/class/quitClass";
    path = [serverIP stringByAppendingString:path];
    
    // 修改这里的参数
    NSDictionary *params = @{@"classId":classId, @"stuId":stuId};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    [manager GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 测试，打印读取的结果
        NSLog(@"请求的结果为 = %@", responseObject);
        callback(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ClassNetworkUtils failureAction:error];
    }];

}

// 辅助方法，处理失败请求
+ (void)failureAction:(NSError *) error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请求失败了" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
    [alert show];
    NSLog(@"请求失败: %@", [error localizedDescription]);

}


@end
