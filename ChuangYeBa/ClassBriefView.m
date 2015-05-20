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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
