//
//  RegisterViewController.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/2.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
#import "NetworkUtils.h"

@interface RegisterViewController : UIViewController <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirm;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *userID;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *haveIDButton;

- (IBAction)clickOnRegisterButton:(id)sender;

- (IBAction)clickOnHaveIDButton:(id)sender;

- (IBAction)didEndOnExit:(id)sender;

- (IBAction)backgroundTap:(id)sender;


@end
