//
//  Quiz.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/9.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "Quiz.h"

@implementation Quiz

// 计算文本高度的方法
- (float)getHeightOfQuizString:(NSString *)string {
    // 计算问题文本的高度
    // TODO 应该加上添加margin的输入参数
    CGRect frame = [string boundingRectWithSize:CGSizeMake(screenWidth - 16, 999) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18]} context:nil];
    // 加上文本高度
    float height = frame.size.height;
    // 文本高度应该加上一点点边？？
    return height + 24;
}



@end
