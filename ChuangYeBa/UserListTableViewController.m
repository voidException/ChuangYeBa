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

@interface UserListTableViewController () <UIAlertViewDelegate>

@property (strong, nonatomic) NSMutableArray *studentArray;
@property (strong, nonatomic) NSMutableDictionary *studentDic;
@property (strong, nonatomic) NSMutableDictionary *deleteDic;
@property (strong, nonatomic) NSMutableDictionary *deleteIndexPath;
@property (strong, nonatomic) ClassInfo *classInfo;

@end

@implementation UserListTableViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
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
    
    self.title = [NSString stringWithFormat:@"成员信息（%lu人）",[[self.studentDic allKeys] count]];
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"lastButtonIcon"] landscapeImagePhone:nil style:UIBarButtonItemStyleDone target:self action:@selector(clickOnBackButton)];
    self.navigationItem.backBarButtonItem = btn;
    
    self.clearsSelectionOnViewWillAppear = NO;
#ifdef TEACHER_VERSION
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIButton *toolbarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 86, 30)];
    //toolbarButton.center = self.navigationController.toolbar.center;
    toolbarButton.center = CGPointMake(self.view.frame.size.width/2, 44/2);
    [toolbarButton addTarget:self action:@selector(clickOnDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
    [toolbarButton setBackgroundImage:[UIImage imageNamed:@"exitButtonBG"] forState:UIControlStateNormal];
    [toolbarButton setTitle:@"删除" forState:UIControlStateNormal];
    [self.navigationController.toolbar addSubview:toolbarButton];
    self.navigationController.toolbar.autoresizesSubviews = YES;

#endif
    
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
    alert.tag = 0;
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
    //return self.studentArray.count;
    return [[self.studentDic allKeys] count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    NSArray *arr = [self.studentDic allValues];
    UserInfo *userInfo = arr[indexPath.row];
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    if (editing) {
        // 进入编辑状态
        self.deleteDic = [[NSMutableDictionary alloc] init];
        self.deleteIndexPath = [[NSMutableDictionary alloc] init];
        [self.navigationController setToolbarHidden:NO animated:animated];
        
    } else {
        // 退出编辑状态
        self.deleteDic = nil;
        self.deleteIndexPath = nil;
        [self.navigationController setToolbarHidden:YES animated:animated];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.editing) {
        NSArray *arr = [self.studentDic allValues];
        UserInfo *student = arr[indexPath.row];
        [self.deleteDic setObject:student forKey:student.userId];
        [self.deleteIndexPath setObject:indexPath forKey:student.userId];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.editing) {
        NSArray *arr = [self.studentDic allValues];
        UserInfo *student = arr[indexPath.row];
        [self.deleteDic removeObjectForKey:student.userId];
        [self.deleteIndexPath removeObjectForKey:student.userId];
    }
}


#pragma mark - Alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 0) {
        if (buttonIndex == 1) {
            NSArray *delStuArr = [self.deleteDic allValues];
            NSArray *indexPathArr = [self.deleteIndexPath allValues];
            //[self.tableView setEditing:NO animated:YES];
            //[self.tableView beginUpdates];
            //[self.studentArray removeObjectAtIndex:0];
            __block NSInteger sum = 0;
            for (int i = 0; i < delStuArr.count; i++) {
                UserInfo *userInfo = delStuArr[i];
                [ClassNetworkUtils submitQuitClassWithUserId:userInfo.userId andClassId:_classInfo.classId andCallback:^(id obj) {
                    NSLog(@"删除学生 %@ 成功", userInfo.name);
                    sum ++;
#warning 普通！有非常低的概率存在意外的错误，万一真的有一个学生没有删除，这个sum就不能达到有效的值，然后无法达到想要的显示效果。
                    if (sum == delStuArr.count) {
                        [self.studentDic removeObjectsForKeys:[self.deleteDic allKeys]];
                        [self.tableView deleteRowsAtIndexPaths:indexPathArr withRowAnimation:UITableViewRowAnimationFade];
                        // 退出编辑状态
                        [self.tableView setEditing:NO animated:YES];
                        self.editing = NO;
                        [self.deleteDic removeAllObjects];
                        [self.deleteIndexPath removeAllObjects];
                    }
                }];
            }
        }
    }
}

/*
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
