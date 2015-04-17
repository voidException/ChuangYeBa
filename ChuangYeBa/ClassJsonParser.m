//
//  ClassJsonParser.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/14.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "ClassJsonParser.h"



@implementation ClassJsonParser


+ (NSMutableArray *) parseQuizs:(NSArray *)arr {
    NSMutableArray *mutableArr = [[NSMutableArray alloc] init];
    Quiz *quiz = [[Quiz alloc] init];
    for (int i; i < arr.count; i++) {
        NSDictionary *dic = arr[i];
        quiz = [self parseQuiz:dic];
        [mutableArr addObject:quiz];
    }
    return mutableArr;
}

+ (Quiz *) parseQuiz:(NSDictionary *) dic {
    Quiz *quiz = [[Quiz alloc] init];
    quiz.question = [dic objectForKey:@"itemmain"];
    NSArray *optionArray = [[NSArray alloc]initWithObjects:[dic objectForKey:@"optiona"] ,[dic objectForKey:@"optionb"] ,[dic objectForKey:@"optionc"] ,[dic objectForKey:@"optiond"] , nil];
    quiz.options = optionArray;
    quiz.answerOption = [dic objectForKey:@"answer"];
    quiz.answerExplain = [dic objectForKey:@"whySo"];
    return quiz;
}


@end
