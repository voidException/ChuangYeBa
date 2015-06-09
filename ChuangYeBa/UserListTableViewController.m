//
//  UserListTableViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/27.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "UserListTableViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UserInfo.h"
#import "ClassNetworkUtils.h"

// temp
#import "GlobalDefine.h"

static NSString *cellIdentifier = @"Cell";

@interface UserListTableViewController () <UIAlertViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) NSMutableArray *studentArray;
@property (strong, nonatomic) NSMutableDictionary *studentDic;
@property (strong, nonatomic) NSMutableArray *filterStudentArray;
@property (strong, nonatomic) NSMutableDictionary *deleteDic;
@property (strong, nonatomic) NSMutableDictionary *deleteIndexPath;
@property (strong, nonatomic) ClassInfo *classInfo;

@property (strong, nonatomic) UIButton *toolbarButton;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@end

@implementation UserListTableViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.deleteDic = [[NSMutableDictionary alloc] init];
    self.deleteIndexPath = [[NSMutableDictionary alloc] init];
    
    [self initUI];
    [self filterContentForSearchText:@"" scope:-1];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    //if ([keyPath isEqualToString:@"deletedDic"]) {
        NSLog(@"KVO ACTIVE");
    //}
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Private Method
- (void)initUI {
    
    self.title = [NSString stringWithFormat:@"成员信息（%lu人）",(unsigned long)[[self.studentDic allKeys] count]];
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backButtonIcon"] landscapeImagePhone:nil style:UIBarButtonItemStyleDone target:self action:@selector(clickOnBackButton)];
    self.navigationItem.backBarButtonItem = btn;
    self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.tableHeaderView = _searchBar;
    //_searchBar.barTintColor = [UIColor colorWithWhite:0.756 alpha:1.000];
    
#ifdef TEACHER_VERSION
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _toolbarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 86, 30)];
    //toolbarButton.center = self.navigationController.toolbar.center;
    _toolbarButton.center = CGPointMake(self.view.frame.size.width/2, 44/2);
    [_toolbarButton addTarget:self action:@selector(clickOnDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
    [_toolbarButton setBackgroundImage:[UIImage imageNamed:@"exitButtonBG"] forState:UIControlStateNormal];
    [_toolbarButton setTitle:@"删除" forState:UIControlStateNormal];
    [self.navigationController.toolbar addSubview:_toolbarButton];
    self.navigationController.toolbar.autoresizesSubviews = YES;

#endif
    
}

- (void)submitDeleteUsers {
    NSArray *delStuArr = [self.deleteDic allValues];
    NSArray *indexPathArr = [self.deleteIndexPath allValues];
    __block NSInteger sum = 0;
    for (int i = 0; i < delStuArr.count; i++) {
        UserInfo *userInfo = delStuArr[i];
        [ClassNetworkUtils submitQuitClassWithUserId:userInfo.userId andClassId:_classInfo.classId andCallback:^(id obj) {
            NSLog(@"删除学生 %@ 成功", userInfo.name);
            sum ++;
#warning 普通！有非常低的概率存在意外的错误，万一真的有一个学生没有删除，这个sum就不能达到有效的值，然后无法达到想要的显示效果。
            if (sum == delStuArr.count) {
                [self.studentDic removeObjectsForKeys:[self.deleteDic allKeys]];
                self.filterStudentArray = [NSMutableArray arrayWithArray:[self.studentDic allValues]];
                [self filterContentForSearchText:_searchBar.text scope:0];
                if (self.searchDisplayController.active) {
                    [self.searchDisplayController.searchResultsTableView deleteRowsAtIndexPaths:indexPathArr withRowAnimation:UITableViewRowAnimationFade];
                    [self.tableView reloadData];
                } else {
                    [self.tableView deleteRowsAtIndexPaths:indexPathArr withRowAnimation:UITableViewRowAnimationFade];
                    [self updateViewConstraints];
                }
                if (self.editing) {
                    // 退出编辑状态
                    [self.tableView setEditing:NO animated:YES];
                    self.editing = NO;
                }
                [self.deleteDic removeAllObjects];
                [self.deleteIndexPath removeAllObjects];
            }
        }];
    }
}

#pragma mark - Action
- (void)clickOnBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickOnDeleteButton:(id)sender {
    NSArray *delStuArr = [self.deleteDic allValues];
    NSString *nameList = @"请确认您要删除以下的同学：";
    NSString *symbol;
    for (int i = 0; i < delStuArr.count; i++) {
        UserInfo *ui = delStuArr[i];
        if (i == delStuArr.count - 1) {
            symbol = @"。";
        } else {
            symbol = @"、";
        }
        nameList = [nameList stringByAppendingString:[NSString stringWithFormat:@"%@%@", ui.name, symbol]];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:nameList delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    if ([sender isKindOfClass:[UIButton class]]) {
        alert.tag = 0;
    } else {
        alert.tag = 1;
    }
    [alert show];
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        arr = _filterStudentArray;
    } else {
        arr = [_studentDic allValues];
    }
    return [_filterStudentArray count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arr;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        arr = _filterStudentArray;
    } else {
        arr = [_studentDic allValues];
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    //NSArray *arr = [self.studentDic allValues];
    UserInfo *userInfo = _filterStudentArray[indexPath.row];
    cell.textLabel.text = userInfo.name;
    cell.detailTextLabel.text = userInfo.userNo;
    NSString *path = userInfo.photoPath;
    
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.cornerRadius = 16;
    
    cell.imageView.image = [self OriginImage:[UIImage imageNamed:@"photoPlaceholderSmall"] scaleToSize:CGSizeMake(34, 34)];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:path] options:SDWebImageHighPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (image) {
            cell.imageView.image = [self OriginImage:image scaleToSize:CGSizeMake(34, 34)];
        }
    }];
    //[cell.imageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"photoPlaceholderSmall"]];
#ifdef STUDENT_VERSION
    cell.userInteractionEnabled = NO;
#elif TEACHER_VERSION
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
#endif
    return cell;
}

// 调整图像大小
- (UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;   //返回的就是已经改变的图片
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    if (editing) {
        // 进入编辑状态
        if (![_deleteDic count]) {
            _toolbarButton.enabled = NO;
        }
        [_deleteDic removeAllObjects];
        [_deleteIndexPath removeAllObjects];
        [self.navigationController setToolbarHidden:NO animated:animated];
    } else {
        // 退出编辑状态
        [_deleteDic removeAllObjects];
        [_deleteIndexPath removeAllObjects];
        [self.navigationController setToolbarHidden:YES animated:animated];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 在全部学生显示的状态下
    
    if (tableView.editing) {
       // NSLog(@"%lu", [self.deleteDic count]);
        
        NSArray *arr = [self.studentDic allValues];
        UserInfo *student = arr[indexPath.row];
        [self.deleteDic setObject:student forKey:student.userId];
        [self.deleteIndexPath setObject:indexPath forKey:student.userId];
        if ([[self.deleteDic allKeys] count]) {
            _toolbarButton.enabled = YES;
        } else {
            _toolbarButton.enabled = NO;
        }

    }
    // 在筛选状态下
    else {
        UserInfo *student = _filterStudentArray[indexPath.row];
        [self.deleteDic setObject:student forKey:student.userId];
        [self.deleteIndexPath setObject:indexPath forKey:student.userId];
        [self clickOnDeleteButton:self];
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.editing) {
        
        NSArray *arr = [self.studentDic allValues];
        UserInfo *student = arr[indexPath.row];
        [self.deleteDic removeObjectForKey:student.userId];
        [self.deleteIndexPath removeObjectForKey:student.userId];
        if ([[self.deleteDic allKeys] count]) {
            _toolbarButton.enabled = YES;
        } else {
            _toolbarButton.enabled = NO;
        }
    }
}


#pragma mark - Alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 0) {
        if (buttonIndex == 1) {
            [self submitDeleteUsers];
        }
    } else if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            [self submitDeleteUsers];
        } else if (buttonIndex == 0){
            [self.deleteDic removeAllObjects];
            [self.deleteIndexPath removeAllObjects];
        }
    }
}

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSUInteger)scope;
{
    
    if([searchText length]==0)
    {
        //查询所有
        self.filterStudentArray = [NSMutableArray arrayWithArray:[self.studentDic allValues]];
        return;
    }
    
    NSPredicate *scopePredicate;
    NSArray *tempArray;
    switch (scope) {
        case 0: //正常查询
            scopePredicate = [NSPredicate predicateWithFormat:@"SELF.userNo contains %@ OR SELF.name contains[d] %@", searchText, searchText];
            tempArray =[[self.studentDic allValues] filteredArrayUsingPredicate:scopePredicate];
            self.filterStudentArray = [NSMutableArray arrayWithArray:tempArray];
            break;
        default:
            //查询所有
            self.filterStudentArray = [NSMutableArray arrayWithArray:[self.studentDic allValues]];
            break;
    }
}


#pragma mark - Search Display Controller delegate
- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    [self filterContentForSearchText:@"" scope:-1];
    [self.tableView reloadData];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString scope:0];
    return YES;
}

@end
