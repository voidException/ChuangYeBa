//
//  StudyNetworkUtils.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/16.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "StudyNetworkUtils.h"

// 公司
static NSString *serverIP = @"http://10.174.90.146:8080/";
// 家
//static NSString *serverIP = @"http:";

@implementation StudyNetworkUtils

+ (void)requestArticalWichToken:(NSString *)token userId:(NSString *)userId tag:(NSInteger)tag page:(NSInteger)page pageSize:(NSInteger)pageSize andCallback:(Callback)callback {
    NSString *path = @"/startup/learn/articleList";
    path = [serverIP stringByAppendingString:path];
    
    NSDictionary *param = @{@"token":token, @"iD":userId, @"tag":[NSNumber numberWithInteger:tag], @"page":[NSNumber numberWithInteger:page], @"pageSize":[NSNumber numberWithInteger:pageSize]};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    [manager POST:path parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 测试，打印读取的结果
        NSLog(@"请求的结果为 = %@", responseObject);
        callback(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];

}
@end
