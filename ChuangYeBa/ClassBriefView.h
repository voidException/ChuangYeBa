//
//  ClassBriefView.h
//  ChuangYeBa
//
//  Created by Developer on 15/5/19.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClassInfo;

@class ClassBriefView;
@protocol ClassBriefViewDelegate <NSObject>

- (void)clickOnShowGradeButton:(ClassBriefView *)classBriefView;

@end

@interface ClassBriefView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *classNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *classNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *schoolLabel;
@property (strong, nonatomic) ClassInfo *classInfo;
@property (weak, nonatomic) id <ClassBriefViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *showGradeButton;
- (IBAction)clickOnShowGradeButton:(id)sender;

@end
