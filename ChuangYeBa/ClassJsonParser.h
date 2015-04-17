//
//  ClassJsonParser.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/14.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Quiz.h"

@interface ClassJsonParser : NSObject

// 解析3，解析获取题组内所有题目信息，返回一个题目数组
+ (NSMutableArray *) parseQuizs:(NSDictionary *) dic;
+ (Quiz *) parseQuiz:(NSDictionary *) dic;

@end
