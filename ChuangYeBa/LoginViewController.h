//
//  LoginViewController.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/2.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
#import "NetworkUtils.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (strong, nonatomic) UserInfo *userInfo;

- (IBAction)clickOnLoginButton:(id)sender;

- (IBAction)clickOnRegisterButton:(id)sender;

- (IBAction)didEndOnExit:(id)sender;

- (IBAction)backgroundTap:(id)sender;

@end
