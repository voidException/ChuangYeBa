//
//  ClassNetworkUtils.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/14.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "ClassNetworkUtils.h"
#import "GlobalDefine.h"

static NSString *serverIP = SERVER_IP;

@implementation ClassNetworkUtils

#pragma mark - 老师学生两端公用接口
// 接口3
+ (void)requestQuizsByitemId:(NSNumber *)itemId andCallback:(Callback)callback {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *path = @"/startup/student/test/getTest";
    path = [serverIP stringByAppendingString:path];
    
    NSDictionary *params = @{@"itemId":itemId};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    [manager GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"请求成功，返回对象为 %@", responseObject);
        callback(responseObject);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ClassNetworkUtils failureAction:error];
        callback(nil);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}


// 接口6
+ (void)requestClassInfoByClassNo:(NSNumber *)classNo andCallback:(Callback)callback {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
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
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ClassNetworkUtils failureAction:error];
        callback(nil);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

// 接口7
+ (void)submitQuitClassWithUserId:(NSNumber *)stuId andClassId:(NSNumber *)classId andCallback:(Callback)callback {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
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
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ClassNetworkUtils failureAction:error];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    
}

#pragma mark - 学生版请求
#ifdef STUDENT_VERSION
// 接口1
+ (void)requestTestGroupByStudentId:(NSNumber *)stuId andCallback:(Callback)callback {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *path = @"/startup/student/class/getItemtest";
    path = [serverIP stringByAppendingString:path];
    
    // 修改这里的参数
    NSDictionary *params = @{@"stuId":stuId};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    [manager GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"请求的结果为 = %@", responseObject);
        
        NSDictionary *dic = responseObject;
        callback(dic);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ClassNetworkUtils failureAction:error];
        callback(nil);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}


// 接口2
+ (void)requestAddClassByStudentId:(NSNumber *)stuId andClassNo:(NSNumber *)classNo andCallback:(Callback)callback {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *path = @"/startup/student/class/addClass";
    path = [serverIP stringByAppendingString:path];
    
    // 修改这里的参数
    NSDictionary *params = @{@"classNo": classNo, @"stuId": stuId};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    [manager GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"请求成功 返回参数为 = %@", responseObject);

        callback(responseObject);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ClassNetworkUtils failureAction:error];
        callback(nil);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];

}

// 接口4
+ (void)requestTestResultByStuId:(NSNumber *)stuId andClassId:(NSNumber *)classId andItemId:(NSNumber *)itemId andCallback:(Callback)callback {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
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
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ClassNetworkUtils failureAction:error];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

// 接口5
+ (void)submitTestResult:(NSArray *)testResult andCallback:(Callback)callback {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
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
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ClassNetworkUtils failureAction:error];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}




+ (void)submitToClearResultByStudentId:(NSString *)stuId andClassId:(NSString *)classId andItemId:(NSString *)itemId {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
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
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ClassNetworkUtils failureAction:error];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

#pragma mark - 老师版请求
#elif TEACHER_VERSION
// 老师版请求封装
// 请求接口1，获取班级信息
+ (void)requestClassInfosWithTeacherId:(NSNumber *)teacherId andCallback:(Callback)callback {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *path = @"/startup/teacher/class/getClass";
    path = [serverIP stringByAppendingString:path];
    NSDictionary *params = @{@"teacherId": teacherId};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [manager GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 测试，打印读取的结果
#ifdef DEBUG
        NSLog(@"请求的结果为 = %@", responseObject);
#endif
        callback(responseObject);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        callback(nil);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];

}
// 请求接口2，创建班级
+ (void)submitToCreateClassWithClassName:(NSString *)className universityName:(NSString *)universityName studentNum:(NSNumber *)studentNum teacherId:(NSNumber *)teacherId andCallback:(Callback)callback {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *path = @"/startup/teacher/class/createClass";
    path = [serverIP stringByAppendingString:path];
    
    NSDictionary *params = @{@"className": className, @"universityName": universityName, @"studentNum": studentNum, @"teacherId": teacherId};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    [manager POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 测试，打印读取的结果
#ifdef DEBUG
        NSLog(@"请求的结果为 = %@", responseObject);
#endif
        callback(responseObject);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ClassNetworkUtils failureAction:error];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];

}
// 请求接口3，更改班级信息
+ (void)submitModifiedClassInfo:(ClassInfo *)classInfo andCallback:(Callback)callback {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *path = @"/startup/teacher/class/changeClassMessage";
    path = [serverIP stringByAppendingString:path];
    
    NSDictionary *params = @{@"classId":classInfo.classId,
                             @"className":classInfo.classroomName,
                             @"maxStudentNum":classInfo.studentNum,
                             @"photoPath":classInfo.photoPath,
                             @"universityName":classInfo.universityName,
                             };
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    [manager POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 测试，打印读取的结果
#ifdef DEBUG
        NSLog(@"请求的结果为 = %@", responseObject);
#endif
        callback(responseObject);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        callback(nil);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

// 请求接口4，获取班级题组
+ (void)requestTestGroupByClassId:(NSNumber *)classId andCallback:(Callback)callback {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *path = @"/startup/teacher/test/getItem";
    path = [serverIP stringByAppendingString:path];
    NSDictionary *params = @{@"classId": classId};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [manager GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 测试，打印读取的结果
#ifdef DEBUG
        NSLog(@"请求的结果为 = %@", responseObject);
#endif
        callback(responseObject);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ClassNetworkUtils failureAction:error];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];

}

// 请求接口5，添加题组
+ (void)submitAddTestGroupWithClassId:(NSNumber *)classId itemId:(NSNumber *)itemId andCallback:(Callback)callback {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *path = @"/startup/teacher/test/addItem";
    path = [serverIP stringByAppendingString:path];
    NSDictionary *params = @{@"classId": classId, @"itemId": itemId};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [manager GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 测试，打印读取的结果
#ifdef DEBUG
        NSLog(@"请求的结果为 = %@", responseObject);
#endif
        callback(responseObject);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ClassNetworkUtils failureAction:error];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];

}

// 请求接口6，删除班级里的题组
+ (void)submitDeleteTestGroupByClassId:(NSNumber *)classId itemId:(NSNumber *)itemId andCallback:(Callback)callback {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *path = @"/startup/teacher/test/deleteItem";
    path = [serverIP stringByAppendingString:path];
    NSDictionary *params = @{@"classId": classId, @"itemId": itemId};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [manager GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 测试，打印读取的结果
#ifdef DEBUG
        NSLog(@"请求的结果为 = %@", responseObject);
#endif
        callback(responseObject);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ClassNetworkUtils failureAction:error];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];

}

// 请求接口7，更新题组激活状态
+ (void)requestUpdateTestGroupStateByClassId:(NSNumber *)classId itemId:(NSNumber *)itemId state:(NSNumber *)state andCallback:(Callback)callback {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *path = @"/startup/teacher/test/updateItem";
    path = [serverIP stringByAppendingString:path];
    
    NSDictionary *params = @{@"classId": classId, @"itemId": itemId, @"state": state};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    [manager POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 测试，打印读取的结果
#ifdef DEBUG
        NSLog(@"请求的结果为 = %@", responseObject);
#endif
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        callback(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ClassNetworkUtils failureAction:error];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];

}

// 请求接口8，获取所有题组
+ (void)requestAllTestGroupByTeacherId:(NSNumber *)teacherId andCallback:(Callback)callback {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *path = @"/startup/teacher/test/getAllItem";
    path = [serverIP stringByAppendingString:path];
    NSDictionary *params = @{@"teacherId": teacherId};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [manager GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 测试，打印读取的结果
#ifdef DEBUG
        NSLog(@"请求的结果为 = %@", responseObject);
#endif
        callback(responseObject);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ClassNetworkUtils failureAction:error];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];

}

// 请求接口9，获取题目正确率
+ (void)requestTestStatisticsByClassId:(NSNumber *)classId itemId:(NSNumber *)itemId andCallback:(Callback)callback {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *path = @"/startup/teacher/test/getItemAccuracy";
    path = [serverIP stringByAppendingString:path];
    NSDictionary *params = @{@"classId": classId, @"itemId": itemId};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [manager GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 测试，打印读取的结果
#ifdef DEBUG
        NSLog(@"请求的结果为 = %@", responseObject);
#endif
        callback(responseObject);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ClassNetworkUtils failureAction:error];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];

}

// 请求接口10，获取学生成绩
+ (void)requestTestGradesByClassId:(NSNumber *)classId andCallback:(Callback)callback {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *path = @"/startup/teacher/test/getStudentGrade";
    path = [serverIP stringByAppendingString:path];
    NSDictionary *params = @{@"classId": classId};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [manager GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 测试，打印读取的结果
#ifdef DEBUG
        NSLog(@"请求的结果为 = %@", responseObject);
#endif
        callback(responseObject);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ClassNetworkUtils failureAction:error];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];

}

#endif

#pragma mark - 辅助方法
// 辅助方法，处理失败请求
+ (void)failureAction:(NSError *) error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请求失败了" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
    [alert show];
#ifdef DEBUG
    NSLog(@"请求失败: %@", [error localizedDescription]);
#endif

}


@end
