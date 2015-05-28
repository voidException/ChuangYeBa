//
//  GradeListTableViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/5/27.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "GradeListTableViewController.h"
#import "GradeListCell.h"
#import "ClassNetworkUtils.h"
#import "ClassInfo.h"
#import <SDWebImage/UIImageView+WebCache.h>

static NSString *cellIdentifier = @"Cell";

@interface GradeListTableViewController ()

@property (strong, nonatomic) ClassInfo *classInfo;
@property (strong, nonatomic) NSMutableArray *gradeArray;

@end

@implementation GradeListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initUI];

    self.gradeArray = [[NSMutableArray alloc] init];
    self.classInfo = [ClassInfo loadClassInfoFromLocal];
    [self requestTestGradesFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    self.title = @"成绩单";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GradeListCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
}

- (void)requestTestGradesFromServer {
    [ClassNetworkUtils requestTestGradesByClassId:_classInfo.classId andCallback:^(id obj) {
        if (obj) {
            _gradeArray = [obj objectForKey:@"studentThreeVo"];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    UILabel *photoLabel = [[UILabel alloc] init];
    titleView.backgroundColor = [UIColor colorWithWhite:0.756 alpha:1.000];
    photoLabel.text = @"头像";
    [photoLabel sizeToFit];
    [photoLabel setTextAlignment:NSTextAlignmentCenter];
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"姓名";
    [nameLabel sizeToFit];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    UILabel *noLabel = [[UILabel alloc] init];
    noLabel.text = @"学号";
    [noLabel sizeToFit];
    [noLabel setTextAlignment:NSTextAlignmentCenter];
    UILabel *gradeLabel = [[UILabel alloc] init];
    gradeLabel.text = @"平均成绩";
    [gradeLabel sizeToFit];
    [gradeLabel setTextAlignment:NSTextAlignmentCenter];
    
    [titleView addSubview:photoLabel];
    [titleView addSubview:nameLabel];
    [titleView addSubview:noLabel];
    [titleView addSubview:gradeLabel];
    
    photoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    noLabel.translatesAutoresizingMaskIntoConstraints = NO;
    gradeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(photoLabel, nameLabel, noLabel, gradeLabel);

    NSArray *hConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[photoLabel]-13-[nameLabel]-30-[noLabel]-48-[gradeLabel]-17-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views];
    NSArray *vConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[photoLabel]" options:0 metrics:nil views:views];
    [titleView addConstraints:hConstraint];
    [titleView addConstraints:vConstraint];

    return titleView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 53;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _gradeArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GradeListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSDictionary *dic = _gradeArray[indexPath.row];
    [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"stuPhoto"]] placeholderImage:[UIImage imageNamed: @"photoPlaceholderSmall"]];
    cell.nameLabel.text = [dic objectForKey:@"stuName"];
    cell.noLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"stuNo"]];
    cell.gradeLabel.text = [NSString stringWithFormat:@"%@分",[dic objectForKey:@"stuGrade"]];
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
