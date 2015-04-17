//
//  UserEditedViewController.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/4.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "EditedInfoCell.h"
#import "EditedPhotoCell.h"
#import "UserInfo.h"
#import "LoginNetworkUtils.h"

@interface UserEditedViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (copy, nonatomic) NSDictionary *editedTitleSection;
@property (copy, nonatomic) NSArray *editedTitleRow;
@property (nonatomic, strong) NSMutableArray *textFieldArray;
@property (nonatomic, strong) NSMutableArray *photoArray;
@property (nonatomic, strong) UIImage *userChoosePhoto;
@property (nonatomic, strong) NSMutableArray *userInfoArray;
@property (nonatomic, strong) UserInfo *userInfo;

- (void) loadUserInfo;
- (void) saveUserInfo;
- (void) updateDisplay;

@end
