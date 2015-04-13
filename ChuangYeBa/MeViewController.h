//
//  MeViewController.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/4.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoCell.h"

@interface MeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)clickOnLogoutButton:(id)sender;

@end
