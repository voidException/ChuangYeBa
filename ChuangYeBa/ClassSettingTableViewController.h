//
//  ClassSettingTableViewController.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/11.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassNetworkUtils.h"
#import "ClassInfoCell.h"
#import "ClassInfo.h"
#import "UserInfo.h"
#import "BorderRadiusButton.h"

@interface ClassSettingTableViewController : UITableViewController <UIActionSheetDelegate>

@property (strong, nonatomic) ClassInfo *classInfo;
@property (strong, nonatomic) UserInfo *userInfo;
@property (strong, nonatomic) BorderRadiusButton *footerButton;

- (void)clickOnFooterButton:(id)sender;

@end
