//
//  QuestionCell.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/8.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestGroup.h"
#import "Quiz.h"

#define screenWidth [UIScreen mainScreen].bounds.size.width

@interface QuestionCell : UITableViewCell

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic) float heightOfTextView;

// @property (nonatomic, strong) TestGroup *testGroup;

@end
