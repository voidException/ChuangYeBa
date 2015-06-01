//
//  BorderRadiusButton.m
//  ChuangYeBa
//
//  Created by Developer on 15/5/25.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "BorderRadiusButton.h"
#import "GlobalDefine.h"

static float const kAspectRatio = 45.0/341;

@implementation BorderRadiusButton

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.layer.cornerRadius = 3.0f;
        [self setButtonColor:[UIColor CYBBlueColor]];
        NSLog(@"%u", self.enabled);
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithWhite:1.f alpha:.9f] forState:UIControlStateHighlighted];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 3.0f;
        [self setButtonColor:[UIColor CYBBlueColor]];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithWhite:1.f alpha:.9f] forState:UIControlStateHighlighted];
        
        CGRect fixFrame = frame;
        
        float height = fixFrame.size.width * kAspectRatio;
        if (height > 45) {
            fixFrame.size.height = 45;
        } else {
            fixFrame.size.height = height;
        }
        self.frame = fixFrame;
    }
    return self;
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    if (!enabled) {
#ifdef STUDENT_VERSION
        [self setButtonColor:[UIColor CYBBlueColor]];
        self.layer.borderColor = [UIColor clearColor].CGColor;
#elif TEACHER_VERSION
        [self setButtonColor:[UIColor whiteColor]];
        self.layer.borderColor = [UIColor grayColor].CGColor;
#endif
    } else {
        [self setButtonColor:[UIColor CYBBlueColor]];
        self.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    switch (state) {
        case UIControlStateNormal:
        {
            NSDictionary *attributes = [[NSDictionary alloc] init];
            if (iPhone4 || iPhone5) {
                attributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16], NSForegroundColorAttributeName:[UIColor whiteColor]};
            } else {
                attributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName:[UIColor whiteColor]};
            }
            NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:title attributes:attributes];
            [self setAttributedTitle:attributedString forState:state];
            
            NSDictionary *disableAttributes = [[NSDictionary alloc] init];
            if (iPhone4 || iPhone5) {
                disableAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16], NSForegroundColorAttributeName:[UIColor colorWithWhite:1.f alpha:.5f]};
            } else {
                disableAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName:[UIColor colorWithWhite:1.f alpha:.5f]};
            }
            NSAttributedString *disableAttributedString = [[NSAttributedString alloc] initWithString:title attributes:disableAttributes];
            [self setAttributedTitle:disableAttributedString forState:UIControlStateDisabled];
            break;
        }
        default:
            break;
    }
    
}

- (void)setButtonColor:(UIColor *)buttonColor {
    if (buttonColor == _buttonColor) {
        return;
    }
    _buttonColor = buttonColor;
    self.backgroundColor = buttonColor;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.backgroundColor = [_buttonColor colorWithAlphaComponent:.8];
    } else {
        self.backgroundColor = _buttonColor;
    }
}

@end
