//
//  StudyJsonParser.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/27.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArticleInfo.h"
#import "CommentInfo.h"

@interface StudyJsonParser : NSObject

+ (ArticleInfo *)parseArticleList:(NSDictionary *)dic;

+ (ArticleInfo *)parseArticleInfo:(NSDictionary *)dic;

+ (CommentInfo *)parseCommentInfo:(NSDictionary *)dic;

@end
