//
//  BorderRadiusButton.h
//  ChuangYeBa
//
//  Created by Developer on 15/5/25.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

typedef enum {
    ButtonStylePure = 1,
    ButtonStyleBorder
}ButtonStyle;

#import <UIKit/UIKit.h>

@interface BorderRadiusButton : UIButton

@property (strong, nonatomic) UIColor *buttonColor;
@property (nonatomic) ButtonStyle style;

@end
