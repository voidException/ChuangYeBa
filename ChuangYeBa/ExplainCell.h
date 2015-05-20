//
//  ExplainCell.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/12.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ExplainCellStateCorrect = 1,
    ExplainCellStateError,
    ExplainCellStateDisplay
}ExplainCellState;

@interface ExplainCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@property (weak, nonatomic) IBOutlet UILabel *anwserLabel;
@property (weak, nonatomic) IBOutlet UITextView *explainTextView;
@property (weak, nonatomic) IBOutlet UILabel *optionLabel;
@property (assign, nonatomic) ExplainCellState state;

- (void)setState:(ExplainCellState)state;

@end
