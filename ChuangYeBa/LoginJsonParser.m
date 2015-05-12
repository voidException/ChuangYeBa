//
//  LoginJsonParser.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/15.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "LoginJsonParser.h"


@implementation LoginJsonParser

+ (UserInfo *)parseUserInfoInLogin:(NSDictionary *)dic isTeacher:(BOOL) isTeacher {
    UserInfo *userInfo = [[UserInfo alloc] init];
    if (isTeacher) {
        NSLog(@"返回teacher");
        return userInfo;
    } else {
        userInfo.userId = [dic objectForKey:@"stuid"];
        userInfo.name = [dic objectForKey:@"stuname"];
        userInfo.userNo = [dic objectForKey:@"stuno"];
        userInfo.major = [dic objectForKey:@"stumajor"];
        userInfo.school = [dic objectForKey:@"stuschool"];
        userInfo.classNo = [dic objectForKey:@"roomno"];
        userInfo.department = [dic objectForKey:@"department"];
        userInfo.college = [dic objectForKey:@"college"];
        userInfo.universityNo = [dic objectForKey:@"universityno"];
        userInfo.universityName = [dic objectForKey:@"universityname"];
        if ([dic objectForKey:@"sex"]) {
            userInfo.sex = @"男";
        } else {
            userInfo.sex = @"女";
        }
#warning 待做！inColleageDate 没有配置
        //userInfo.inCollegeDate =
        userInfo.email = [dic objectForKey:@"email"];
        userInfo.password = [dic objectForKey:@"passwords"];
        userInfo.photoPath = [dic objectForKey:@"photo"];
        userInfo.isPhotoUpload = [dic objectForKey:@"photoupload"];
        return userInfo;
    }
}

// 目前仅仅限于修改学生信息
+ (NSDictionary *)packageUserInfo:(UserInfo *)userInfo {
    NSDictionary *dic = [[NSDictionary alloc] init];
    
    NSNumber *sex = [[NSNumber alloc] init];
    if ([userInfo.sex isEqualToString:@"男"]) {
        sex = @NO;
    } else {
        sex = @YES;
    }
    
#warning 未完善的数据
    // TEMP ***********
    NSString *dateString = @"2010-09-01";
    if (userInfo.inCollegeDate == nil) {
        NSDate *nowDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        // 目前数据库只能支持到年月日，如果加时分秒服务器会无法返回
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        dateString = [dateFormatter stringFromDate:nowDate];
    }
    //
    userInfo.isPhotoUpload = @NO;
    // TEMP END************
    
    dic = @{@"stuid":userInfo.userId,
            @"stuname":userInfo.name,
            @"stuno":userInfo.userNo,
            @"stumajor":userInfo.major,
            @"stuschool":userInfo.school,
            @"roomno":userInfo.classNo,
            @"department":userInfo.department,
            @"college":userInfo.college,
            @"universityno":userInfo.universityNo,
            @"universityname":userInfo.universityName,
            @"sex":sex,
            @"incollege":dateString,
            @"email":userInfo.email,
            @"passwords":userInfo.password,
            @"photo":userInfo.photoPath,
            @"photoupload":userInfo.isPhotoUpload
            };
    return dic;
}

@end
