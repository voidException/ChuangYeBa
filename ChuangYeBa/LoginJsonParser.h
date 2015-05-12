//
//  LoginJsonParser.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/15.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

@interface LoginJsonParser : NSObject

+ (UserInfo *)parseUserInfoInLogin:(NSDictionary *)dic isTeacher:(BOOL)isTeacher;

+ (NSDictionary *)packageUserInfo:(UserInfo *)userInfo;

@end
