//
//  TestGroup.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/8.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "TestGroup.h"

@implementation TestGroup

- (id)init {
    self = [super init];
    if (self) {
        self.question = @"这是第一道问题，这是第一道问题，需要测试第一道问题的高度。这是第一道问题，需要测试第一道问题的高度。这是第一道问题，需要测试第一道问题的高度。这是第一道问题，需要测试第一道问题的高度。这是第一道问题，需要测试第一道问题的?高度。这是第一道问题，这是第一道问题，需要测试第一道问题的高度。这是第一道问题，需要测试第一道问题的高度。这是第一道问题，需要测试第一道问题的高度。这是第一道问题，需要测试第一道问题的高度。这是第一道问题，需要测试第一道问题的?高度。这是第一道问题，这是第一道问题，需要测试第一道问题的高度。这是第一道问题，需要测试第一道问题的高度。这是第一道问题，需要测试第一道问题的高度。这是第一道问题，需要测试第一道问题的高度。这是第一道问题，需要测试第一道问题的?高度。这是第一道问题，这是第一道问题，需要测试第一道问题的高度。这是第一道问题，需要测试第一道问题的高度。这是第一道问题，需要测试第一道问题的高度。这是第一道问题，需要测试第一道问题的高度。这是第一道问题，需要测试第一道问题的?高度。这是第一道问题，这是第一道问题，需要测试第一道问题的高度。这是第一道问题，需要测试第一道问题的高度。这是第一道问题，需要测试第一道问题的高度。这是第一道问题，需要测试第一道问题的高度。这是第一道问题，需要测试第一道问题的?高度。";
        
    }
    return self;
}

- (float)getHeightOfTestGroup {
    // 计算问题文本的高度
    CGRect frame = [self.question boundingRectWithSize:CGSizeMake(screenWidth, 999) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
    // 加上文本高度
    float height = frame.size.height;
    // 文本高度应该加上一点点边？？
    return height + 24;
}

@end
