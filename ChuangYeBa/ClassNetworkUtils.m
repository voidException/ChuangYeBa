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
+ (void)requestTestGroupByStudentId:(NSNumber *)stuId andCallback:(Callback)callback {
    NSString *path = @"/startup/student/class/getItemtest";
    path = [serverIP stringByAppendingString:path];
    
    // 修改这里的参数
    NSDictionary *params = @{@"stuId":stuId};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    [manager GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"请求的结果为 = %@", responseObject);
        
        NSDictionary *dic = responseObject;
        NSArray *testGroupsDic = [dic objectForKey:@"itemTest"];
        NSMutableArray *testGroups = [[NSMutableArray alloc] init];
        for (NSDictionary *testGroup in testGroupsDic) {
            TestGroup *tg = [ClassJsonParser parseTestGropu:testGroup];
            [testGroups addObject:tg];
        }
        
        callback(testGroups);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ClassNetworkUtils failureAction:error];
        callback(nil);
    }];
}


// 接口2
+ (void)requestAddClassByStudentId:(NSNumber *)stuId andClassNo:(NSNumber *)classNo andCallback:(Callback)callback {
    NSString *path = @"/startup/student/class/addClass";
    path = [serverIP stringByAppendingString:path];
    
    // 修改这里的参数
    NSDictionary *params = @{@"classNo": classNo, @"stuId": stuId};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    [manager GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"请求成功 返回参数为 = %@", responseObject);

        callback(responseObject);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ClassNetworkUtils failureAction:error];
        callback(nil);
    }];

}
// 接口3
+ (void)requestQuizsByitemId:(NSNumber *)itemId andCallback:(Callback)callback {
    NSString *path = @"/startup/student/test/getTest";
    path = [serverIP stringByAppendingString:path];
    
    NSDictionary *params = @{@"itemId":itemId};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    [manager GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"请求成功，返回对象为 %@", responseObject);
        callback(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ClassNetworkUtils failureAction:error];
    }];
}

// 接口4
+ (void)requestTestResultByStuId:(NSNumber *)stuId andClassId:(NSNumber *)classId andItemId:(NSNumber *)itemId andCallback:(Callback)callback {
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
    
    NSDictionary *prarm = @{@"testResult":testResult};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    [manager POST:path parameters:prarm success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 测试，打印读取的结果
        NSLog(@"请求的结果为 = %@", responseObject);
        callback(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ClassNetworkUtils failureAction:error];
    }];
}

// 接口6
+ (void)requestClassInfoByClassNo:(NSNumber *)classNo andCallback:(Callback)callback {
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
        callback(nil);
    }];
}

// 接口7
+ (void)submitQuitClassWithUserId:(NSNumber *)stuId andClassId:(NSNumber *)classId andCallback:(Callback)callback {
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

+ (void)submitToClearResultByStudentId:(NSString *)stuId andClassId:(NSString *)classId andItemId:(NSString *)itemId {
    NSString *path = @"/startup/student/test/deleteTestResult";
    path = [serverIP stringByAppendingString:path];
    
    NSDictionary *params = @{@"stuId": stuId, @"classId": classId, @"itemId": itemId};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    [manager POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 测试，打印读取的结果
        NSLog(@"请求的结果为 = %@", responseObject);
        NSString *errorMessage = [responseObject objectForKey:@"errorMessage"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:errorMessage delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
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
