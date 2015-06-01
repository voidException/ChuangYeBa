//
//  EditedPhotoView.m
//  ChuangYeBa
//
//  Created by Developer on 15/5/7.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "EditedPhotoView.h"

@implementation EditedPhotoView

- (void)awakeFromNib {
    
#ifdef TEACHER_VERSION
    self.sexImage.hidden = YES;
#endif
    self.nameLabel.shadowOffset = CGSizeMake(0.4, 0.4);
    self.nameLabel.shadowColor = [UIColor colorWithWhite:0.341 alpha:1.000];
    self.backgroundColor = [UIColor clearColor];
    self.photoImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOnPhoto)];
    [self.photoImage addGestureRecognizer:tapGesture];

}
- (void)clickOnPhoto {
    [self.delegate clickOnPhoto:self];
}

- (void)setSex:(NSString *)sex {
    if ([sex isEqualToString:@"男"]) {
        [self.sexImage setImage:[UIImage imageNamed:@"male"]];
    } else {
        [self.sexImage setImage:[UIImage imageNamed:@"female"]];
    }
}




// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

/*
- (void)drawRect:(CGRect)rect {
    UIImage *viewBG = [UIImage imageNamed:@"editedPhotoViewBG"];
    
    [viewBG drawAsPatternInRect:rect];
}
*/

@end
