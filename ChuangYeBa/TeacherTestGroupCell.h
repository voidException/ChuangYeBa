//
//  TeacherTestGroupCell.h
//  ChuangYeBa
//
//  Created by Developer on 15/5/19.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    TestGroupStateUnpublish = 1,
    TestGroupStatepublish,
}TestGroupState;

@class TestGroup;

@class TeacherTestGroupCell;
@protocol TeacherTestGroupDelegate <NSObject>

- (void)teacherTestGroupCell:(TeacherTestGroupCell *)cell clickOnButtonAtIndex:(NSInteger)index;

@end

@interface TeacherTestGroupCell : UITableViewCell

@property (nonatomic) TestGroupState state;

// UI
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *publishButton;
@property (weak, nonatomic) IBOutlet UIButton *resultButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
// Delegate
@property (weak, nonatomic) id <TeacherTestGroupDelegate> delegate;
// DATA
@property (strong, nonatomic) TestGroup *testGroup;

- (IBAction)clickOnPublishButton:(id)sender;
- (IBAction)clickOnResultButton:(id)sender;
- (IBAction)clickOnDeleteButton:(id)sender;

@end
