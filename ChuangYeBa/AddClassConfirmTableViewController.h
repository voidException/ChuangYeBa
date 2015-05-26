//
//  AddClassConfirmTableViewController.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/21.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassInfo.h"
#import "UserInfo.h"
#import "ClassInfoCell.h"
#import "ClassNetworkUtils.h"

@interface AddClassConfirmTableViewController : UITableViewController

@property (strong, nonatomic) ClassInfo *classInfo;
@property (strong, nonatomic) UserInfo *userInfo;
//@property (weak, nonatomic) IBOutlet UIView *buttonView;

@end
