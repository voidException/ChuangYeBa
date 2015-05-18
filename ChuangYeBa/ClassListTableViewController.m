//
//  ClassListTableViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/5/16.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "ClassListTableViewController.h"
#import "NavigationMenuView/SINavigationMenuView.h"
#import "CircleButton.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "UserInfo.h"
#import "ClassNetworkUtils.h"
#import <MBProgressHUD.h>

@interface ClassListTableViewController () <SINavigationMenuDelegate>

// UI相关属性
@property (strong, nonatomic) SINavigationMenuView *menu;
@property (strong, nonatomic) UIButton *settingButton;
@property (strong, nonatomic) UIButton *refreshButton;
@property (strong, nonatomic) CircleButton *leftButton;

// 数据相关
@property (strong, nonatomic) UserInfo *userInfo;
@property (strong, nonatomic) NSMutableArray *classInfos;
@property (strong, nonatomic) ClassInfo *selectedClassInfo;





@end

@implementation ClassListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    self.userInfo = [UserInfo loadUserInfoFromLocal];
    self.classInfos = [[NSMutableArray alloc] init];
    [self initUI];
    if (self.navigationItem) {
        CGRect frame = CGRectMake(0.0, 0.0, 200.0, self.navigationController.navigationBar.bounds.size.height);
        self.menu = [[SINavigationMenuView alloc] initWithFrame:frame title:@"全部班级"];
        [self.menu displayMenuInView:self.tabBarController.view];
        self.menu.items = @[];
        self.menu.delegate = self;
        self.navigationItem.titleView = self.menu;
    }
    [self requestClassInfosFromServer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (!_selectedClassInfo) {
        self.settingButton.enabled = NO;
    }
    [self.settingButton setAlpha:0.0];
    [self.leftButton setAlpha:0.0];
    [self.navigationController.navigationBar addSubview:self.settingButton];
    [self.navigationController.navigationBar addSubview:self.leftButton];
    [UIView animateWithDuration:0.3 animations:^{
        [self.settingButton setAlpha:1.0];
        [self.leftButton setAlpha:1.0];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIView animateWithDuration:0.3 animations:^{
        [self.settingButton setAlpha:0.0];
        [self.leftButton setAlpha:0.0];
        [self.refreshButton setAlpha:0.0];
    } completion:^(BOOL finished) {
        [self.settingButton removeFromSuperview];
        [self.leftButton removeFromSuperview];
        [self.refreshButton removeFromSuperview];
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method
- (void)initUI {
    
    // 初始化导航条的属性
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:44.0/255 green:149.0/255 blue:255.0/255 alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 初始化右导航条设置按钮
    float buttonWidth = 30;
    self.settingButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - buttonWidth - 7, 7, buttonWidth, buttonWidth)];
    [self.settingButton setImage:[[UIImage imageNamed:@"classSettingButtonNormal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.settingButton setImage:[[UIImage imageNamed:@"classSettingButtonSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    [self.settingButton addTarget:self action:@selector(clickOnSettingButton:) forControlEvents:UIControlEventTouchUpInside];
    // 初始化右导航条刷新按钮
    self.refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - buttonWidth - 7, 7, buttonWidth, buttonWidth)];
    [self.refreshButton setImage:[[UIImage imageNamed:@"refreshButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.refreshButton addTarget:self action:@selector(clickOnRefreshButton:) forControlEvents:UIControlEventTouchUpInside];
    
    // 初始化左导航条按钮
    self.leftButton = [[CircleButton alloc] initWithFrame:CGRectMake(7, 7, 30, 30)];
    self.leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.leftButton sd_setImageWithURL:[NSURL URLWithString:_userInfo.photoPath] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.leftButton setCircleImage:image placeholder:[UIImage imageNamed:@"photoPlaceholderSmall"] forState:UIControlStateNormal];
    }];
    [self.leftButton addTarget:self action:@selector(clickOnLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)requestClassInfosFromServer {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
    
    [ClassNetworkUtils requestClassInfosWithTeacherId:_userInfo.userId andCallback:^(id obj) {
        if (obj) {
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.animationType = MBProgressHUDAnimationZoomIn;
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark"]];
            HUD.labelText = @"加载班级成功";
            [HUD hide:YES afterDelay:1.0];
            NSDictionary *dic = obj;
            NSNumber *error = [dic objectForKey:@"error"];
            // error = 2 成功返回老师的班级
            if ([error isEqualToNumber:@2]) {
                NSArray *classArrs = [dic objectForKey:@"oneclass"];
                [self.classInfos removeAllObjects];
                for (NSDictionary *classDic in classArrs) {
                    ClassInfo *ci = [ClassJsonParser parseClassInfo:classDic];
                    [self.classInfos addObject:ci];
                }
                self.menu.items = self.classInfos;
                self.menu.table.items = self.classInfos;
                [self.menu.table reloadData];
            }
        } else {
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.animationType = MBProgressHUDAnimationZoomIn;
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"errormark"]];
            HUD.labelText = @"网络出错了>_<";
            [HUD hide:YES afterDelay:1.0];
        }
    }];
}

#pragma mark - Action
- (void)clickOnSettingButton:(id)sender {
    //[self.menu onHandleMenuTap:sender];
    [self.menu onHideMenu];
    [self performSegueWithIdentifier:@"ShowClassSetting" sender:self];
}

- (void)clickOnRefreshButton:(id)sender {
    [self requestClassInfosFromServer];
}

- (void)clickOnLeftButton:(id)sender {
    //[self.menu onHandleMenuTap:sender];
    [self.menu onHideMenu];
    [self performSegueWithIdentifier:@"ShowUserDetail" sender:self];
}




#pragma mark - SINavigationView delegate
- (void)didSelectItemAtIndex:(NSUInteger)index {
    self.selectedClassInfo = _classInfos[index];
    [ClassInfo saveClassInfoToLocal:_selectedClassInfo];
    self.settingButton.enabled = YES;
}

- (void)clickOnFooterButton {
    [self.menu onHideMenu];
    [self performSegueWithIdentifier:@"ShowCreateClass" sender:self];
}

- (void)clickOnMenuButtonAtActiveState:(BOOL)isActive {
    if (isActive) {
        [self.navigationController.navigationBar addSubview:self.refreshButton];
        [self.refreshButton setAlpha:0.0];
        [UIView animateWithDuration:0.3 animations:^{
            [self.refreshButton setAlpha:1.0];
            [self.settingButton setAlpha:0.0];
        } completion:^(BOOL finished) {
            [self.settingButton setEnabled:NO];
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            [self.settingButton setAlpha:1.0];
            [self.refreshButton setAlpha:0.0];
        } completion:^(BOOL finished) {
            [self.settingButton setEnabled:YES];
            [self.refreshButton removeFromSuperview];
        }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id destinationVC = [segue destinationViewController];
    if ([segue.identifier isEqualToString:@"ShowClassSetting"]) {
        [destinationVC setValue:_selectedClassInfo forKey:@"classInfo"];
    }
    
}


@end
