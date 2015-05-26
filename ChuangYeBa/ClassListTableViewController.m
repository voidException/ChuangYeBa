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
#import "ClassBriefView.h"
#import "TeacherTestGroupCell.h"

static NSString *testGroupCellIdentifier = @"TestGroupCell";

@interface ClassListTableViewController () <SINavigationMenuDelegate,TeacherTestGroupDelegate, UIActionSheetDelegate>

// UI相关属性
@property (strong, nonatomic) SINavigationMenuView *menu;
@property (strong, nonatomic) UIButton *settingButton;
@property (strong, nonatomic) UIButton *refreshButton;
@property (strong, nonatomic) UIButton *addButton;
@property (strong, nonatomic) CircleButton *leftButton;
@property (strong, nonatomic) ClassBriefView *headerView;
@property (strong, nonatomic) UIView *blankView;


// 数据相关
@property (strong, nonatomic) UserInfo *userInfo;
// 题组信息
@property (strong, nonatomic) NSMutableDictionary *testGroups;
@property (strong, nonatomic) TestGroup *selectedTestGroup;
// 班级信息
@property (strong, nonatomic) NSMutableArray *classInfos;
@property (strong, nonatomic) ClassInfo *selectedClassInfo;
@property (strong, nonatomic) NSArray *testStatistics;

@end

@implementation ClassListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化数据
    self.userInfo = [UserInfo loadUserInfoFromLocal];
    self.selectedClassInfo = [ClassInfo loadClassInfoFromLocal];
    self.classInfos = [[NSMutableArray alloc] init];
    self.testGroups = [[NSMutableDictionary alloc] init];
    // 初始化UI
    [self initUI];
    // 开始第一次请求
    if (self.selectedClassInfo) {
        [self requestTestGroupsFromServer];
    }
    [self requestClassInfosFromServer];
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestTestGroupsFromServer) name:@"UserAddedTestGroups" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userCreateClass:) name:@"UserCreateClass" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadClassBrief:) name:@"UpdateClassInfo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginIn:) name:@"UpdateUserInfo" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillDisappear:animated];

    if (!_selectedClassInfo) {
        self.refreshButton.enabled = NO;
        self.addButton.enabled = NO;
        _headerView.hidden = YES;
        self.blankView = [[UIView alloc] initWithFrame:self.view.frame];
        _blankView.backgroundColor = [UIColor clearColor];
        [self.view insertSubview:_blankView atIndex:1];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 100)];
        label.text = @"请选择班级";
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:20];
        [label sizeToFit];
        label.center = self.view.center;
        label.center = CGPointMake(_blankView.center.x, self.view.center.y - 20);
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"classBlankBG"]];
        image.center = CGPointMake(_blankView.center.x, self.view.center.y - 100);
        [_blankView addSubview:image];
        [_blankView addSubview:label];
    }
    [self.refreshButton setAlpha:0.0];
    [self.leftButton setAlpha:0.0];
    [self.addButton setAlpha:0.0];
    [self.navigationController.navigationBar addSubview:self.refreshButton];
    [self.navigationController.navigationBar addSubview:self.leftButton];
    [self.navigationController.navigationBar addSubview:self.addButton];
    [UIView animateWithDuration:0.3 animations:^{
        [self.leftButton setAlpha:1.0];
        [self.addButton setAlpha:1.0];
        [self.refreshButton setAlpha:1.0];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIView animateWithDuration:0.3 animations:^{
        [self.leftButton setAlpha:0.0];
        [self.addButton setAlpha:0.0];
        [self.refreshButton setAlpha:0.0];
    } completion:^(BOOL finished) {
        [self.leftButton removeFromSuperview];
        [self.addButton removeFromSuperview];
        [self.refreshButton removeFromSuperview];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method
- (void)initUI {
    // 初始化tableview相关属性
    self.clearsSelectionOnViewWillAppear = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"TeacherTestGroupCell" bundle:nil] forCellReuseIdentifier:testGroupCellIdentifier];
    
    // 初始化tableView的头视图
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ClassBriefView" owner:nil options:nil];
    self.headerView = [nib objectAtIndex:0];
    self.tableView.tableHeaderView = _headerView;
    _headerView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOnSettingButton:)];
    [_headerView addGestureRecognizer:tapGesture];
    
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
    
    // 初始化右侧导航条加入题组按钮
    self.addButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 2 * (buttonWidth + 7), 7, buttonWidth, buttonWidth)];
    [self.addButton setImage:[[UIImage imageNamed:@"addTestGroupButtonNormal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.addButton addTarget:self action:@selector(clickOnAddButton:) forControlEvents:UIControlEventTouchUpInside];
    
    // 初始化左导航条按钮
    self.leftButton = [[CircleButton alloc] initWithFrame:CGRectMake(7, 7, 30, 30)];
    self.leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.leftButton sd_setImageWithURL:[NSURL URLWithString:_userInfo.photoPath] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.leftButton setCircleImage:image placeholder:[UIImage imageNamed:@"photoPlaceholderSmall"] forState:UIControlStateNormal];
    }];
    [self.leftButton addTarget:self action:@selector(clickOnLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    
    // 初始化下拉菜单
    if (self.navigationItem) {
        CGRect frame = CGRectMake(0.0, 0.0, 200.0, self.navigationController.navigationBar.bounds.size.height);
        self.menu = [[SINavigationMenuView alloc] initWithFrame:frame title:@"全部班级"];
        [self.menu displayMenuInView:self.tabBarController.view];
        self.menu.items = @[];
        self.menu.delegate = self;
        self.navigationItem.titleView = self.menu;
    }
    
}

- (void)reloadClassBrief:(NSNotification *)notif {
    [self.headerView setNeedsLayout];
}

- (void)userCreateClass:(NSNotification *)notif {
    self.selectedClassInfo = [notif.userInfo objectForKey:@"classInfo"];
    [ClassInfo saveClassInfoToLocal:_selectedClassInfo];
    [self requestClassInfosFromServer];
    [self requestTestGroupsFromServer];
    [self.headerView setNeedsLayout];
}

- (void)userLoginIn:(NSNotification *)notif {
    self.selectedClassInfo = nil;
    self.userInfo = [UserInfo loadUserInfoFromLocal];
    [self requestClassInfosFromServer];
    [self.headerView setNeedsLayout];
}

- (void)requestClassInfosFromServer {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
    [ClassNetworkUtils requestClassInfosWithTeacherId:_userInfo.userId andCallback:^(id obj) {
        if (obj) {
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.animationType = MBProgressHUDAnimationZoomIn;
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark"]];
            HUD.labelText = @"加载班级成功";
            [HUD hide:YES afterDelay:0.5];
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

- (void)requestTestGroupsFromServer {
    [_testGroups removeAllObjects];
    [self.tableView reloadData];
    [ClassNetworkUtils requestTestGroupByClassId:_selectedClassInfo.classId andCallback:^(id obj) {
        if (obj) {
            NSDictionary *dic = obj;
            NSNumber *error = [dic objectForKey:@"error"];
            // 如果正确返回题组
            if ([error isEqual:@1]) {
                // 清空保存testGroup的字典
                
                NSArray *testGroupArr = [dic objectForKey:@"itemTest"];
                if (testGroupArr.count) {
                    for (NSDictionary *testGroup in testGroupArr) {
                        TestGroup *tg = [ClassJsonParser parseTestGropu:testGroup];
                        [_testGroups setObject:tg forKey:tg.itemId];
                    }
                    [self.tableView reloadData];
                }
            }
        }
    }];
}

#pragma mark - Action
- (void)clickOnSettingButton:(id)sender {
    [self.menu onHideMenu];
    [self performSegueWithIdentifier:@"ShowClassSetting" sender:self];
}

- (void)clickOnRefreshButton:(id)sender {
    [self requestClassInfosFromServer];
    [self requestTestGroupsFromServer];
}

- (void)clickOnLeftButton:(id)sender {
    [self.menu onHideMenu];
    [self performSegueWithIdentifier:@"ShowUserDetail" sender:self];
}

- (void)clickOnAddButton:(id)sender {
    [self performSegueWithIdentifier:@"ShowAllTestGroups" sender:self];
}


#pragma mark - Teacher TestGroup cell delegate
- (void)teacherTestGroupCell:(TeacherTestGroupCell *)cell clickOnButtonAtIndex:(NSInteger)index {
    // 点击添加题组按键
    if (index == 0) {
        NSNumber *state = [[NSNumber alloc] init];
        if ([cell.testGroup.activity isEqual:@0]) {
            state = @1;
        } else {
            state = @0;
        }
        [ClassNetworkUtils requestUpdateTestGroupStateByClassId:_selectedClassInfo.classId itemId:cell.testGroup.itemId state:state andCallback:^(id obj) {
            if ([state isEqual:@1]) {
                [cell setState:TestGroupStatepublish];
                cell.testGroup.activity = @1;
            } else {
                [cell setState:TestGroupStateUnpublish];
                cell.testGroup.activity = @0;
            }
        }];
    }
    // 点击查看结果
    else if (index == 1) {
        [ClassNetworkUtils requestTestStatisticsByClassId:_selectedClassInfo.classId itemId:cell.testGroup.itemId andCallback:^(id obj) {
            if (obj) {
                NSDictionary *dic = obj;
                _testStatistics = [dic objectForKey:@"itemAccurateNumVo"];
                _selectedTestGroup = cell.testGroup;
                [self performSegueWithIdentifier:@"ShowTestStatistics" sender:self];
            }
            
        }];
    }
    // 点击删除按钮
    else if (index == 2) {
        self.selectedTestGroup = cell.testGroup;
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"确认删除该题组吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认" otherButtonTitles:nil, nil];
        actionSheet.tag = 0;
        [actionSheet showInView:self.view];
    }
}

#pragma mark - SINavigationView delegate
- (void)didSelectItemAtIndex:(NSUInteger)index {
    self.selectedClassInfo = _classInfos[index];
    if (_selectedClassInfo) {
        if (_blankView) {
            _addButton.enabled = YES;
            _refreshButton.enabled = YES;
            _headerView.hidden = NO;
            [_blankView removeFromSuperview];
            _blankView = nil;
        }
    }
    [ClassInfo saveClassInfoToLocal:_selectedClassInfo];
    [self requestTestGroupsFromServer];
    [self.headerView setNeedsLayout];
}

- (void)clickOnFooterButton {
    [self.menu onHideMenu];
    [self performSegueWithIdentifier:@"ShowCreateClass" sender:self];
}

- (void)clickOnMenuButtonAtActiveState:(BOOL)isActive {
    if (isActive) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.addButton setAlpha:0.0];
        } completion:^(BOOL finished) {
            [self.addButton setEnabled:NO];
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            [self.addButton setAlpha:1.0];
        } completion:^(BOOL finished) {
            if (_selectedClassInfo) {
                [self.addButton setEnabled:YES];
            }
        }];
    }
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 92;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 16;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[_testGroups allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TeacherTestGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:testGroupCellIdentifier];
    cell.delegate = self;
    NSArray *arr = [_testGroups allValues];
    cell.testGroup = arr[indexPath.section];
    return cell;
}

#pragma mark - Action Sheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 0) {
        if (buttonIndex == 0) {
            [ClassNetworkUtils submitDeleteTestGroupByClassId:_selectedClassInfo.classId itemId:self.selectedTestGroup.itemId andCallback:^(id obj) {
                [_testGroups removeObjectForKey:self.selectedTestGroup.itemId];
                [self.tableView reloadData];
            }];
        }
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id destinationVC = [segue destinationViewController];
    if ([segue.identifier isEqualToString:@"ShowClassSetting"]) {
        [destinationVC setValue:_selectedClassInfo forKey:@"classInfo"];
    } else if ([segue.identifier isEqualToString:@"ShowAllTestGroups"]) {
        [destinationVC setValue:[_testGroups allKeys] forKey:@"addedTestGroupId"];
        [destinationVC setValue:_selectedClassInfo forKey:@"classInfo"];
    } else if ([segue.identifier isEqualToString:@"ShowTestStatistics"]) {
        [destinationVC setValue:_testStatistics forKey:@"testStatistics"];
        [destinationVC setValue:_selectedTestGroup forKey:@"testGroup"];
    }
    
}


@end
