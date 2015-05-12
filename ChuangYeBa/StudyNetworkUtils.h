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
+ (void)requestArticlesWichToken:(NSString *)token userId:(NSNumber *)userId tag:(NSInteger)tag page:(NSInteger)page pageSize:(NSInteger)pageSize andCallback:(Callback)callback;

// 提交一条评论
+ (void)submitCommentWithArticleId:(ArticleInfo *)articleInfo userInfo:(UserInfo *)userInfo commitDate:(NSDate *)commiteDate content:(NSString *)content andCallback:(Callback)callback;

// 请求具体的一篇文章
+ (void)requestArticleDetailWithToken:(NSString *)token userId:(NSNumber *)userId articleId:(NSNumber *)articleId andCallback:(Callback)callback;

// 请求评论列表
+ (void)requestCommentsWithToken:(NSString *)token userId:(NSNumber *)userId articleId:(NSNumber *)articleId page:(NSInteger)page pageSize:(NSInteger)pageSize andCallback:(Callback)callback;

// 删除一条评论
+ (void)submitDeleteCommentWithToken:(NSString *)token userId:(NSNumber *)userId commentId:(NSNumber *)commentId andCallback:(Callback)callback;

// 增加一条赞
+ (void)submitAddLoveWithToken:(NSString *)token userId:(NSNumber *)userId articleId:(NSNumber *)articleId andCallback:(Callback)callback;

@end
