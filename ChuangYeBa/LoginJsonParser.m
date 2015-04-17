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
#warning inColleageDate 没有配置
        //userInfo.inCollegeDate =
        userInfo.email = [dic objectForKey:@"email"];
        userInfo.password = [dic objectForKey:@"password"];
        userInfo.photoPath = [dic objectForKey:@"photo"];
        if ([dic objectForKey:@"photopupload"]) {
            userInfo.isPhotoUpload = @"YES";
        } else {
            userInfo.isPhotoUpload = nil;
        }
    return userInfo;
    }
}

@end
