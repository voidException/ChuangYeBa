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
@property (weak, nonatomic) IBOutlet UITextField *classNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *maxStudentTextField;
@property (weak, nonatomic) IBOutlet UITextField *schoolNameTextField;
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
    self.schoolNameTextField.text = _userInfo.universityName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method
- (BOOL)isInfoLegal {
    if (_classNameTextField.text.length == 0) {
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
        [ClassNetworkUtils submitToCreateClassWithClassName:_classNameTextField.text universityName:_schoolNameTextField.text studentNum:studentNum teacherId:_userInfo.userId andCallback:^(id obj) {
            NSDictionary *dic = obj;
            NSNumber *error = [obj objectForKey:@"error"];
            if ([error isEqual:@1]) {
                [ClassNetworkUtils requestClassInfoByClassNo:[dic objectForKey:@"number"] andCallback:^(id obj) {
                    ClassInfo *ci = [ClassJsonParser parseClassInfo:[obj objectForKey:@"oneClass"]];
                    NSDictionary *aClass = @{@"classInfo":ci};
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserCreateClass" object:self userInfo:aClass];
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
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
    return 3;
}


@end
