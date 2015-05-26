//
//  StudyJsonParser.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/27.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "StudyJsonParser.h"

@implementation StudyJsonParser

+ (ArticleInfo *)parseArticleList:(NSDictionary *)dic {
    ArticleInfo *articleInfo = [[ArticleInfo alloc] init];
    articleInfo.articleId = [dic objectForKey:@"articleid"];
    articleInfo.title = [dic objectForKey:@"title"];
    articleInfo.viceTitle = [dic objectForKey:@"vicetitle"];
    articleInfo.miniPhotoURL = [dic objectForKey:@"miniphotourl"];
    articleInfo.comments = [dic objectForKey:@"comments"];
    articleInfo.likes = [dic objectForKey:@"love"];
    articleInfo.publishDate = [dic objectForKey:@"publishtime"];
    articleInfo.collects = [dic objectForKey:@"collect"];
    return articleInfo;
}

// 解析一篇具体的文章
+ (ArticleInfo *)parseArticleInfo:(NSDictionary *)dic {
    ArticleInfo *articleInfo = [[ArticleInfo alloc] init];
    articleInfo.articleId = [dic objectForKey:@"articleid"];
    articleInfo.articleType = [dic objectForKey:@"articletype"];
    articleInfo.collects = [dic objectForKey:@"collect"];
    articleInfo.comments = [dic objectForKey:@"comments"];
    articleInfo.content = [dic objectForKey:@"content"];
    articleInfo.likes = [dic objectForKey:@"love"];
    articleInfo.miniPhotoURL = [dic objectForKey:@"miniphotourl"];
    NSNumber *stringTime = [dic objectForKey:@"publishtime"];
    NSTimeInterval time = [stringTime doubleValue]/1000;
    articleInfo.publishDate = [NSDate dateWithTimeIntervalSince1970:time];
    articleInfo.realURL = [dic objectForKey:@"realurl"];
    articleInfo.title = [dic objectForKey:@"title"];
    articleInfo.viceTitle = [dic objectForKey:@"vicetitle"];
    
    return articleInfo;
}

// 解析一条评论
+ (CommentInfo *)parseCommentInfo:(NSDictionary *)dic {
    CommentInfo *commentInfo = [[CommentInfo alloc] init];
    
    NSDictionary *commentDic = [dic objectForKey:@"comments"];
    commentInfo.commentId = [commentDic objectForKey:@"commentid"];
    commentInfo.content = [commentDic objectForKey:@"content"];
    commentInfo.userName = [commentDic objectForKey:@"username"];
    NSNumber *fixUserId = [commentDic objectForKey:@"userid"];
    NSInteger interger = [fixUserId integerValue]/10;
    commentInfo.userId = [NSNumber numberWithInteger:interger];
    
    NSString *stringTime = [dic objectForKey:@"timeString"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    commentInfo.commentTime = [dateFormatter dateFromString:stringTime];
    commentInfo.userPhotoPath = [dic objectForKey:@"userPhotoPath"];
    return commentInfo;
}

@end
