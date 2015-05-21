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

@property (strong, nonatomic) NSMutableDictionary *studentDic;

@end

@implementation ClassSettingTableViewController
@synthesize classInfo;
@synthesize userInfo;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    // 初始化数组
    self.studentDic = [[NSMutableDictionary alloc] init];
    
    [self loadClassInfoFormLocal];
    [self requestClassInfoFormServer];
    
#ifdef TEACHER_VERSION
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestClassInfoFormServer) name:@"UpdateClassInfo" object:nil];
#endif
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
    
    
#ifdef TEACHER_VERSION
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    self.footerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 14, 45)];
    self.footerButton.center = footerView.center;
    [self.footerButton setBackgroundImage:[UIImage imageNamed:@"loginButtonBG"] forState:UIControlStateNormal];
    [self.footerButton setTintColor:[UIColor whiteColor]];
    [self.footerButton setTitle:@"编辑班级信息" forState:UIControlStateNormal];
    [footerView addSubview:self.footerButton];
    [self.footerButton addTarget:self action:@selector(clickOnFooterButton:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = footerView;
#endif
}

- (void)loadClassInfoFormLocal {
    self.classInfo = [[ClassInfo alloc] init];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *udObject = [ud objectForKey:@"classInfo"];
    self.classInfo = [NSKeyedUnarchiver unarchiveObjectWithData:udObject];
    userInfo = [UserInfo loadUserInfoFromLocal];
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
                [self.studentDic setObject:aUser forKey:aUser.userId];
            }
            [self.tableView reloadData];
        }
    }];
}

#ifdef STUDENT_VERSION
- (void)submitQuitClassToServer {
    [ClassNetworkUtils submitQuitClassWithUserId:userInfo.userId andClassId:classInfo.classId andCallback:^(id obj) {
        NSLog(@"%@", obj);
        // 修改UserDeaults中的isUserAddedClass的值，修改为NO
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        self.userInfo.roomno = @"0";
        [UserInfo saveUserInfoToLocal:self.userInfo];
        [ud removeObjectForKey:@"classInfo"];
        [ud synchronize];
        // 返回上级菜单
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}
#endif

#pragma mark - Action
- (void)clickOnBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickOnExitClassButton:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出班级" otherButtonTitles:nil, nil];
    [actionSheet showInView:self.view];
}

- (void)clickOnFooterButton:(id)sender {
    [self performSegueWithIdentifier:@"ShowClassEdited" sender:self];
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
        if ([[self.studentDic allKeys] count]) {
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
        
#ifdef STUDENT_VERSION
        classInfoCell.teacherNameLabel.text = classInfo.teacher.name;
#elif TEACHER_VERSION
        classInfoCell.teacherNameLabel.text = userInfo.name;
#endif
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
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu人",(unsigned long)[[self.studentDic allKeys] count]];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        return cell;
    } else return nil;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowUserList"]) {
        id destinationVC= [segue destinationViewController];
        [destinationVC setValue:self.classInfo forKey:@"classInfo"];
        [destinationVC setValue:self.studentDic forKey:@"studentDic"];
    }
}


@end
