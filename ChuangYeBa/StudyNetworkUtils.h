//
//  StudyNetworkUtils.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/16.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"

typedef void (^Callback)(id obj);

@interface StudyNetworkUtils : NSObject

// 请求文章列表
+ (void)requestArticalWichToken:(NSString *)token userId:(NSString *)userId tag:(NSInteger)tag page:(NSInteger)page pageSize:(NSInteger)pageSize andCallback:(Callback)callback;

@end
