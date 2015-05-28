//
//  ClassBriefView.m
//  ChuangYeBa
//
//  Created by Developer on 15/5/19.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "ClassBriefView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ClassInfo.h"

@implementation ClassBriefView

- (void)awakeFromNib {
    _photoImage.layer.masksToBounds = YES;
    _photoImage.layer.cornerRadius = 5;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _classInfo = [ClassInfo loadClassInfoFromLocal];
    if (_classInfo) {
        [_photoImage sd_setImageWithURL:[NSURL URLWithString:_classInfo.photoPath] placeholderImage:[UIImage imageNamed:@"PKUIcon"]];
        _classNameLabel.text = _classInfo.classroomName;
        _classNoLabel.text = [NSString stringWithFormat:@"%@", _classInfo.classNo];
        _schoolLabel.text = _classInfo.universityName;
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 0.5);//线条颜色
    CGContextSetLineWidth(context, 0.5);
    CGContextMoveToPoint(context, 0, self.showGradeButton.frame.origin.y + 0.5);
    CGContextAddLineToPoint(context, self.frame.size.width, self.showGradeButton.frame.origin.y + 0.5);
    CGContextStrokePath(context);
}


- (IBAction)clickOnShowGradeButton:(id)sender {
    [self.delegate clickOnShowGradeButton:self];
}
@end
