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
        userInfo.email = [dic objectForKey:@"email"];
        userInfo.name = [dic objectForKey:@"teachername"];
        userInfo.universityNo = [dic objectForKey:@"universityno"];
        userInfo.universityName = [dic objectForKey:@"universityname"];
        userInfo.password = [dic objectForKey:@"passwords"];
        userInfo.photoPath = [dic objectForKey:@"photo"];
        userInfo.tel = [dic objectForKey:@"tel"];
        userInfo.userId = [dic objectForKey:@"teacherid"];
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
#warning inColleageDate 没有配置
        //userInfo.inCollegeDate =
        userInfo.email = [dic objectForKey:@"email"];
        userInfo.password = [dic objectForKey:@"passwords"];
        userInfo.photoPath = [dic objectForKey:@"photo"];
        userInfo.isPhotoUpload = [dic objectForKey:@"photoupload"];
        userInfo.roomno = [dic objectForKey:@"roomno"];
        return userInfo;
    }
}

+ (NSDictionary *)packageUserInfo:(UserInfo *)userInfo {
    NSDictionary *dic = [[NSDictionary alloc] init];
    
#ifdef STUDENT_VERSION
    NSNumber *sex = [[NSNumber alloc] init];
    if ([userInfo.sex isEqualToString:@"男"]) {
        sex = @NO;
    } else {
        sex = @YES;
    }
    NSString *dateString = @"";
    if (userInfo.inCollegeDate == nil) {
        NSDate *nowDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        // 目前数据库只能支持到年月日，如果加时分秒服务器会无法返回
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        dateString = [dateFormatter stringFromDate:nowDate];
    }
    if (userInfo.photoPath.length > 1) {
        userInfo.isPhotoUpload = @YES;
    } else {
        userInfo.isPhotoUpload = @NO;
    }
    
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
#elif TEACHER_VERSION
    dic = @{@"teacherid":userInfo.userId,
            @"teachername":userInfo.name,
            @"universityno":userInfo.universityNo,
            @"universityname":userInfo.universityName,
            @"email":userInfo.email,
            @"passwords":userInfo.password,
            @"photo":userInfo.photoPath,
            @"tel":userInfo.tel
            };
#endif
    return dic;
}

@end
