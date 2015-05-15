//
//  ClassJsonParser.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/14.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Quiz.h"
#import "ClassInfo.h"
#import "TestGroup.h"
#import "UserInfo.h"
#import "LoginJsonParser.h"

@interface ClassJsonParser : NSObject

// 解析1，解析题组信息
+ (TestGroup *)parseTestGropu:(NSDictionary *) dic;

// 解析3，解析获取题组内所有题目信息，返回一个题目数组
+ (NSMutableArray *)parseQuizs:(NSDictionary *) dic;

// 解析4，解析用户的选择的选项，返回一个NSNumber对象
+ (NSNumber *)paresUserSelection:(NSDictionary *)dic;

// 解析6.1
+ (ClassInfo *)parseClassInfo:(NSDictionary *) dic;
// 解析6.2
+ (UserInfo *)parseUserInfo:(NSDictionary *) dic;

+ (Quiz *)parseQuiz:(NSDictionary *) dic;

@end
