//
//  CreateClassTableViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/5/16.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "CreateClassTableViewController.h"
#import "ClassNetworkUtils.h"
#import "UserInfo.h"

@interface CreateClassTableViewController ()
@property (strong, nonatomic) UserInfo *userInfo;
@property (weak, nonatomic) IBOutlet UITextField *classNoTextField;
@property (weak, nonatomic) IBOutlet UITextField *maxStudentTextField;
@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (weak, nonatomic) IBOutlet UIView *buttonView;

- (IBAction)clickOnCreateButton:(id)sender;


@end

@implementation CreateClassTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"创建班级";
    self.buttonView.frame = CGRectMake(0, 0, self.view.frame.size.width, 80);
    self.tableView.tableFooterView = self.buttonView;
    [self.createButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateDisabled];
    
    self.userInfo = [UserInfo loadUserInfoFromLocal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method
- (BOOL)isInfoLegal {
    if (_classNoTextField.text.length == 0) {
        return NO;
    } else if (_maxStudentTextField.text.length == 0) {
        return NO;
    }
    return YES;
}

#pragma mark - Action
- (IBAction)clickOnCreateButton:(id)sender {
    if ([self isInfoLegal]) {
        NSNumberFormatter *numberFormater = [[NSNumberFormatter alloc] init];
        NSNumber *studentNum = [numberFormater numberFromString:_maxStudentTextField.text];
        self.userInfo.universityName = @"北京大学";
        [ClassNetworkUtils submitToCreateClassWithClassName:_classNoTextField.text universityName:_userInfo.universityName studentNum:studentNum teacherId:_userInfo.userId andCallback:^(id obj) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请完成信息填写" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


@end
