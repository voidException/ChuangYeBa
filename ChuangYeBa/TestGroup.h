//
//  TestGroup.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/8.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//



#import <Foundation/Foundation.h>

// 测试题组类，对应itemtest表
@interface TestGroup : NSObject

// 题组的标题
@property (nonatomic, copy) NSString *itemTitle;
// 题组的简单描述
@property (nonatomic, copy) NSString *discription;
// itemPhoto的URL
@property (nonatomic, copy) NSString *itemPhoto;
// bool量，该题的状态。
@property (nonatomic, copy) NSString *activity;


@end
