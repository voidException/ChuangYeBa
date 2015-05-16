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

@interface ClassListTableViewController () <SINavigationMenuDelegate>

// UI相关属性
@property (strong, nonatomic) SINavigationMenuView *menu;
@property (strong, nonatomic) UIButton *rightButton;
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
    [self.rightButton setAlpha:0.0];
    [self.leftButton setAlpha:0.0];
    [self.navigationController.navigationBar addSubview:self.rightButton];
    [self.navigationController.navigationBar addSubview:self.leftButton];
    [UIView animateWithDuration:0.3 animations:^{
        [self.rightButton setAlpha:1.0];
        [self.leftButton setAlpha:1.0];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIView animateWithDuration:0.3 animations:^{
        [self.rightButton setAlpha:0.0];
        [self.leftButton setAlpha:0.0];
    } completion:^(BOOL finished) {
        [self.rightButton removeFromSuperview];
        [self.leftButton removeFromSuperview];
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
    
    // 初始化右导航条按钮
    float buttonWidth = 30;
    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - buttonWidth - 7, 7, buttonWidth, buttonWidth)];
    [self.rightButton setImage:[[UIImage imageNamed:@"classSettingButtonNormal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.rightButton setImage:[[UIImage imageNamed:@"classSettingButtonSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    [self.rightButton addTarget:self action:@selector(clickOnRightButton) forControlEvents:UIControlEventTouchUpInside];
    // 初始化左导航条按钮
    self.leftButton = [[CircleButton alloc] initWithFrame:CGRectMake(7, 7, 30, 30)];
    self.leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.leftButton sd_setImageWithURL:[NSURL URLWithString:_userInfo.photoPath] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.leftButton setCircleImage:image placeholder:[UIImage imageNamed:@"photoPlaceholderSmall"] forState:UIControlStateNormal];
    }];
    [self.leftButton addTarget:self action:@selector(clickOnLeftButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)requestClassInfosFromServer {
    [ClassNetworkUtils requestClassInfosWithTeacherId:_userInfo.userId andCallback:^(id obj) {
        if (obj) {
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
                
                
            }
        }
    }];
}

#pragma mark - Action
- (void)clickOnRightButton {
    [self.menu onHideMenu];
    [self performSegueWithIdentifier:@"ShowClassSetting" sender:self];
}

- (void)clickOnLeftButton {
    [self.menu onHideMenu];
    [self performSegueWithIdentifier:@"ShowUserDetail" sender:self];
}




#pragma mark - SINavigationView delegate
- (void)didSelectItemAtIndex:(NSUInteger)index {
#ifdef DEBUG
    NSLog(@"选择了第%lu个", index);
#endif
}

- (void)clickOnFooterButton {
    [self.menu onHideMenu];
    [self performSegueWithIdentifier:@"ShowCreateClass" sender:self];
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
