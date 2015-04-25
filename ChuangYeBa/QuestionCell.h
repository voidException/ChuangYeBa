//
//  NewQuestionCell.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/11.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>

#define screenWidth [UIScreen mainScreen].bounds.size.width

@interface QuestionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic) float heightOfTextView;

@end
