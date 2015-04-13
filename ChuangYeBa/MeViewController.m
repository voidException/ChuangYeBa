//
//  MeViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/4.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "MeViewController.h"

@interface MeViewController ()

@property (strong, nonatomic) NSArray *settingArray;

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.title = @"我";
    
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"appSetting" ofType:@"plist"];
    self.settingArray = [[NSArray array]initWithContentsOfFile:plistPath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickOnLogoutButton:(id)sender {
    
    NSLog(@"退出账号");
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:@"userInfo"];
    NSNumber *isUserDidLogin = [[NSNumber alloc]initWithBool:NO];
    [ud setObject:isUserDidLogin forKey:@"isUserDidLogin"];
    [self performSegueWithIdentifier:@"ShowLoginFromLogout" sender:self];
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 150;
    } else {
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
    if (indexPath.section == 0) {
        [self performSegueWithIdentifier:@"ShowUserEdited" sender:self];
    }
     */
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
    static NSString *userInfoCellIndentifier = @"UserInfoCell";
    static NSString *cellIndentifier = @"CellIndentifier";
    if (indexPath.section == 0) {
        UserInfoCell *userInfoCell = [tableView dequeueReusableCellWithIdentifier:userInfoCellIndentifier];
        userInfoCell.photoImage.image = [UIImage imageNamed:@"USA.png"];
        userInfoCell.name.text = @"小明";
        userInfoCell.schoolName.text = @"北京大学";
        return userInfoCell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        }
        NSInteger row = [indexPath row];
        NSDictionary *dic = [self.settingArray objectAtIndex:row];
        cell.textLabel.text = [dic objectForKey:@"title"];
        return cell;
    }
}

@end
