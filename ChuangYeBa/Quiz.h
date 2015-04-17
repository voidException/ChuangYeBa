//
//  Quiz.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/9.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define screenWidth [UIScreen mainScreen].bounds.size.width

@interface Quiz : NSObject

// 问题题干
@property (nonatomic, copy) NSString *question;
// 选项数组（应该是4个NSString对象）
@property (nonatomic, strong) NSArray *options;
// 正确答案的选项
@property (nonatomic) NSNumber *answerOption;

// 答案解析
@property (nonatomic, copy) NSString *answerExplain;

- (float)getHeightOfQuizString:(NSString *)string;

@end
