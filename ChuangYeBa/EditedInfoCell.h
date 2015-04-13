//
//  EditedInfoCell.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/4.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditedInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *label;
- (IBAction)didEndOnExit:(id)sender;

@end
