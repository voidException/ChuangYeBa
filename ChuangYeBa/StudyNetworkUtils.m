//
//  StudyNetworkUtils.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/16.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "StudyNetworkUtils.h"
#import "GlobalDefine.h"

// 公司
//static NSString *serverIP = @"http://10.174.90.146:8080/";
// 家
static NSString *serverIP = SERVER_IP;


@implementation StudyNetworkUtils

+ (void)requestArticalWichToken:(NSString *)token userId:(NSString *)userId tag:(NSInteger)tag page:(NSInteger)page pageSize:(NSInteger)pageSize andCallback:(Callback)callback {
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

+ (void)submitCommentWithArticleId:(ArticleInfo *)articleInfo userInfo:(UserInfo *)userInfo commitDate:(NSDate *)commiteDate content:(NSString *)content andCallback:(Callback)callback {
    NSString *path = @"/startup/learn/article/comment";
    path = [serverIP stringByAppendingString:path];
    
    NSDictionary *param = @{@"articleid":articleInfo.articleId, @"userid":userInfo.userId, @"commenttime":commiteDate, @"stuname":userInfo.name, @"content":content};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    [manager POST:path parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"提交评论成功");
        callback(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"登陆失败, %@", [error localizedDescription]);
        callback(nil);
    }];
}
@end
