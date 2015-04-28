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
    articleInfo.publishDate = [dic objectForKey:@"publishtime"];
    articleInfo.realURL = [dic objectForKey:@"realurl"];
    articleInfo.title = [dic objectForKey:@"title"];
    articleInfo.viceTitle = [dic objectForKey:@"vicetitle"];
    
    return articleInfo;
}

// 加息一条评论
+ (CommentInfo *)parseCommentInfo:(NSDictionary *)dic {
    CommentInfo *commentInfo = [[CommentInfo alloc] init];
    commentInfo.commentId = [dic objectForKey:@"commentid"];
    commentInfo.content = [dic objectForKey:@"content"];
    commentInfo.userName = [dic objectForKey:@"username"];
    commentInfo.userId = [dic objectForKey:@"userid"];
    commentInfo.commentTime = [dic objectForKey:@"commenttime"];
    return commentInfo;
}

@end
