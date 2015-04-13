//
//  TestGroup.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/8.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define screenWidth [UIScreen mainScreen].bounds.size.width


@interface TestGroup : NSObject

@property (nonatomic) NSInteger *questionID;
@property (nonatomic, copy) NSString *question;
@property (nonatomic, strong) NSArray *options;

- (float)getHeightOfTestGroup;

@end
