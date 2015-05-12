//
//  AddClassTableViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/21.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "AddClassTableViewController.h"

@interface AddClassTableViewController ()

@end

@implementation AddClassTableViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.buttonView.frame = CGRectMake(0, 0, self.view.frame.size.width, 250);
    
    self.classNoTextField.delegate = self;
    
    if (self.classNoTextField.text.length) {
        self.findClassButton.enabled = YES;
    } else {
        self.findClassButton.enabled = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationItem.hidesBackButton = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Private Method
- (void)sendingDataToServer {
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    NSNumber *classNo = [fmt numberFromString:self.classNoTextField.text];
    [ClassNetworkUtils requestClassInfoByClassNo:classNo andCallback:^(id obj) {
        [self.hud hide:YES];
        self.tableView.userInteractionEnabled = YES;
        if (obj) {
            NSDictionary *dic = obj;
            NSNumber *error = [dic objectForKey:@"error"];
            NSString *errorMessage = [dic objectForKey:@"errorMessage"];
            if ([error integerValue] == 1) {
                if (!self.classInfo) {
                    self.classInfo = [[ClassInfo alloc] init];
                }
                self.classInfo = [ClassJsonParser parseClassInfo:[dic objectForKey:@"oneClass"]];
                self.classInfo.teacherName = [dic objectForKey:@"teacherName"];
                
                
                [self performSegueWithIdentifier:@"ShowAddClassConfirm" sender:self];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:errorMessage delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                [alert show];
            }

        }
    }];
}

#pragma mark - Action
- (IBAction)clickOnAddClassButton:(id)sender {
    self.hud = [MBProgressHUD showHUDAddedTo:self.buttonView animated:YES];
    self.tableView.userInteractionEnabled = NO;
    self.hud.removeFromSuperViewOnHide = YES;
    [self sendingDataToServer];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"请输入您要添加的班级号:";
}

#pragma mark - Text Field Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length > 0) {
        self.findClassButton.enabled = YES;
    } else {
        self.findClassButton.enabled = NO;
    }
    return YES;
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id destinationVC = [segue destinationViewController];
    [destinationVC setValue:self.classInfo forKey:@"classInfo"];
}



@end
