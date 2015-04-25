//
//  ClassTableViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/20.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "ClassTableViewController.h"

static NSString *testGroupCellIdentifier = @"TestGroupCell";

@interface ClassTableViewController ()

@end

@implementation ClassTableViewController
@synthesize allTestGroups;

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 注册xib的cell
    [self.tableView registerNib:[UINib nibWithNibName:@"TestGroupCell" bundle:nil] forCellReuseIdentifier:testGroupCellIdentifier];

    [self.segmentedControl addTarget:self action:@selector(doSomethingInSegment:) forControlEvents:UIControlEventValueChanged];
    
    // 初始化数组
    self.unTestedGroup = [[NSMutableArray alloc] init];
    self.testedGroup = [[NSMutableArray alloc] init];
    self.displayTestGroup = [[NSMutableArray alloc] init];
    
    // 读取本地的用户信息
    [self loadUserInfoFromLocal];
    
    // 增加下啦刷新
    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf requestTestGroupsFromServer];
    }];
    [self.tableView.header beginRefreshing];

    [self setNavigationBarAttributes];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method

- (void)setNavigationBarAttributes {
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:44.0/255 green:149.0/255 blue:255.0/255 alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}


- (void)requestTestGroupsFromServer {
    __weak typeof(self) weakSelf = self;
    [ClassNetworkUtils requestTestGroupByStudentId:self.userInfo.userId andCallback:^(id obj) {
        self.allTestGroups = obj;
        // 请求成功后清空已经保存的题组
        [self.testedGroup removeAllObjects];
        [self.unTestedGroup removeAllObjects];
        // 区分做过的题组合没做过的题组
        for (TestGroup *tg in self.allTestGroups) {
            if ([tg.activity integerValue] == 3) {
                [self.unTestedGroup addObject:tg];
            } else if ([tg.activity integerValue] == 4) {
                [self.testedGroup addObject:tg];
            }
        }
        // 显示在界面上
        switch (self.segmentedControl.selectedSegmentIndex) {
            case 0:
                self.displayTestGroup = self.unTestedGroup;
                // 重新加载tableView
                [weakSelf.tableView reloadData];
                break;
            case 1:
                self.displayTestGroup = self.testedGroup;
                // 重新加载tableView
                [weakSelf.tableView reloadData];
                break;
            default:
                break;
        }
        
        // 停止下拉刷新动画
        [weakSelf.tableView.header endRefreshing];
    }];
}

- (void)loadUserInfoFromLocal {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *udObject = [ud objectForKey:@"userInfo"];
    self.userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:udObject];
}

#pragma mark - Action
- (void)doSomethingInSegment:(UISegmentedControl *)seg {
    NSInteger index = seg.selectedSegmentIndex;
    switch (index) {
        case 0:
            self.displayTestGroup = self.unTestedGroup;
            [self.tableView reloadData];
            break;
        case 1:
            self.displayTestGroup = self.testedGroup;
            [self.tableView reloadData];
            break;
        default:
            break;
    }
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedTestGroup = [[TestGroup alloc] init];
    self.selectedTestGroup = self.displayTestGroup[indexPath.row];
    [self performSegueWithIdentifier:@"ShowTestDetail" sender:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.displayTestGroup.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TestGroupCell *testGroupCell = [tableView dequeueReusableCellWithIdentifier:testGroupCellIdentifier];
    testGroupCell.testImage.image = [UIImage imageNamed:@"USA.png"];
    NSInteger row = [indexPath row];
    TestGroup *tg = [[TestGroup alloc] init];
    tg = self.displayTestGroup[row];
    
    testGroupCell.titleLabel.text = tg.itemTitle;
    // TEST
    //testGroupCell.stateLabel.text = tg.activity;
    return testGroupCell;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowTestDetail"]) {
        id destinationVC =  [segue destinationViewController];
        [destinationVC setValue:self.selectedTestGroup forKey:@"testGroup"];
    }
}

@end
