//
//  AddClassTableViewController.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/21.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassNetworkUtils.h"
#import "ClassJsonParser.h"
#import <MBProgressHUD.h>
#import "UserInfo.h"
#import "ClassInfo.h"

@interface AddClassTableViewController : UITableViewController

@property (strong, nonatomic) MBProgressHUD *hud;
//@property (strong, nonatomic) UserInfo *userInfo;
@property (weak, nonatomic) IBOutlet UITextField *classNoTextField;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (strong, nonatomic) ClassInfo *classInfo;
@property (weak, nonatomic) IBOutlet UIButton *findClassButton;

- (IBAction)clickOnAddClassButton:(id)sender;


@end
