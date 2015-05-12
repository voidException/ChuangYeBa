//
//  MeNetworkUtils.h
//  ChuangYeBa
//
//  Created by Developer on 15/5/8.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "UserInfo.h"
#import <QiniuSDK.h>

typedef void (^Callback)(id obj);


@interface MeNetworkUtils : NSObject

+ (void)submitModifiedUserInfo:(UserInfo *)userInfo andCallback:(Callback)callback;

+ (void)requestTokenForUploadTokenWithBucket:(NSString *)bucket andCallback:(Callback)callback;

+ (void)uploadPhotoToServer:(UIImage *)image token:(NSString *)token owner:(NSString *)owner date:(NSDate *)date ownerId:(NSNumber *)ownerId andCallback:(Callback)callback;

@end
