//
//  LoginViewController.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/2.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>
#import "UserInfo.h"
#import "LoginNetworkUtils.h"
#import "LoginJsonParser.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) MBProgressHUD *hud;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;



@property (strong, nonatomic) UserInfo *userInfo;

- (IBAction)clickOnLoginButton:(id)sender;

- (IBAction)clickOnRegisterButton:(id)sender;

- (IBAction)clickOnForgetPasswordButton:(id)sender;

- (IBAction)didEndOnExit:(id)sender;

- (IBAction)backgroundTap:(id)sender;

@end
