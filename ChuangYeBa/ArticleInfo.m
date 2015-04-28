//
//  ArticleInfo.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/16.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "ArticleInfo.h"

@implementation ArticleInfo

- (float)getHeightOfArticleString:(NSString *)string lineSpacing:(NSUInteger)lineSpacing fontOfSize:(NSUInteger)fontOfSize widthOffset:(float)widthOffset {
    // 计算问题文本的高度
    // TODO 应该加上添加margin的输入参数
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontOfSize], NSParagraphStyleAttributeName:paragraphStyle};
    
    CGRect frame = [string boundingRectWithSize:CGSizeMake(screenWidth - widthOffset, 999) options:NSStringDrawingUsesLineFragmentOrigin  attributes:attributes context:nil];
    // 加上文本高度
    float height = frame.size.height;
    // 文本高度应该加上一点点边？？
    return height + 24;
}

@end
