//
//  StudyNetworkUtils.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/16.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "StudyNetworkUtils.h"
#import "StudyJsonParser.h"
#import "GlobalDefine.h"

static NSString *serverIP = SERVER_IP;

@implementation StudyNetworkUtils

// 请求文章列表
+ (void)requestArticlesWichToken:(NSString *)token userId:(NSNumber *)userId tag:(NSInteger)tag page:(NSInteger)page pageSize:(NSInteger)pageSize andCallback:(Callback)callback {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSString *path = @"/startup/learn/articleList";
    path = [serverIP stringByAppendingString:path];
    
    NSDictionary *param = @{@"token":token, @"iD":userId, @"tag":[NSNumber numberWithInteger:tag], @"page":[NSNumber numberWithInteger:page], @"pageSize":[NSNumber numberWithInteger:pageSize]};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    [manager POST:path parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSString *errorMessage = [dic objectForKey:@"errorMessage"];
        NSLog(@"errorMessage = %@", errorMessage);
        // 测试，打印读取的结果
        NSLog(@"请求的结果为 = %@", responseObject);
        
        callback(responseObject);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"登陆失败, %@", [error localizedDescription]);
        callback(nil);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];

}

// 提交一条评论
+ (void)submitCommentWithArticleId:(ArticleInfo *)articleInfo userInfo:(UserInfo *)userInfo commitDate:(NSDate *)commiteDate content:(NSString *)content andCallback:(Callback)callback {
    NSString *path = @"/startup/learn/article/comment";
    path = [serverIP stringByAppendingString:path];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // 目前数据库只能支持到年月日，如果加时分秒服务器会无法返回
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:commiteDate];
    
#ifdef STUDENT_VERSION
    NSInteger interger = [userInfo.userId integerValue];
    interger = interger * 10 + 1;
    NSNumber *modifiedUserId = [NSNumber numberWithInteger:interger];
#elif TEACHER_VERSION
    NSInteger interger = [userInfo.userId integerValue];
    interger = interger * 10 + 2;
    NSNumber *modifiedUserId = [NSNumber numberWithInteger:interger];
#endif
    
    NSDictionary *param = @{@"articleId":articleInfo.articleId, @"userId":modifiedUserId, @"commentTime":dateString, @"userName":userInfo.name, @"content":content};
    NSLog(@"%@", content);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    [manager POST:path parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"提交评论成功");
        callback(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"提交评论失败, %@", [error localizedDescription]);
        callback(nil);
    }];
}

// 请求一篇具体的文章
+ (void)requestArticleDetailWithToken:(NSString *)token userId:(NSNumber *)userId articleId:(NSNumber *)articleId andCallback:(Callback)callback {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *path = @"/startup/learn/article";
    path = [serverIP stringByAppendingString:path];
    
    NSDictionary *param = @{@"articleiD":articleId, @"token":token, @"iD":userId};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    [manager POST:path parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"获取一篇具体的文章成功%@", responseObject);
        callback(responseObject);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"登陆失败, %@", [error localizedDescription]);
        callback(nil);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}
// 获取评论列表
+ (void)requestCommentsWithToken:(NSString *)token userId:(NSNumber *)userId articleId:(NSNumber *)articleId page:(NSInteger)page pageSize:(NSInteger)pageSize andCallback:(Callback)callback {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *path = @"/startup/learn/article/commentsList";
    path = [serverIP stringByAppendingString:path];
    
    NSDictionary *param = @{@"articleiD":articleId, @"token":token, @"iD":userId, @"page":[NSNumber numberWithInteger:page], @"pageSize":[NSNumber numberWithInteger:pageSize]};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    [manager POST:path parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"获取一评论列表%@", responseObject);
        // 在这里直接解析评论
        
        NSDictionary *dic = responseObject;
        NSArray *commentArr = [dic objectForKey:@"commentsVos"];
        NSMutableArray *comments = [[NSMutableArray alloc] init];
        NSNumber *error = [dic objectForKey:@"error"];
        if ([error isEqualToNumber:@1]) {
            for (NSDictionary *commentDic in commentArr) {
                CommentInfo *commentInfo = [StudyJsonParser parseCommentInfo:commentDic];
                [comments addObject:commentInfo];
            }
        }
        callback(comments);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"获取评论列表失败, %@", [error localizedDescription]);
        callback(nil);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

// 删除一条评论
+ (void)submitDeleteCommentWithToken:(NSString *)token userId:(NSNumber *)userId commentId:(NSNumber *)commentId andCallback:(Callback)callback {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *path = @"/startup/learn/article/delComment";
    path = [serverIP stringByAppendingString:path];
    
#ifdef STUDENT_VERSION
    NSInteger interger = [userId integerValue];
    interger = interger * 10 + 1;
    NSNumber *modifiedUserId = [NSNumber numberWithInteger:interger];
#elif TEACHER_VERSION
    NSInteger interger = [userId integerValue];
    interger = interger * 10 + 2;
    NSNumber *modifiedUserId = [NSNumber numberWithInteger:interger];
#endif
    NSDictionary *param = @{@"token":token, @"iD":modifiedUserId, @"commentiD":commentId};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [manager POST:path parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"成功删除一条评论%@", responseObject);
        callback(responseObject);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"删除评论失败, %@", [error localizedDescription]);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

// 添加一个赞
+ (void)submitAddLoveWithToken:(NSString *)token userId:(NSNumber *)userId articleId:(NSNumber *)articleId andCallback:(Callback)callback {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *path = @"/startup/learn/article/addLove";
    path = [serverIP stringByAppendingString:path];
    
    NSDictionary *param = @{@"token":token, @"iD":userId, @"articleiD":articleId};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [manager POST:path parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"成功增加一条赞 %@", responseObject);
        NSDictionary *dic = responseObject;
        NSNumber *loves = [dic objectForKey:@"number"];
        callback(loves);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"删除评论失败, %@", [error localizedDescription]);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];

}

+ (void)submitDelLoveWithToken:(NSString *)token userId:(NSNumber *)userId articleId:(NSNumber *)articleId andCallback:(Callback)callback {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *path = @"/startup/learn/article/deleteLove";
    path = [serverIP stringByAppendingString:path];
    
    NSDictionary *param = @{@"token":token, @"iD":userId, @"articleiD":articleId};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [manager POST:path parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"成功删除赞 %@", responseObject);
        NSDictionary *dic = responseObject;
        NSNumber *loves = [dic objectForKey:@"number"];
        callback(loves);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"删除赞失败, %@", [error localizedDescription]);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    
}


@end
