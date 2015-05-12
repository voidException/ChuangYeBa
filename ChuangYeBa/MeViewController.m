//
//  MeViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/4.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "MeViewController.h"
#import "UserInfo.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ArticleInfoDAO.h"

static NSString *userInfoCellIdentifier = @"UserInfoCell";

@interface MeViewController ()

@property (strong, nonatomic) NSArray *settingArray;
@property (strong, nonatomic) UserInfo *userInfo;

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self loadUserInfoFromLocal];
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"appSetting" ofType:@"plist"];
    self.settingArray = [[NSArray array]initWithContentsOfFile:plistPath];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUserInfoFromLocal) name:@"UpdateUserInfo" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}


#pragma mark - Private Method
- (void)initUI {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.title = @"我";
    [self.tableView registerNib:[UINib nibWithNibName:@"UserInfoCell" bundle:nil] forCellReuseIdentifier:userInfoCellIdentifier];
    
    // 设置导航条
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:44.0/255 green:149.0/255 blue:255.0/255 alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20 weight:0.5], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //float screenWidth = self.view.frame.size.width;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 93)];
    float buttonMargin = 13.0;
    UIButton *exitButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screenWidth - 2 * buttonMargin, 44)];
    exitButton.center = footerView.center;
    [exitButton setBackgroundImage:[UIImage imageNamed:@"exitButtonBG"] forState:UIControlStateNormal];
    [exitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [exitButton setTitle:@"退出当前账号" forState:UIControlStateNormal];
    [exitButton addTarget:self action:@selector(clickOnLogoutButton:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:exitButton];
    self.tableView.tableFooterView = footerView;

}

- (void)loadUserInfoFromLocal {
    self.userInfo = [[UserInfo alloc] init];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *udObject = [ud objectForKey:@"userInfo"];
    self.userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:udObject];
}

- (void)reloadUserInfoFromLocal {
    [self loadUserInfoFromLocal];
    [self.tableView reloadData];
}

#pragma mark - Action
- (void)clickOnLogoutButton:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出当前账号" otherButtonTitles:nil, nil];
    actionSheet.tag = 0;
    [actionSheet showInView:self.view];
}




#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 88;
    } else {
        return 57;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [self performSegueWithIdentifier:@"ShowUserDetail" sender:self];
    } else {
        if (indexPath.row == 0) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"清除缓存" otherButtonTitles:nil, nil];
            actionSheet.tag = 1;
            [actionSheet showInView:self.view];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return [self.settingArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndentifier = @"CellIndentifier";
    if (indexPath.section == 0) {
        UserInfoCell *userInfoCell = [tableView dequeueReusableCellWithIdentifier:userInfoCellIdentifier];
        //[userInfoCell.photoImage sd_setImageWithURL:[NSURL URLWithString:_userInfo.photoPath] placeholderImage:[UIImage imageNamed:@"photoPlaceholderSmall"]];
        [userInfoCell.photoImage sd_setImageWithURL:[NSURL URLWithString:_userInfo.photoPath] placeholderImage:[UIImage imageNamed:@"photoPlaceholderSmall"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                [userInfoCell.photoImage setImage:image];
            }
        }];
        userInfoCell.nameLabel.text = self.userInfo.name;
        userInfoCell.numberLabel.text = [NSString stringWithFormat:@"学号：%@", self.userInfo.userNo];
        return userInfoCell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        }
        NSInteger row = [indexPath row];
        NSDictionary *dic = [self.settingArray objectAtIndex:row];
        cell.textLabel.text = [dic objectForKey:@"title"];
        cell.textLabel.font = [UIFont systemFontOfSize:20 weight:-0.2];
        cell.imageView.image = [UIImage imageNamed:[dic objectForKey:@"imageName"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark - ActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 0) {
        if (buttonIndex == 0) {
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud removeObjectForKey:@"userInfo"];
            NSNumber *isUserDidLogin = [[NSNumber alloc]initWithBool:NO];
            [ud setObject:isUserDidLogin forKey:@"isUserDidLogin"];
            [self performSegueWithIdentifier:@"ShowLoginFromLogout" sender:self];
        }
    } else if (actionSheet.tag == 1) {
        if (buttonIndex == 0) {
            ArticleInfoDAO *dao = [ArticleInfoDAO shareManager];
            [dao clean];
        }
    }
}

@end
