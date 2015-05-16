//
//  MeNetworkUtils.m
//  ChuangYeBa
//
//  Created by Developer on 15/5/8.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "MeNetworkUtils.h"
#import "LoginJsonParser.h"
#import "GlobalDefine.h"
static NSString *serverIP = SERVER_IP;

@implementation MeNetworkUtils

+ (void)submitModifiedUserInfo:(UserInfo *)userInfo andCallback:(Callback)callback {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
#ifdef STUDENT_VERSION
    NSString *path = @"/startup/student/changeInfo";
#elif TEACHER_VERSION
    NSString *path = @"/startup/teacher/changeInfo";
#endif
    path = [serverIP stringByAppendingString:path];
    
    NSDictionary *param = [LoginJsonParser packageUserInfo:userInfo];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [manager POST:path parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"成功修改用户信息%@", responseObject);
        callback(responseObject);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"修改用户信息失败, %@", [error localizedDescription]);
        callback(nil);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];

}

+ (void)requestTokenForUploadTokenWithBucket:(NSString *)bucket andCallback:(Callback)callback {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *path = @"/startup/photo/upload/getToken";
    path = [serverIP stringByAppendingString:path];
    
    NSDictionary *param = @{@"bucket":bucket};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [manager GET:path parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"成功修改用户信息%@", responseObject);
        callback(responseObject);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"修改用户信息失败, %@", [error localizedDescription]);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];

}

+ (void)uploadPhotoToServer:(UIImage *)image token:(NSString *)token owner:(NSString *)owner date:(NSDate *)date ownerId:(NSNumber *)ownerId andCallback:(Callback)callback {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    NSString *key = [NSString stringWithFormat:@"%@/%@/%@", owner, dateString, ownerId];
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    [upManager putData:imageData key:key token:token
              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                  NSLog(@"%@", info);
                  NSLog(@"%@", resp);
                  callback(resp);
                  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
              } option:nil];
}

@end
