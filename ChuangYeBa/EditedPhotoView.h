//
//  EditedPhotoView.h
//  ChuangYeBa
//
//  Created by Developer on 15/5/7.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleImageView.h"

@class EditedPhotoView;
@protocol EditedPhotoViewDelegate <NSObject>

- (void)clickOnPhoto:(EditedPhotoView *)editedPhotoView;

@end

@interface EditedPhotoView : UIView
@property (weak, nonatomic) IBOutlet CircleImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImage;



@property (copy, nonatomic) NSString *sex;

@property (weak, nonatomic) id <EditedPhotoViewDelegate> delegate;

@end
