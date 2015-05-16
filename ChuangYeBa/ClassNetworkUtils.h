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

#ifdef STUDENT_VERSION
// 学生版请求封装
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

#elif TEACHER_VERSION
// 老师版请求封装
// 请求接口1，获取班级信息
+ (void)requestClassInfosWithTeacherId:(NSNumber *)teacherId andCallback:(Callback)callback;

// 请求接口2，创建班级
+ (void)submitToCreateClassWithClassName:(NSString *)className universityName:(NSString *)universityName studentNum:(NSNumber *)studentNum teacherId:(NSNumber *)teacherId andCallback:(Callback)callback;

// 请求接口3，更改班级信息
+ (void)submitModifiedClassInfo:(ClassInfo *)classInfo andCallback:(Callback)callback;

// 请求接口4，获取班级题组
+ (void)requestTestGroupByClassId:(NSNumber *)classId andCallback:(Callback)callback;

// 请求接口5，添加题组
+ (void)submitAddTestGroupWithClassId:(NSNumber *)classId itemId:(NSNumber *)itemId andCallback:(Callback)callback;

// 请求接口6，删除班级里的题组
+ (void)submitDeleteTestGroupByClassId:(NSNumber *)classId itemId:(NSNumber *)itemId andCallback:(Callback)callback;

// 请求接口7，更新题组激活状态
+ (void)requestUpdateTestGroupStateByClassId:(NSNumber *)classId itemId:(NSNumber *)itemId state:(NSNumber *)state andCallback:(Callback)callback;

// 请求接口8，获取所有题组
+ (void)requestAllTestGroupByTeacherId:(NSNumber *)teacherId andCallback:(Callback)callback;

// 请求接口9，获取题目正确率
+ (void)requestTestStatisticsByClassId:(NSNumber *)classId itemId:(NSNumber *)itemId andCallback:(Callback)callback;

// 请求接口10，获取学生成绩
+ (void)requestTestGradesByClassId:(NSNumber *)classId andCallback:(Callback)callback;

#endif


// 辅助方法
+ (void)failureAction:(NSError *) error;

@end
