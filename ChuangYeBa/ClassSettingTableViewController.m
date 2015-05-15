//
//  ClassSettingTableViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/11.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "ClassSettingTableViewController.h"

static NSString *classInfoCellIdentifier = @"ClassInfoCell";

@interface ClassSettingTableViewController ()



@end

@implementation ClassSettingTableViewController
@synthesize classInfo;
@synthesize userInfo;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initUI];
    
    // 初始化数组
    self.studentArray = [[NSMutableArray alloc] init];
    
    [self loadClassInfoFormLocal];
    [self requestClassInfoFormServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method
- (void)initUI {
    self.title = @"班级设置";
    self.tableView.tableFooterView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 60);
    // 注册XIB小区
    [self.tableView registerNib:[UINib nibWithNibName:@"ClassInfoCell" bundle:nil] forCellReuseIdentifier:classInfoCellIdentifier];
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"lastButtonIcon"] landscapeImagePhone:nil style:UIBarButtonItemStyleDone target:self action:@selector(clickOnBackButton)];
    self.navigationItem.leftBarButtonItem = btn;
    
}

- (void)loadClassInfoFormLocal {
    self.classInfo = [[ClassInfo alloc] init];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *udObject = [ud objectForKey:@"classInfo"];
    self.classInfo = [NSKeyedUnarchiver unarchiveObjectWithData:udObject];
    udObject = [ud objectForKey:@"userInfo"];
    userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:udObject];
}

- (void)saveClassInfoToLocal {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *udObject = [NSKeyedArchiver archivedDataWithRootObject:self.classInfo];
    [ud setObject:udObject forKey:@"classInfo"];
    [ud synchronize];
}


- (void)requestClassInfoFormServer {
    [ClassNetworkUtils requestClassInfoByClassNo:self.classInfo.classNo andCallback:^(id obj) {
        if (obj) {
            NSDictionary *dic = obj;
            self.classInfo = [ClassJsonParser parseClassInfo:[dic objectForKey:@"oneClass"]];
            self.classInfo.teacher = [LoginJsonParser parseUserInfoInLogin:[dic objectForKey:@"teacher"] isTeacher:YES];
            [self saveClassInfoToLocal];
            NSArray *userListArr = [dic objectForKey:@"studentTwoVo"];
            for (NSDictionary *userInfoDic in userListArr) {
                UserInfo *aUser = [ClassJsonParser parseUserInfo:userInfoDic];
                [self.studentArray addObject:aUser];
            }
            [self.tableView reloadData];
        }
    }];
}

- (void)submitQuitClassToServer {
    [ClassNetworkUtils submitQuitClassWithUserId:userInfo.userId andClassId:classInfo.classId andCallback:^(id obj) {
        NSLog(@"%@", obj);
        // 修改UserDeaults中的isUserAddedClass的值，修改为NO
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        self.userInfo.hasAddedClass = @"0";
        [self.userInfo saveUserInfoToLocal];
        [ud removeObjectForKey:@"classInfo"];
        [ud synchronize];
        // 返回上级菜单
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

#pragma mark - Action
- (void)clickOnBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickOnExitClassButton:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出班级" otherButtonTitles:nil, nil];
    [actionSheet showInView:self.view];
}

#pragma mark - Tbale view delegaet
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 176;
    } else {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return 22;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return 1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([indexPath isEqual:[NSIndexPath indexPathForRow:0 inSection:1]]) {
        self.navigationController.hidesBottomBarWhenPushed = YES;
        [self performSegueWithIdentifier:@"ShowUserDetail" sender:self];
    }
    
    if ([indexPath isEqual:[NSIndexPath indexPathForRow:0 inSection:2]]) {
        if (self.studentArray.count) {
            [self performSegueWithIdentifier:@"ShowUserList" sender:self];
            
            // 设置返回按钮
            UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
            self.navigationItem.backBarButtonItem = btn;
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndentifier = @"Cell";
    if (indexPath.section == 0) {
        ClassInfoCell *classInfoCell = [tableView dequeueReusableCellWithIdentifier:classInfoCellIdentifier];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        NSString *classNoString = [formatter stringFromNumber:classInfo.classNo];
        classInfoCell.classNoLabel.text = classNoString;
        classInfoCell.classNameLabel.text = classInfo.classroomName;
        classInfoCell.teacherNameLabel.text = classInfo.teacher.name;
        classInfoCell.universityNameLabel.text = classInfo.universityName;
        return classInfoCell;
    } else if ([indexPath isEqual:[NSIndexPath indexPathForRow:0 inSection:1]]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
        }
        cell.textLabel.text = @"我的信息";
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        return cell;
    } else if ([indexPath isEqual:[NSIndexPath indexPathForRow:0 inSection:2]]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
        }
        cell.textLabel.text = @"班级成员";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu人",(unsigned long)self.studentArray.count];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        return cell;
    } else return nil;
}

#pragma mark - Action Sheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self submitQuitClassToServer];
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowUserList"]) {
        id destinationVC= [segue destinationViewController];
        [destinationVC setValue:self.studentArray forKey:@"studentArray"];
    }
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





@end
