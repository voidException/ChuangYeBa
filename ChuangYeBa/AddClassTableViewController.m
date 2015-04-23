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
    
    // 只能通过这种办法来去掉系统自带的
    UIBarButtonItem *temp = [[UIBarButtonItem alloc] init];
    temp.title = @"";
    self.navigationItem.leftBarButtonItem = temp;
    
    self.title = @"查找班级";
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationItem.hidesBackButton = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Private Method
- (void)sendingDataToServer {
    [ClassNetworkUtils requestClassInfoByClassNo:self.classNoTextField.text andCallback:^(id obj) {
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

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id destinationVC = [segue destinationViewController];
    [destinationVC setValue:self.classInfo forKey:@"classInfo"];
}



@end
