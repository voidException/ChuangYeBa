//
//  ClassEditedTableViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/5/21.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "ClassEditedTableViewController.h"
#import "EditedInfoCell.h"
#import "ClassInfo.h"
#import "ClassNetworkUtils.h"
#import "BorderRadiusButton.h"
#import <MBProgressHUD.h>

static NSString *editedInfoCellIdentifier = @"EditedInfoCell";

@interface ClassEditedTableViewController () <MBProgressHUDDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) ClassInfo *classInfo;
@property (strong, nonatomic) BorderRadiusButton *footerButton;
@property (strong, nonatomic) NSArray *detailList;
@property (strong, nonatomic) NSMutableDictionary *textFields;

- (void)clickOnFooterButton:(id)sender;

@end

@implementation ClassEditedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.classInfo = [ClassInfo loadClassInfoFromLocal];
    self.textFields = [[NSMutableDictionary alloc] init];
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private method
- (void)initUI {
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"classDetailList" ofType:@"plist"];
    self.detailList = [[NSArray alloc] initWithContentsOfFile:plistPath];
    
    self.title = @"修改班级信息";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EditedInfoCell" bundle:nil] forCellReuseIdentifier:editedInfoCellIdentifier];
    
    self.tableView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOnBackground:)];
    [self.tableView addGestureRecognizer:tapGesture];
    
    
    // 初始化headerView
    float margin = 8.0;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, 0, self.view.frame.size.width - 2 * margin, 40)];
    headerLabel.textColor = [UIColor grayColor];
        headerLabel.text = @"  请直接点击输入框修改班级信息:";
    headerLabel.font = [UIFont systemFontOfSize:16.0];
    [headerView addSubview:headerLabel];
    self.tableView.tableHeaderView = headerView;
    
    // 初始化footerView
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 75)];
    self.footerButton = [[BorderRadiusButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 14, 45)];
    self.footerButton.center = footerView.center;
    [self.footerButton setTitle:@"保存修改" forState:UIControlStateNormal];
    [footerView addSubview:self.footerButton];
    [self.footerButton addTarget:self action:@selector(clickOnFooterButton:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = footerView;
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickOnCancelButton:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
}

#pragma mark - Action
- (void)clickOnCancelButton:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认要取消修改吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.tag = 0;
    [alert show];
}

- (void)clickOnFooterButton:(id)sender {
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"正在提交";
    [HUD show:YES];
    
    HUD.animationType = MBProgressHUDAnimationZoomIn;
    ClassInfo *copyClassInfo = [self.classInfo copy];
    copyClassInfo.classroomName = [[self.textFields objectForKey:@"classroomName"] text];
    copyClassInfo.universityName = [[self.textFields objectForKey:@"universityName"] text];
    [ClassNetworkUtils submitModifiedClassInfo:copyClassInfo andCallback:^(id obj) {
        if (obj) {
            NSDictionary *dic = obj;
            NSNumber *error = [dic objectForKey:@"error"];
            if ([error isEqualToNumber:@1]) {
                [ClassInfo saveClassInfoToLocal:copyClassInfo];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateClassInfo" object:nil];
                HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark"]];
                HUD.mode = MBProgressHUDModeCustomView;
                HUD.animationType = MBProgressHUDAnimationZoomIn;
                HUD.labelText = @"修改成功";
                [HUD hide:YES afterDelay:1.0];
            }
        } else {
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"errormark"]];
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.labelText = @"网络错误";
            [HUD hide:YES afterDelay:1.0];
        }
    }];
}

- (void)clickOnBackground:(id)sender {
    NSArray *arr = [self.textFields allValues];
    for (int i = 0; i < arr.count; i ++) {
        UITextField *tf = arr[i];
        if ([tf isFirstResponder]) {
            [tf resignFirstResponder];
        }
    }
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    if ([hud.labelText isEqualToString:@"修改成功"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.detailList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EditedInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:editedInfoCellIdentifier];
    NSDictionary *dic = self.detailList[indexPath.row];
    cell.label.text = [dic objectForKey:@"title"];
    cell.textField.placeholder = [dic objectForKey:@"placeholder"];
    if ([[dic objectForKey:@"title"] isEqualToString:@"班级号"]) {
        cell.textField.text = [NSString stringWithFormat:@"%@", _classInfo.classNo];
        cell.textField.textColor = [UIColor blueColor];
        cell.userInteractionEnabled = NO;
    } else if([[dic objectForKey:@"title"] isEqualToString:@"班级名称"]) {
        cell.textField.text = _classInfo.classroomName;
        [self.textFields setObject:cell.textField forKey:@"classroomName"];
    } else if ([[dic objectForKey:@"title"] isEqualToString:@"学校名称"]) {
        cell.textField.text = _classInfo.universityName;
        [self.textFields setObject:cell.textField forKey:@"universityName"];
    }
    return cell;
}

#pragma mark - Alert view delegate 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 0) {
        if (buttonIndex == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
@end
