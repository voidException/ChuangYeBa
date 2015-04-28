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
    quiz.answerExplain = [dic objectForKey:@"whyso"];
    return quiz;
}

// 解析6.1
+ (ClassInfo *)parseClassInfo:(NSDictionary *) dic {
    ClassInfo *classInfo = [[ClassInfo alloc] init];
    classInfo.classId = [dic objectForKey:@"classid"];
    classInfo.classNo = [dic objectForKey:@"classno"];
    classInfo.classroomName = [dic objectForKey:@"classroomname"];
    classInfo.photo = [dic objectForKey:@"photo"];
    classInfo.realStudentNum =  [dic objectForKey:@"realstudentnum"];
    classInfo.studentNum = [dic objectForKey:@"studentnum"];
    classInfo.universityName = [dic objectForKey:@"universityname"];
    classInfo.universityNo = [dic objectForKey:@"universityno"];
    return classInfo;
}
// 解析6.2
+ (UserInfo *)parseUserInfo:(NSDictionary *)dic {
    UserInfo *userInfo = [[UserInfo alloc] init];
    userInfo.name = [dic objectForKey:@"stuName"];
    userInfo.userNo = [dic objectForKey:@"stuNo"];
    userInfo.photoPath = [dic objectForKey:@"stuPhoto"];
    return userInfo;
}

+ (NSNumber *)paresUserSelection:(NSDictionary *)dic {
    NSNumber *userSelection = [[NSNumber alloc] init];
    userSelection = [dic objectForKey:@"testresult"];
    NSInteger change = [userSelection integerValue]/10;
    userSelection = [NSNumber numberWithInteger:change];
    return userSelection;
}

+ (TestGroup *)parseTestGropu:(NSDictionary *)dic {
    TestGroup *testGroup = [[TestGroup alloc] init];
    testGroup.itemId = [dic objectForKey:@"itemid"];
    testGroup.itemTitle = [dic objectForKey:@"itemtitle"];
    testGroup.describe = [dic objectForKey:@"description"];
    testGroup.itemPhoto = [dic objectForKey:@"itemphoto"];
    testGroup.activity = [dic objectForKey:@"activity"];
    return testGroup;
}

@end
