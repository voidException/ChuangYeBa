//
//  ClassNetworkUtils.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/14.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClassJsonParser.h"
#import "AFHTTPRequestOperationManager.h"


typedef void (^Callback)(id obj);

@interface ClassNetworkUtils : NSObject

// 请求接口1，学生获取班级题组
+ (void)requestTestGroupByStudentId:(NSNumber *)stuId andCallback:(Callback)callback;

// 请求接口2，学生加入班级返回题组
+ (void)requestAddClassByStudentId:(NSNumber *)stuId andClassNo:(NSNumber *)classNo andCallback:(Callback)callback;

// 请求接口3，获取题组内所有题目信息
+ (void)requestQuizsByitemId:(NSNumber *)itemId andCallback:(Callback)callback;

// 请求接口4，获取学生题目结果
+ (void)requestTestResultByStuId:(NSNumber *)stuId andClassId:(NSNumber *)classId andItemId:(NSNumber *)itemId andCallback:(Callback)callback;

// 请求接口5，学生插入测试结果
+ (void)submitTestResult:(NSArray *)testResult andCallback:(Callback)callback;

// 请求接口6，返回班级信息以及老师名字，学生列表
+ (void)requestClassInfoByClassNo:(NSNumber *)classNo andCallback:(Callback)callback;

// 请求接口7，退出班级
+ (void)submitQuitClassWithUserId:(NSNumber *)stuId andClassId:(NSNumber *)classId andCallback:(Callback)callback;

// 请求接口8，清空学生题目结果
+ (void)submitToClearResultByStudentId:(NSString *)stuId andClassId:(NSNumber *)classId andItemId:(NSString *)itemId;


// 辅助方法
+ (void)failureAction:(NSError *) error;

@end
