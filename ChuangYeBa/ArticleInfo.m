//
//  ArticleInfo.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/16.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "ArticleInfo.h"

@implementation ArticleInfo

- (float)getHeightOfArticleString:(NSString *)string fontOfSize:(NSUInteger)fontOfSize {
    // 计算问题文本的高度
    // TODO 应该加上添加margin的输入参数
    CGRect frame = [string boundingRectWithSize:CGSizeMake(screenWidth - 16, 999) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fontOfSize]} context:nil];
    // 加上文本高度
    float height = frame.size.height;
    // 文本高度应该加上一点点边？？
    return height + 24;
}


@end
