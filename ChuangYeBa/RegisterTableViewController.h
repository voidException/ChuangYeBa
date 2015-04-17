//
//  RegisterTableViewController.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/13.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginNetworkUtils.h"

@interface RegisterTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirm;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *userNo;
@property (weak, nonatomic) IBOutlet UIView *buttonView;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;

- (IBAction)clickOnRegisterButton:(id)sender;

- (IBAction)didEndOnExit:(id)sender;

- (void)backgroundTap:(id)sender;



@end
