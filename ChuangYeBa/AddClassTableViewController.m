//
//  AddClassTableViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/21.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "AddClassTableViewController.h"
#import "LoginJsonParser.h"

@interface AddClassTableViewController ()

@property (strong, nonatomic) MBProgressHUD *hud;
@property (weak, nonatomic) IBOutlet UITextField *classNoTextField;
@property (strong, nonatomic) ClassInfo *classInfo;
@property (strong, nonatomic) BorderRadiusButton *findClassButton;

@end

@implementation AddClassTableViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];

    float buttonMargin = 13.0;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 75)];
    self.findClassButton = [[BorderRadiusButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - buttonMargin * 2, 0)];
    self.findClassButton.center = footerView.center;
    [self.findClassButton setTitle:@"加入班级" forState:UIControlStateNormal];
    [footerView addSubview:self.findClassButton];
    [self.findClassButton addTarget:self action:@selector(clickOnAddClassButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.findClassButton setTitleColor:[UIColor colorWithWhite:1.f alpha:.5f] forState:UIControlStateDisabled];
    self.tableView.tableFooterView = footerView;
    
    if (self.classNoTextField.text.length) {
        self.findClassButton.enabled = YES;
    } else {
        self.findClassButton.enabled = NO;
    }
    
    // 注册textfield值变化的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:_classNoTextField];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOnBackground)];
    self.tableView.userInteractionEnabled = YES;
    [self.tableView addGestureRecognizer:tapGesture];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationItem.hidesBackButton = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
                self.classInfo.teacher = [LoginJsonParser parseUserInfoInLogin:[dic objectForKey:@"teacher"] isTeacher:YES];
                
                
                
                [self performSegueWithIdentifier:@"ShowAddClassConfirm" sender:self];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:errorMessage delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                [alert show];
            }

        }
    }];
}

#pragma mark - Action
- (void)clickOnAddClassButton:(id)sender {
    self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    self.tableView.userInteractionEnabled = NO;
    self.hud.removeFromSuperViewOnHide = YES;
    [self sendingDataToServer];
}


- (void)textFieldChanged:(id)sender
{
    if (_classNoTextField.text.length == 0) {
        self.findClassButton.enabled = NO;
    } else {
        self.findClassButton.enabled = YES;
    }
}

- (void)clickOnBackground {
    if ([self.classNoTextField isFirstResponder]) {
        [self.classNoTextField resignFirstResponder];
    }
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] init];
    label.text = @"  请输入您要添加的班级号：";
    //label.backgroundColor = [UIColor greenColor];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:15];
    [label sizeToFit];
    return label;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id destinationVC = [segue destinationViewController];
    [destinationVC setValue:self.classInfo forKey:@"classInfo"];
}


@end
