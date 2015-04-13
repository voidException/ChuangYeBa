//
//  ClassSettingTableViewController.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/11.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassViewController.h"

@interface ClassSettingTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIButton *exitClassButton;
@property (weak, nonatomic) IBOutlet UIView *classInfoView;

- (IBAction)clickOnExitClassButton:(id)sender;

@end
