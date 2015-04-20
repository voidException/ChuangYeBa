//
//  UserEditedViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/4.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "UserEditedViewController.h"

@interface UserEditedViewController ()

@end

@implementation UserEditedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人信息";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // 读取设置的数据
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"setting" ofType:@"plist"];
    self.editedTitleSection = [[NSDictionary alloc]initWithContentsOfFile:path];
    self.editedTitleRow = [[self.editedTitleSection allKeys] sortedArrayUsingSelector:
                          @selector(compare:)];
    
    // 初始化数组
    self.textFieldArray = [NSMutableArray array];
    self.photoArray = [NSMutableArray array];
    
    // 读取存储在UserDefault中的用户的基本信息
    [self loadUserInfo];
    
    // 初始化Navigation Bar右侧的完成按钮
    UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(clickedOnDoneButton)];
    self.navigationItem.rightBarButtonItem = button;
    
    // 注册键盘弹出响应的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];


}

- (void)viewWillAppear:(BOOL)animated {
    // 用户在相册或者通过相机更新照片后更新视图
    if (self.photoArray.count != 0) {
        [self updateDisplay];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(CGFloat)keyboardEndingFrameHeight:(NSDictionary *)userInfo//计算键盘的高度
{
    CGRect keyboardEndingUncorrectedFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGRect keyboardEndingFrame = [self.view convertRect:keyboardEndingUncorrectedFrame fromView:nil];
    return keyboardEndingFrame.size.height;
}

// 键盘出现后调整视图
-(void)keyboardWillAppear:(NSNotification *)notification
{
    CGRect currentFrame = self.view.frame;
    CGFloat change = [self keyboardEndingFrameHeight:[notification userInfo]];
    currentFrame.size.height = currentFrame.size.height - change;
    self.view.frame = currentFrame;
}

// 键盘消失后调整视图
-(void)keyboardWillDisappear:(NSNotification *)notification
{
    CGRect currentFrame = self.view.frame;
    CGFloat change = [self keyboardEndingFrameHeight:[notification userInfo]];
    currentFrame.size.height = currentFrame.size.height + change;
    self.view.frame = currentFrame;
}


// 读取存储在UserDefault中的用户的基本信息
- (void)loadUserInfo {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    self.userInfo = [[UserInfo alloc]init];
    NSData *udObject = [ud objectForKey:@"userInfo"];
    self.userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:udObject];
    
    NSMutableArray *section1 = [[NSMutableArray alloc] init];
    NSMutableArray *section2 = [[NSMutableArray alloc] init];
    NSMutableArray *section3 = [[NSMutableArray alloc] init];
    
    // SECTION1
    if (self.userInfo.name) [section1 addObject:self.userInfo.name];
    else [section1 addObject:@"NO_VALUE"];
    // SECTION2
    if (self.userInfo.name) [section2 addObject:self.userInfo.name];
    else [section2 addObject:@"NO_VALUE"];
    if (self.userInfo.sex) [section2 addObject:self.userInfo.sex];
    else [section2 addObject:@"NO_VALUE"];
    if (self.userInfo.userNo) [section2 addObject:self.userInfo.userNo];
    else [section2 addObject:@"NO_VALUE"];
    if (self.userInfo.email) [section2 addObject:self.userInfo.email];
    else [section2 addObject:@"NO_VALUE"];
    // SECTION3
    if (self.userInfo.school) [section3 addObject:self.userInfo.school];
    else [section3 addObject:@"NO_VALUE"];
    if (self.userInfo.major) [section3 addObject:self.userInfo.major];
    else [section3 addObject:@"NO_VALUE"];
    
    /*
    NSMutableArray *section1 = [[NSMutableArray alloc] initWithObjects:self.userInfo.name, nil];
    NSMutableArray *section2 = [[NSMutableArray alloc] initWithObjects:self.userInfo.name, self.userInfo.sex, self.userInfo.userNo, self.userInfo.email, nil];
    NSMutableArray *section3 = [[NSMutableArray alloc] initWithObjects:self.userInfo.school, self.userInfo.major, nil];
     */
    self.userInfoArray = [[NSMutableArray alloc] initWithObjects: section1, section2, section3, nil];
}

// 提交用户修改的基本信息，并存储到UserDefault中
- (void)saveUserInfo {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i<self.textFieldArray.count; i++) {
        UITextField *tf=self.textFieldArray[i];
        [arr addObject:tf.text];
        //NSLog(@"%@",tf.text);
    }
    self.userInfo.name = arr[1];
    self.userInfo.sex = arr[2];
    self.userInfo.userNo = arr[3];
    self.userInfo.email = arr[4];
    self.userInfo.school = arr[5];
    self.userInfo.major = arr[6];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *udObject = [NSKeyedArchiver archivedDataWithRootObject:self.userInfo];
    [ud setObject:udObject forKey:@"userInfo"];
    [ud synchronize];

}

// 用户在相册或者通过相机更新照片后更新视图
- (void)updateDisplay {
    UIImageView *imageView = self.photoArray[0];
    imageView.image = self.userChoosePhoto;
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


// 用户点击完成键的动作
- (void)clickedOnDoneButton {
    
    /*
    [NetworkUtils subbmitEditedUserInfo:self.userInfo andCallback:^(id obj) {
        NSLog(@"成功callback");
     }];
    */
    // 保存是否成功取决于服务器是否返回保存成功的值，在这里假设为保存成功YES
    BOOL isSaveSucceed = YES;
    // 如果保存成功则返回上一级菜单
    if (isSaveSucceed) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

# pragma mark - TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *groupName = [self.editedTitleRow objectAtIndex:section];
    NSArray *temp = [self.editedTitleSection objectForKey:groupName];
    //NSLog(@"section = %lu have %lu rows", section, [temp count]);
    return [temp count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.editedTitleRow count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 80;
    }else {
        return 44;
    }
}

// 点击修改照片的响应
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从系统相册中选择", nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showInView:self.view];
    }
}


#pragma mark - TableViewDataSourceDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *editedInfoCellIndentifier = @"EditedInfoCell";
    static NSString *editedPhotoCellIndentifier = @"EditedPhotoCell";
    
    
    if (indexPath.section == 0) {
        // 创建编辑照片的cell
        EditedPhotoCell *photoCell = [tableView dequeueReusableCellWithIdentifier:editedPhotoCellIndentifier forIndexPath:indexPath];
        [photoCell.photoImage setImage:[UIImage imageNamed:@"France.png"]];
        UIImageView *imageView = photoCell.photoImage;
        [self.photoArray addObject:imageView];
        photoCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return photoCell;
        
    } else {
        // 创建编辑用户信息的cell
        EditedInfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:editedInfoCellIndentifier forIndexPath:indexPath];
        
        // 给cell中label文字赋值
        NSString *key = self.editedTitleRow[indexPath.section];
        NSArray *nameSection = self.editedTitleSection[key];
        infoCell.label.text = nameSection[indexPath.row];
        
        // 给cell中的textFied赋值（给出用户之前的值，从NSUserDefault中读取）
        NSMutableArray *valueSection = self.userInfoArray[indexPath.section - 1];
        infoCell.textField.text = valueSection[indexPath.row];
        
        // 设置cell的侧边附件类型
        infoCell.accessoryType = UITableViewCellAccessoryNone;
        
        // TODO 设置创建cell中textField映射的数目。（当创建足够的映射后不再创建）
        // 在这里只能用固定值7去手动设置总共可以编辑的数目。需要找办法去计算出这个值。
        if (self.textFieldArray.count < 7) {
            UITextField *textField = infoCell.textField;
            [self.textFieldArray addObject:textField];
        }
        return infoCell;
    }
}

#pragma mark - actionSheetDelegate
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
    UIImageView *imageView = self.photoArray[0];
    self.userChoosePhoto = [self shrinkImage:chosenImage
                                      toSize:imageView.bounds.size];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}




@end
