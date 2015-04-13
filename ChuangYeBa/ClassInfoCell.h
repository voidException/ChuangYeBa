//
//  ClassInfoCell.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/3.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClassInfoCell;

@protocol ClassInfoCellDelegate
- (void) userClickOnaddAndSettingButton: (ClassInfoCell *)classInfoCell;
@end

@interface ClassInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *schoolName;
@property (weak, nonatomic) IBOutlet UILabel *numberOfPeopleInClass;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) id <ClassInfoCellDelegate> delegate;

- (IBAction)clickOnAddAndSettingButton:(id)sender;

@end
