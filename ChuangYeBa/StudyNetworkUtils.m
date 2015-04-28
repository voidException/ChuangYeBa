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

// 公司
//static NSString *serverIP = @"http://10.174.90.146:8080/";
// 家
static NSString *serverIP = SERVER_IP;


@implementation StudyNetworkUtils

// 请求文章列表
+ (void)requestArticalWichToken:(NSString *)token userId:(NSNumber *)userId tag:(NSInteger)tag page:(NSInteger)page pageSize:(NSInteger)pageSize andCallback:(Callback)callback {
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
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"登陆失败, %@", [error localizedDescription]);
        callback(nil);

    }];

}

// 提交一条评论
+ (void)submitCommentWithArticleId:(ArticleInfo *)articleInfo userInfo:(UserInfo *)userInfo commitDate:(NSDate *)commiteDate content:(NSString *)content andCallback:(Callback)callback {
    NSString *path = @"startup/learn/article/comment";
    path = [serverIP stringByAppendingString:path];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // 目前数据库只能支持到年月日，如果加时分秒服务器会无法返回
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:commiteDate];
    
    NSDictionary *param = @{@"articleid":articleInfo.articleId, @"userid":userInfo.userId, @"commenttime":dateString, @"stuname":userInfo.name, @"content":content};
    
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
    NSString *path = @"/startup/learn/article";
    path = [serverIP stringByAppendingString:path];
    
    NSDictionary *param = @{@"articleiD":articleId, @"token":token, @"iD":userId};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    [manager POST:path parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"获取一篇具体的文章成功%@", responseObject);
        callback(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"登陆失败, %@", [error localizedDescription]);
        callback(nil);
    }];
}
// 获取评论列表
+ (void)requestCommentsWithToken:(NSString *)token userId:(NSNumber *)userId articleId:(NSNumber *)articleId page:(NSInteger)page pageSize:(NSInteger)pageSize andCallback:(Callback)callback {
    
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
        NSArray *commentArr = [dic objectForKey:@"comments"];
        NSMutableArray *comments = [[NSMutableArray alloc] init];
        for (NSDictionary *commentDic in commentArr) {
            CommentInfo *commentInfo = [StudyJsonParser parseCommentInfo:commentDic];
            [comments addObject:commentInfo];
        }
        callback(comments);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"获取评论列表失败, %@", [error localizedDescription]);
    }];
}

@end
