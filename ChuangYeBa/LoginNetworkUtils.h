//
//  NetworkUtils.h
//  ChuangYeBaDemo
//
//  Created by Developer on 15/3/30.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
#import "UserInfo.h"

typedef void (^Callback)(id obj);
@interface LoginNetworkUtils : NSObject

+ (void)loginUserName:(NSString *)userName loginUserPassword:(NSString *)userPassword andCallback:(Callback)callBack;

+ (void)registerUserInfo:(UserInfo *)userInfo andCallBack:(Callback)callback;

+ (void)subbmitEditedUserInfo:(UserInfo *)userInfo andCallback:(Callback)callback;


// 需要移到其他的类来封装更好



@end
