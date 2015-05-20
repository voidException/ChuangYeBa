//
//  TestGroupsTableViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/5/19.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "TestGroupsTableViewController.h"
#import "TestGroup.h"
#import "UserInfo.h"
#import "ClassInfo.h"
#import "ClassNetworkUtils.h"
#import "ClassJsonParser.h"

@interface TestGroupsTableViewController ()

@property (strong, nonatomic) NSMutableDictionary *testGroups;
@property (strong, nonatomic) UserInfo *userInfo;
@property (strong, nonatomic) NSMutableDictionary *addDic;
@property (strong, nonatomic) NSMutableDictionary *addIndexPath;
@property (strong, nonatomic) NSArray *addedTestGroupId;
@property (strong, nonatomic) ClassInfo *classInfo;

@end

@implementation TestGroupsTableViewController

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化数据
    self.userInfo = [UserInfo loadUserInfoFromLocal];
    self.testGroups = [[NSMutableDictionary alloc] init];
    self.addIndexPath = [[NSMutableDictionary alloc] init];
    // 初始化UI
    [self initUI];
    
    [self requestAllTestGroupsFromServer];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method
- (void)initUI {
    
    self.title = @"练习题库";
    // 初始化Tableview属性
    self.clearsSelectionOnViewWillAppear = NO;
    
    // 初始化导航条右上角编辑按键
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    UIButton *toolbarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 86, 30)];
    //toolbarButton.center = self.navigationController.toolbar.center;
    toolbarButton.center = CGPointMake(self.view.frame.size.width/2, 44/2);
    [toolbarButton addTarget:self action:@selector(clickOnAddButton:) forControlEvents:UIControlEventTouchUpInside];
    [toolbarButton setBackgroundImage:[UIImage imageNamed:@"loginButtonBG"] forState:UIControlStateNormal];
    [toolbarButton setTitle:@"添加" forState:UIControlStateNormal];
    [self.navigationController.toolbar addSubview:toolbarButton];
    self.navigationController.toolbar.autoresizesSubviews = YES;
}

- (void)requestAllTestGroupsFromServer {
    [ClassNetworkUtils requestAllTestGroupByTeacherId:_userInfo.userId andCallback:^(id obj) {
        NSDictionary *dic = obj;
        NSNumber *error = [dic objectForKey:@"error"];
        if ([error isEqual:@1]) {
            NSArray *testGroupArr = [dic objectForKey:@"itemTest"];
            for (NSDictionary *testGroup in testGroupArr) {
                TestGroup *tg = [ClassJsonParser parseTestGropu:testGroup];
                [_testGroups setObject:tg forKey:tg.itemId];
            }
            // 去掉已经添加在班级中的题组
            [_testGroups removeObjectsForKeys:_addedTestGroupId];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Action
- (void)clickOnAddButton:(id)sender {
    NSArray *arrValues = [_addDic allValues];
    __block NSInteger sum = 0;
    for (int i = 0; i < arrValues.count; i++) {
        TestGroup *tg = arrValues[i];
        [ClassNetworkUtils submitAddTestGroupWithClassId:_classInfo.classId itemId:tg.itemId andCallback:^(id obj) {
            NSLog(@"itemId = %@成功加入题组", tg.itemId);
            sum ++;
            if (sum == arrValues.count) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UserAddedTestGroups" object:nil];
                [_testGroups removeObjectsForKeys:[_addDic allKeys]];
                NSArray *indexPathArr = [_addIndexPath allValues];
                [self.tableView deleteRowsAtIndexPaths:indexPathArr withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView setEditing:NO animated:YES];
                // 退出编辑状态
                self.editing = NO;
                [_addDic removeAllObjects];
                [_addIndexPath removeAllObjects];
            }
        }];
    }
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    if (editing) {
        // 进入编辑状态
        self.addDic = [[NSMutableDictionary alloc] init];
        
        [self.navigationController setToolbarHidden:NO animated:animated];
        
    } else {
        // 退出编辑状态
        self.addDic = nil;
        [self.navigationController setToolbarHidden:YES animated:animated];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.editing) {
        NSArray *arr = [self.testGroups allValues];
        TestGroup *tg = arr[indexPath.row];
        [self.addDic setObject:tg forKey:tg.itemId];
        [self.addIndexPath setObject:indexPath forKey:tg.itemId];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.editing) {
        NSArray *arr = [self.testGroups allValues];
        TestGroup *tg = arr[indexPath.row];
        [self.addDic removeObjectForKey:tg.itemId];
        [self.addIndexPath removeObjectForKey:tg.itemId];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_testGroups allValues] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSArray *arr = [_testGroups allValues];
    TestGroup *tg = arr[indexPath.row];
    cell.textLabel.text = tg.itemTitle;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
