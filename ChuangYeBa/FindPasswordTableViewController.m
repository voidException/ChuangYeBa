//
//  FindPasswordTableViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/13.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "FindPasswordTableViewController.h"
#import "LoginNetworkUtils.h"

@interface FindPasswordTableViewController ()

@end

@implementation FindPasswordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"找回密码";
    self.buttonView.frame = CGRectMake(0, 0, self.view.frame.size.width, 144);
    
    self.tableView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickOnBackground)];
    [self.tableView addGestureRecognizer:tapGesture];
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
    
    [LoginNetworkUtils requestFindPasswordByEmail:self.email.text andCallback:^(id obj) {
        if (obj) {
            NSDictionary *dic = obj;
            //NSNumber *error = [dic objectForKey:@"error"];
            NSString *errorMessage = [dic objectForKey:@"errorMessage"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:errorMessage delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alert show];
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


@end
