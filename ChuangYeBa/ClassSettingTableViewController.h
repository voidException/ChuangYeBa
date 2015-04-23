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

@interface ClassSettingTableViewController : UITableViewController

@property (strong, nonatomic) ClassInfo *classInfo;
@property (strong, nonatomic) UserInfo *userInfo;
@property (strong, nonatomic) NSArray *studentArray;

- (IBAction)clickOnExitClassButton:(id)sender;

@end
