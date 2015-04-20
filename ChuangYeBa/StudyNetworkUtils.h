//
//  StudyNetworkUtils.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/16.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
#import "ArticleInfo.h"
#import "UserInfo.h"

typedef void (^Callback)(id obj);

@interface StudyNetworkUtils : NSObject

// 请求文章列表
+ (void)requestArticalWichToken:(NSString *)token userId:(NSString *)userId tag:(NSInteger)tag page:(NSInteger)page pageSize:(NSInteger)pageSize andCallback:(Callback)callback;

+ (void)submitCommentWithArticleId:(ArticleInfo *)articleInfo userInfo:(UserInfo *)userInfo commitDate:(NSDate *)commiteDate content:(NSString *)content andCallback:(Callback)callback;

@end
