//
//  UserDetailTableViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/5/8.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "UserDetailTableViewController.h"
#import "EditedInfoCell.h"
#import "UserInfo.h"
#import "EditedPhotoView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIImage+MultiFormat.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "MeNetworkUtils.h"
#import "GlobalDefine.h"
#import <MBProgressHUD.h>
#import "BorderRadiusButton.h"

static NSString *editedInfoCellIdentifier = @"EditedInfoCell";
static NSString *bucket = @"startupimg";

@interface UserDetailTableViewController () <EditedPhotoViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) NSArray *detailList;
@property (strong, nonatomic) NSArray *userInfoList;
@property (strong, nonatomic) UserInfo *userInfo;
@property (strong, nonatomic) UIButton *rightButton;
@property (strong, nonatomic) EditedPhotoView *headerView;

@property (nonatomic, strong) UIImage *userChoosePhoto;

@end

@implementation UserDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self loadUserInfoFromLocal];
    [self initUI];
    
    self.clearsSelectionOnViewWillAppear = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUserInfoFromLocal:) name:@"UpdateUserInfo" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    
    if (self.userChoosePhoto) {
        [self updatePhotoDisplay];
    }
    
    [super viewWillDisappear:animated];
    //[self.navigationController.navigationBar addSubview:self.rightButton];
    [self.rightButton setAlpha:0.0];
    [UIView animateWithDuration:0.3 animations:^{
        [self.rightButton setAlpha:1.0];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIView animateWithDuration:0.3 animations:^{
        [self.rightButton setAlpha:0.0];
    } completion:^(BOOL finished) {
        [self.rightButton removeFromSuperview];
    }];
}




#pragma mark - Private Method
- (void)initUI {
    
    self.title = @"我";
    
    NSBundle *bundle = [NSBundle mainBundle];
#ifdef STUDENT_VERSION
    NSString *plistPath = [bundle pathForResource:@"userDetailListStudent" ofType:@"plist"];
#elif TEACHER_VERSION
    NSString *plistPath = [bundle pathForResource:@"userDetailListTeacher" ofType:@"plist"];
#endif
    self.detailList = [[NSArray alloc] initWithContentsOfFile:plistPath];
    
    // 初始化tableView的头视图
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EditedPhotoView" owner:nil options:nil];
    self.headerView = [nib objectAtIndex:0];
    self.headerView.delegate = self;
    [self loadHeaderView];
    self.tableView.tableHeaderView = _headerView;
    
    // 注册修改信息的小区
    [self.tableView registerNib:[UINib nibWithNibName:@"EditedInfoCell" bundle:nil] forCellReuseIdentifier:editedInfoCellIdentifier];
    
    // 初始化右导航条按钮
    float buttonWidth = 44.0;
    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - buttonWidth, 0, buttonWidth, 44)];
    [self.rightButton setImage:[[UIImage imageNamed:@"editedButtonNormal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(clickOnRightButton) forControlEvents:UIControlEventTouchUpInside];
    
    float screenWidth = self.view.frame.size.width;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 75)];
    float buttonMargin = 13.0;
    BorderRadiusButton *modifiedButton = [[BorderRadiusButton alloc] initWithFrame:CGRectMake(0, 0, screenWidth - 2 * buttonMargin, 45)];
    modifiedButton.center = footerView.center;
    [modifiedButton setTitle:@"修改信息" forState:UIControlStateNormal];
    [modifiedButton addTarget:self action:@selector(clickOnRightButton) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:modifiedButton];
    self.tableView.tableFooterView = footerView;
}

// 裁剪头像图片为圆形
- (UIImage*)circleImage:(UIImage*)image withParam:(CGFloat)inset {
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
    //CGContextAddEllipseInRect(context, rect);
    //CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}


- (void)loadUserInfoFromLocal {
    self.userInfo = [UserInfo loadUserInfoFromLocal];
    NSArray *arrSection0 = @[_userInfo.name, _userInfo.email];
#ifdef STUDENT_VERSION
    NSArray *arrSection1 = @[_userInfo.userNo, _userInfo.sex, _userInfo.school, _userInfo.department];
#elif TEACHER_VERSION
    NSArray *arrSection1 = @[_userInfo.universityName, _userInfo.tel];
#endif
    self.userInfoList = @[arrSection0, arrSection1];
}

- (void)loadHeaderView {
    __block typeof(self) weakSelf = self;
    [self.headerView.photoImage sd_setImageWithURL:[NSURL URLWithString:_userInfo.photoPath] placeholderImage:[self circleImage:[UIImage imageNamed:@"photoPlaceholderBig"] withParam:0.0] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            [weakSelf.headerView.photoImage setImage:image];
        }
    }];
    [self.headerView setSex:_userInfo.sex];
    self.headerView.nameLabel.text = _userInfo.name;
}

// 接受UpdateUserInfo通知，重载视图
- (void)reloadUserInfoFromLocal:(NSNotification *)notification {
    [self loadUserInfoFromLocal];
    [self.tableView reloadData];
    [self loadHeaderView];
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
        //picker.mediaTypes = mediaTypes;
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

//
- (void)updatePhotoDisplay {
    self.headerView.photoImage.image = self.userChoosePhoto;
}

#pragma mark - Action
- (void)clickOnPhoto:(EditedPhotoView *)editedPhotoView {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从系统相册中选择", nil];
    actionSheet.tag = 0;
    [actionSheet showInView:self.view];
}

- (void)clickOnRightButton {
    [self performSegueWithIdentifier:@"ShowUserEdited" sender:self];
}


#pragma mark - ActionSheet delegate
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

#pragma mark - Image Picker Controller delegate methods
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.userChoosePhoto = [self shrinkImage:chosenImage
                                      toSize:_headerView.photoImage.bounds.size];
    
    [self requestUploadTokenFromServer];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}



#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_detailList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = _detailList[section];
    return [arr count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EditedInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:editedInfoCellIdentifier forIndexPath:indexPath];
    NSArray *arr = _detailList[indexPath.section];
    NSDictionary *dic = arr[indexPath.row];
    NSArray *arrUser = _userInfoList[indexPath.section];
    cell.label.text = [dic objectForKey:@"title"];
    
    // 在这里用stringWithFormat是为了防止NSNumber不方便显示的问题
    NSString *str = [NSString stringWithFormat:@"%@", arrUser[indexPath.row]];
    if (str.length) {
        cell.textField.text = str;
    } else {
        cell.textField.placeholder = [dic objectForKey:@"placeholder"];
    }
    
    cell.textField.userInteractionEnabled = NO;
    return cell;

}


- (void)requestUploadTokenFromServer {
    // 请求上传照片的Token
    [MeNetworkUtils requestTokenForUploadTokenWithBucket:bucket andCallback:^(id obj) {
        if (obj) {
            NSDictionary *dic = obj;
            // 在这里errorMessage键传的是Token的值
            NSString *token = [dic objectForKey:@"errorMessage"];
            
            // 把用户选择的照片上传
#ifdef STUDENT_VERSION
            [MeNetworkUtils uploadPhotoToServer:_userChoosePhoto token:token owner:@"student" date:[NSDate date] ownerId:_userInfo.userId andCallback:^(id obj) {
#elif TEACHER_VERSION
                [MeNetworkUtils uploadPhotoToServer:_userChoosePhoto token:token owner:@"teacher" date:[NSDate date] ownerId:_userInfo.userId andCallback:^(id obj) {
#endif
                    NSDictionary *dic = obj;
                    NSString *key = [dic objectForKey:@"key"];
                    [self.userInfo setPhotoPathWithStorageURL:key];
                    
                    // 提交更改用户信息到服务器，告知服务器保存新的图片地址
                    [MeNetworkUtils submitModifiedUserInfo:self.userInfo andCallback:^(id obj) {
                        if (obj) {
                            [UserInfo saveUserInfoToLocal:self.userInfo];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateUserInfo" object:nil];
                            
                            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                            [self.navigationController.view addSubview:HUD];
                            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark"]];
                            // Set custom view mode
                            HUD.mode = MBProgressHUDModeCustomView;
                            HUD.animationType = MBProgressHUDAnimationZoomIn;
                            //HUD.delegate = self;
                            HUD.labelText = @"上传照片成功啦";
                            [HUD show:YES];
                            [HUD hide:YES afterDelay:1.0];
                            
                        }
                    }];
                }];
            }
        }];
}
        


@end
