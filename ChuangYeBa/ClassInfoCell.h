//
//  ClassInfoCell.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/21.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClassInfoCell;
@protocol ClassInfoCellDelegate <NSObject>

- (void)clickOnPhoto:(ClassInfoCell *)classInfoCell;

@end

@interface ClassInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *classNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *classNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *universityNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photo;

@property (weak, nonatomic) id <ClassInfoCellDelegate> delegate;

@end
