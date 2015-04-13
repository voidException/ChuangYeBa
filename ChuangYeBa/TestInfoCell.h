//
//  TestInfoCell.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/3.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TestInfoCell;

@protocol TestInfoCellDelegate
- (void) clickOnTestAndResultButton: (TestInfoCell *)testInfoCell;
@end

@interface TestInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *testImage;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *awards;
@property (weak, nonatomic) IBOutlet UITextField *introduction;
@property (weak, nonatomic) IBOutlet UIButton *testAndResultButton;
@property (weak, nonatomic) id <TestInfoCellDelegate> delegate;


- (IBAction)clickOnTestAndResultButton:(id)sender;

@end
