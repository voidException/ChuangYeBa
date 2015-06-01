//
//  ClassSettingTableViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/11.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "ClassSettingTableViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "MeNetworkUtils.h"
#import <MBProgressHUD.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "GlobalDefine.h"

static NSString *classInfoCellIdentifier = @"ClassInfoCell";
static NSString *bucket = @"startupimg";

@interface ClassSettingTableViewController ()
<UIActionSheetDelegate
,UIImagePickerControllerDelegate
,UINavigationControllerDelegate
#ifdef TEACHER_VERSION
,ClassInfoCellDelegate
#endif
>

@property (strong, nonatomic) NSMutableDictionary *studentDic;
@property (strong, nonatomic) UIImage *userChoosePhoto;

@end

@implementation ClassSettingTableViewController
//@synthesize classInfo;
@synthesize userInfo;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    // 初始化数组
    self.studentDic = [[NSMutableDictionary alloc] init];
    
    self.classInfo = [ClassInfo loadClassInfoFromLocal];
    self.userInfo = [UserInfo loadUserInfoFromLocal];
    [self requestClassInfoFormServer];
    
#ifdef TEACHER_VERSION
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadClassInfo:) name:@"UpdateClassInfo" object:nil];
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method
- (void)initUI {
    self.title = @"班级设置";
    
    self.clearsSelectionOnViewWillAppear = YES;

    self.tableView.tableFooterView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 60);
    // 注册XIB小区
    [self.tableView registerNib:[UINib nibWithNibName:@"ClassInfoCell" bundle:nil] forCellReuseIdentifier:classInfoCellIdentifier];
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"lastButtonIcon"] landscapeImagePhone:nil style:UIBarButtonItemStyleDone target:self action:@selector(clickOnBackButton)];
    self.navigationItem.leftBarButtonItem = btn;
    
    
    float buttonMargin = 13.0;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    self.footerButton = [[BorderRadiusButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 2 * buttonMargin, 0)];
    self.footerButton.center = footerView.center;
#ifdef STUDENT_VERSION
    [self.footerButton setButtonColor:[UIColor CYBRedColor]];
    [self.footerButton setTitle:@"删除并退出" forState:UIControlStateNormal];
#elif TEACHER_VERSION
    [self.footerButton setTitle:@"编辑班级信息" forState:UIControlStateNormal];
#endif
    [footerView addSubview:self.footerButton];
    [self.footerButton addTarget:self action:@selector(clickOnFooterButton:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = footerView;

}

- (void)reloadClassInfo:(NSNotification *)notif {
    self.classInfo = [ClassInfo loadClassInfoFromLocal];
    [self.tableView reloadData];
}

- (void)requestClassInfoFormServer {
    [ClassNetworkUtils requestClassInfoByClassNo:self.classInfo.classNo andCallback:^(id obj) {
        if (obj) {
            NSDictionary *dic = obj;
            self.classInfo = [ClassJsonParser parseClassInfo:[dic objectForKey:@"oneClass"]];
            self.classInfo.teacher = [LoginJsonParser parseUserInfoInLogin:[dic objectForKey:@"teacher"] isTeacher:YES];
            [ClassInfo saveClassInfoToLocal:self.classInfo];
            NSArray *userListArr = [dic objectForKey:@"studentTwoVo"];
            for (NSDictionary *userInfoDic in userListArr) {
                UserInfo *aUser = [ClassJsonParser parseUserInfo:userInfoDic];
                [self.studentDic setObject:aUser forKey:aUser.userId];
            }
            [self.tableView reloadData];
        }
    }];
}

#ifdef STUDENT_VERSION
- (void)submitQuitClassToServer {
    [ClassNetworkUtils submitQuitClassWithUserId:self.userInfo.userId andClassId:self.classInfo.classId andCallback:^(id obj) {
        NSLog(@"%@", obj);
        // 修改UserDeaults中的isUserAddedClass的值，修改为NO
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        self.userInfo.roomno = @"0";
        [UserInfo saveUserInfoToLocal:self.userInfo];
        [ud removeObjectForKey:@"classInfo"];
        [ud synchronize];
        // 返回上级菜单
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}
#endif

#pragma mark - Action
- (void)clickOnBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

#ifdef STUDENT_VERSION
- (void)clickOnFooterButton:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出班级" otherButtonTitles:nil, nil];
    [actionSheet showInView:self.view];
}

#elif TEACHER_VERSION
- (void)clickOnFooterButton:(id)sender {
    [self performSegueWithIdentifier:@"ShowClassEdited" sender:self];
}
#endif

#pragma mark - Tbale view delegaet
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 176;
    } else {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return 22;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return 1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([indexPath isEqual:[NSIndexPath indexPathForRow:0 inSection:1]]) {
        self.navigationController.hidesBottomBarWhenPushed = YES;
        [self performSegueWithIdentifier:@"ShowUserDetail" sender:self];
    }
    
    if ([indexPath isEqual:[NSIndexPath indexPathForRow:0 inSection:2]]) {
        if ([[self.studentDic allKeys] count]) {
            [self performSegueWithIdentifier:@"ShowUserList" sender:self];
            
            // 设置返回按钮
            UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
            self.navigationItem.backBarButtonItem = btn;
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndentifier = @"Cell";
    if (indexPath.section == 0) {
        ClassInfoCell *classInfoCell = [tableView dequeueReusableCellWithIdentifier:classInfoCellIdentifier];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        NSString *classNoString = [formatter stringFromNumber:self.classInfo.classNo];
        classInfoCell.classNoLabel.text = classNoString;
        classInfoCell.classNameLabel.text = self.classInfo.classroomName;
        [classInfoCell.photo sd_setImageWithURL:[NSURL URLWithString:_classInfo.photoPath] placeholderImage:[UIImage imageNamed:@"classPhotoPlaceholder"]];
        
#ifdef STUDENT_VERSION
        classInfoCell.teacherNameLabel.text = self.classInfo.teacher.name;
#elif TEACHER_VERSION
        classInfoCell.teacherNameLabel.text = self.userInfo.name;
#endif
        classInfoCell.universityNameLabel.text = self.classInfo.universityName;
#ifdef TEACHER_VERSION
        classInfoCell.delegate = self;
#endif

        return classInfoCell;
    } else if ([indexPath isEqual:[NSIndexPath indexPathForRow:0 inSection:1]]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
        }
        cell.textLabel.text = @"我的信息";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        return cell;
    } else if ([indexPath isEqual:[NSIndexPath indexPathForRow:0 inSection:2]]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
        }
        cell.textLabel.text = @"班级成员";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu人",(unsigned long)[[self.studentDic allKeys] count]];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        if (![[self.studentDic allKeys] count]) {
            cell.textLabel.textColor = [UIColor grayColor];
        } else {
            cell.textLabel.textColor = [UIColor blackColor];
        }
        return cell;
    } else return nil;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowUserList"]) {
        id destinationVC= [segue destinationViewController];
        [destinationVC setValue:self.classInfo forKey:@"classInfo"];
        [destinationVC setValue:self.studentDic forKey:@"studentDic"];
    }
}

#ifdef STUDENT_VERSION
#pragma mark - Action Sheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self submitQuitClassToServer];
    }
}

#elif TEACHER_VERSION
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self pickMediaFromSource:UIImagePickerControllerSourceTypeCamera];
            break;
        case 1:
            [self pickMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
        default:
            break;
    }
}

// 压缩图片方法，用于处理选择的图片
- (UIImage *)shrinkImage:(UIImage *)original toSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    
    CGFloat originalAspect = original.size.width / original.size.height;
    CGFloat targetAspect = size.width / size.height;
    CGRect targetRect;
    
    if (originalAspect > targetAspect) {
        // original is wider than target
        targetRect.size.width = size.width;
        targetRect.size.height = size.height * targetAspect / originalAspect;
        targetRect.origin.x = 0;
        targetRect.origin.y = (size.height - targetRect.size.height) * 0.5;
    } else if (originalAspect < targetAspect) {
        // original is narrower than target
        targetRect.size.width = size.width * originalAspect / targetAspect;
        targetRect.size.height = size.height;
        targetRect.origin.x = (size.width - targetRect.size.width) * 0.5;
        targetRect.origin.y = 0;
    } else {
        // original and target have same aspect ratio
        targetRect = CGRectMake(0, 0, size.width, size.height);
    }
    
    [original drawInRect:targetRect];
    UIImage *final = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return final;
}


// 取系统相册和相机资源的方法
- (void)pickMediaFromSource:(UIImagePickerControllerSourceType)sourceType
{
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    if ([UIImagePickerController
         isSourceTypeAvailable:sourceType] && [mediaTypes count] > 0) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        NSString *requiredMediaType = (NSString *)kUTTypeImage;
        NSArray *arrayMediaType = [NSArray arrayWithObjects:requiredMediaType, nil];
        [picker setMediaTypes:arrayMediaType];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:NULL];
    } else {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"Error accessing media"
                                   message:@"Unsupported media source."
                                  delegate:nil
                         cancelButtonTitle:@"Drat!"
                         otherButtonTitles:nil];
        [alert show];
    }
}



#pragma mark - Image Picker Controller delegate methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    ClassInfoCell *cell = (ClassInfoCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    self.userChoosePhoto = [self shrinkImage:chosenImage
                                      toSize:cell.photo.bounds.size];
    [self requestUploadTokenFromServer];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)requestUploadTokenFromServer {
    // 请求上传照片的Token
    [MeNetworkUtils requestTokenForUploadTokenWithBucket:bucket andCallback:^(id obj) {
        if (obj) {
            NSDictionary *dic = obj;
            // 在这里errorMessage键传的是Token的值
            NSString *token = [dic objectForKey:@"errorMessage"];
            // 把用户选择的照片上传
            [MeNetworkUtils uploadPhotoToServer:_userChoosePhoto token:token owner:@"class" date:[NSDate date] ownerId:_classInfo.classId andCallback:^(id obj) {
                NSDictionary *dic = obj;
                NSString *key = [dic objectForKey:@"key"];
                [self.classInfo setPhotoPathWithStorageURL:key];
                
                // 提交更改用户信息到服务器，告知服务器保存新的图片地址
                [ClassNetworkUtils submitModifiedClassInfo:self.classInfo andCallback:^(id obj) {
                    if (obj) {
                        [ClassInfo saveClassInfoToLocal:self.classInfo];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateClassInfo" object:nil];
                        [self.tableView reloadData];
                        
                        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                        [self.navigationController.view addSubview:HUD];
                        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark"]];
                        HUD.mode = MBProgressHUDModeCustomView;
                        HUD.animationType = MBProgressHUDAnimationZoomIn;
                        HUD.labelText = @"上传照片成功啦";
                        [HUD show:YES];
                        [HUD hide:YES afterDelay:1.0];
                            
                    }
                }];
            }];
        }
    }];
}

#pragma mark - ClassInfoCell delegate
- (void)clickOnPhoto:(ClassInfoCell *)classInfoCell {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从系统相册中选择", nil];
    actionSheet.tag = 0;
    [actionSheet showInView:self.view];
}


#endif


@end
