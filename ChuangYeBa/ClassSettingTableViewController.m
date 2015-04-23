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
    
    self.title = @"班级设置";
    
    NSBundle *bunble = [NSBundle mainBundle];
    NSString *plistPath = [bunble pathForResource:@"studentAndNumber" ofType:@"plist"];
    
    
    [self loadClassInfoFormLocal];
    self.studentArray = [[NSArray alloc]initWithContentsOfFile:plistPath];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ClassInfoCell" bundle:nil] forCellReuseIdentifier:classInfoCellIdentifier];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method
- (void)loadClassInfoFormLocal {
    self.classInfo = [[ClassInfo alloc] init];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *udObject = [ud objectForKey:@"classInfo"];
    self.classInfo = [NSKeyedUnarchiver unarchiveObjectWithData:udObject];
    udObject = [ud objectForKey:@"userInfo"];
    userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:udObject];
    
    
}


- (void)requestClassInfoFormServer {
    
}

#pragma mark - Action
- (IBAction)clickOnExitClassButton:(id)sender {
    
    
    [ClassNetworkUtils submitQuitClassWithUserId:userInfo.userId andClassId:classInfo.classId andCallback:^(id obj) {
    
        NSLog(@"%@", obj);
        // 修改UserDeaults中的isUserAddedClass的值，修改为NO
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSNumber *number = [[NSNumber alloc]initWithBool:NO];
        [ud setObject:number forKey:@"isUserAddedClass"];
        [ud removeObjectForKey:@"classInfo"];
        [ud synchronize];
        // 返回上级菜单
        
        [self.navigationController popToRootViewControllerAnimated:YES];

        
        
        

    }];
    
}

#pragma mark - Tbale view delegaet
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 146;
    } else {
        return 44;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return [self.studentArray count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *studentInfoCellIndentifier = @"StudentInfoCell";
    if (indexPath.section == 0) {
        ClassInfoCell *classInfoCell = [tableView dequeueReusableCellWithIdentifier:classInfoCellIdentifier];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        NSString *classNoString = [formatter stringFromNumber:classInfo.classNo];
        classInfoCell.classNoLabel.text = classNoString;
        classInfoCell.classNameLabel.text = classInfo.classroomName;
        classInfoCell.teacherNameLabel.text = classInfo.teacherName;
        classInfoCell.universityNameLabel.text = classInfo.universityName;
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

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did hightlight %ld", (long)indexPath.row);
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did UN hightlight %ld", (long)indexPath.row);
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
