//
//  UserDetailViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/5/8.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "UserDetailViewController.h"
#import "EditedInfoCell.h"
#import "UserInfo.h"
#import "EditedPhotoView.h"

static NSString *editedInfoCellIdentifier = @"EditedInfoCell";

@interface UserDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *detailList;
@property (strong, nonatomic) NSArray *userInfoList;
@property (strong, nonatomic) UserInfo *userInfo;

@end

@implementation UserDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initUI];
    [self loadUserInfoFormLocal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method
- (void)initUI {
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"userDetailList" ofType:@"plist"];
    self.detailList = [[NSArray alloc] initWithContentsOfFile:plistPath];

    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EditedPhotoView" owner:nil options:nil];
    //self.tableView.tableHeaderView = [nib objectAtIndex:0];
    EditedPhotoView *headerView = [nib objectAtIndex:0];
    NSLog(@"%f", CGRectGetHeight(headerView.frame));
    headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 225);
    [headerView drawRect:headerView.frame];
    self.tableView.tableHeaderView = headerView;
    headerView.photoImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOnPhoto)];
    [headerView.photoImage addGestureRecognizer:tapGesture];
                                          
    
    
    UIView *viewtest = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 225)];
    viewtest.backgroundColor = [UIColor greenColor];
    //self.tableView.tableHeaderView = viewtest;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EditedInfoCell" bundle:nil] forCellReuseIdentifier:editedInfoCellIdentifier];
}

- (void)loadUserInfoFormLocal {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *udObject = [ud objectForKey:@"userInfo"];
    self.userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:udObject];
    
#warning 严重！还没有处理当又信息为空的情况
    NSArray *arrSection0 = @[_userInfo.name, _userInfo.email];
    NSArray *arrSection1 = @[_userInfo.userNo, _userInfo.sex, _userInfo.school, _userInfo.department];
    self.userInfoList = @[arrSection0, arrSection1];
    
}
#pragma mark - Action
- (void)clickOnPhoto {
    NSLog(@"点击照片");
}

#pragma mark - TableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"aaaaaa";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

#pragma mark - TableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = _detailList[section];
    return [arr count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_detailList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EditedInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:editedInfoCellIdentifier forIndexPath:indexPath];
    NSArray *arr = _detailList[indexPath.section];
    NSDictionary *dic = arr[indexPath.row];
    NSArray *arrUser = _userInfoList[indexPath.section];
    cell.label.text = [dic objectForKey:@"title"];

    // 在这里用stringWithFormat是为了防止NSNumber不方便显示的问题
    NSString *str = [NSString stringWithFormat:@"%@", arrUser[indexPath.row]];
    if (str.length) {
        cell.textField.text = str;
    } else {
        cell.textField.placeholder = [dic objectForKey:@"placeholder"];
    }
    
    cell.textField.userInteractionEnabled = NO;
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
