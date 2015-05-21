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
#import <MBProgressHUD.h>

static NSString *editedInfoCellIdentifier = @"EditedInfoCell";

@interface ClassEditedTableViewController () <MBProgressHUDDelegate>

@property (strong, nonatomic) ClassInfo *classInfo;
@property (strong, nonatomic) UIButton *footerButton;
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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EditedInfoCell" bundle:nil] forCellReuseIdentifier:editedInfoCellIdentifier];
    
    self.tableView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOnBackground:)];
    [self.tableView addGestureRecognizer:tapGesture];
    
    
    // 初始化headerView
    float margin = 8.0;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, margin, self.view.frame.size.width - 2 * margin, 40)];
    [headerView addSubview:headerLabel];
    headerLabel.text = @"请直接点击输入框修改班级信息";
    
    // 初始化footerView
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    self.footerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 14, 45)];
    self.footerButton.center = footerView.center;
    [self.footerButton setBackgroundImage:[UIImage imageNamed:@"loginButtonBG"] forState:UIControlStateNormal];
    [self.footerButton setTintColor:[UIColor whiteColor]];
    [self.footerButton setTitle:@"保存修改" forState:UIControlStateNormal];
    [footerView addSubview:self.footerButton];
    [self.footerButton addTarget:self action:@selector(clickOnFooterButton:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = footerView;
    
}

#pragma mark - Action
- (void)clickOnFooterButton:(id)sender {
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"正在提交";
    HUD.minSize = CGSizeMake(135.f, 135.f);
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
                
                HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark"]];
                // Set custom view mode
                HUD.mode = MBProgressHUDModeCustomView;
                HUD.animationType = MBProgressHUDAnimationZoomIn;
                HUD.labelText = @"修改成功";
                //[HUD show:YES];
                [HUD hide:YES afterDelay:1.0];
            }
        } else {
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"errormark"]];
            // Set custom view mode
            HUD.mode = MBProgressHUDModeCustomView;
            //HUD.delegate = self;
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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
