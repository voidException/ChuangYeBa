//
//  ClassSettingViewController.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/3.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassInfoCell.h"

@interface ClassSettingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ClassInfoCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
