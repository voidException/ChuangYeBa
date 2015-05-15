//
//  FindPasswordTableViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/13.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "FindPasswordTableViewController.h"
#import "LoginNetworkUtils.h"
#import <MBProgressHUD.h>

@interface FindPasswordTableViewController ()

@property (strong, nonatomic) MBProgressHUD *HUD;

@end

@implementation FindPasswordTableViewController

@synthesize HUD;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"找回密码";
    self.buttonView.frame = CGRectMake(0, 0, self.view.frame.size.width, 144);
    
    self.tableView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickOnBackground)];
    [self.tableView addGestureRecognizer:tapGesture];
    
    // 初始化label的段落设置
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.introductionLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4.0];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.introductionLabel.text.length)];
    self.introductionLabel.attributedText = attributedString;
    
    // 初始化HUD
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    //HUD.labelText = @"Loading";
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickOnButton:(id)sender {
    [HUD show:YES];
    [LoginNetworkUtils requestFindPasswordByEmail:self.email.text andCallback:^(id obj) {
        if (obj) {
            [HUD hide:YES];
            NSDictionary *dic = obj;
            NSNumber *error = [dic objectForKey:@"error"];
            if ([error isEqual:@1]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"邮件已经发送至您的邮箱，请您查收！点击确定返回登陆页面。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
            } else {
                NSString *errorMessage = [dic objectForKey:@"errorMessage"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:errorMessage delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                [alert show];
            }
        } else {
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.animationType = MBProgressHUDAnimationZoomIn;
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"errormark"]];
            HUD.labelText = @"网络出错了>_<";
            [HUD show:YES];
            [HUD hide:YES afterDelay:1.0];
        }
    }];
}

- (void)clickOnBackground {
    if (self.email.isFirstResponder) {
        [self.email resignFirstResponder];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

#pragma mark - AlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
