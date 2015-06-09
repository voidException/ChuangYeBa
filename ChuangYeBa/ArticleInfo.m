//
//  ArticleInfo.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/16.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "ArticleInfo.h"
#import <math.h>

@implementation ArticleInfo

@synthesize articleId;
@synthesize title;
@synthesize viceTitle;
@synthesize miniPhotoURL;
@synthesize realURL;
@synthesize articleType;
@synthesize comments;
@synthesize likes;
@synthesize collects;
@synthesize publishDate;
@synthesize content;

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self =[super init]) {
        articleId = [aDecoder decodeObjectForKey:@"articleId"];
        title = [aDecoder decodeObjectForKey:@"title"];
        viceTitle = [aDecoder decodeObjectForKey:@"viceTitle"];
        miniPhotoURL = [aDecoder decodeObjectForKey:@"miniPhotoURL"];
        realURL = [aDecoder decodeObjectForKey:@"realURL"];
        articleType = [aDecoder decodeObjectForKey:@"articleType"];
        comments = [aDecoder decodeObjectForKey:@"comments"];
        likes = [aDecoder decodeObjectForKey:@"likes"];
        collects = [aDecoder decodeObjectForKey:@"collects"];
        content = [aDecoder decodeObjectForKey:@"content"];
        publishDate = [aDecoder decodeObjectForKey:@"publishDate"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:articleId forKey:@"articleId"];
    [aCoder encodeObject:title forKey:@"title"];
    [aCoder encodeObject:viceTitle forKey:@"viceTitle"];
    [aCoder encodeObject:miniPhotoURL forKey:@"miniPhotoURL"];
    [aCoder encodeObject:realURL forKey:@"realURL"];
    [aCoder encodeObject:articleType forKey:@"articleType"];
    [aCoder encodeObject:comments forKey:@"comments"];
    [aCoder encodeObject:likes forKey:@"likes"];
    [aCoder encodeObject:collects forKey:@"collects"];
    [aCoder encodeObject:content forKey:@"content"];
    [aCoder encodeObject:publishDate forKey:@"publishDate"];
}


- (NSInteger)getHeightOfArticleString:(NSString *)string lineSpacing:(NSUInteger)lineSpacing fontOfSize:(NSUInteger)fontOfSize widthOffset:(float)widthOffset {
    // 计算问题文本的高度
    // TODO 应该加上添加margin的输入参数
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontOfSize], NSParagraphStyleAttributeName:paragraphStyle};
    
    CGRect frame = [string boundingRectWithSize:CGSizeMake(screenWidth - widthOffset, 9999) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil];
    // 加上文本高度
    float height = frame.size.height;
    // 文本高度应该加上一点点边？？
    return (NSInteger)height + 24;
}

@end
