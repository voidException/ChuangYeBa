//
//  ClassSettingViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/3.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "ClassSettingViewController.h"

@interface ClassSettingViewController ()

@property (strong, nonatomic) NSArray *studentArray;

@end

@implementation ClassSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.title = @"班级设置";
    
    NSBundle *bunble = [NSBundle mainBundle];
    NSString *plistPath = [bunble pathForResource:@"studentAndNumber" ofType:@"plist"];
    self.studentArray = [[NSArray alloc]initWithContentsOfFile:plistPath];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 150;
            break;
        case 1:
            return 44;
            break;
        default:
            return 44;
            break;
    }
}



#pragma mark - UITableViewDateSocrce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return [self.studentArray count];
            break;
        default:
            return 1;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *classInfoCellIndentifier = @"ClassInfoCell";
    static NSString *studentInfoCellIndentifier = @"StudentInfoCell";
    
    if (indexPath.section == 0) {
        ClassInfoCell *classInfoCell = [tableView dequeueReusableCellWithIdentifier:classInfoCellIndentifier];
        classInfoCell.delegate = self;
        
        classInfoCell.photoImage.image = [UIImage imageNamed:@"USA.png"];
        classInfoCell.name.text = @"小明";
        classInfoCell.schoolName.text = @"北京大学";
        classInfoCell.numberOfPeopleInClass.hidden = NO;
        [classInfoCell.button setTitle:@"退出班级" forState:UIControlStateNormal];
        return classInfoCell;
    } else {
     
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:studentInfoCellIndentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:studentInfoCellIndentifier];
        }
        NSInteger row = [indexPath row];
        NSDictionary *dic = [self.studentArray objectAtIndex:row];
        cell.textLabel.text = [dic objectForKey:@"name"];
        cell.detailTextLabel.text = [dic objectForKey:@"number"];
        return cell;
    }

}

#pragma mark - ClassInfoCellDelegate
- (void)userClickOnaddAndSettingButton:(ClassInfoCell *)classInfoCell {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *number = [[NSNumber alloc]initWithBool:NO];
    [ud setObject:number forKey:@"isUserAddedClass"];
    [ud synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    NSLog(@"退出班级");
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
