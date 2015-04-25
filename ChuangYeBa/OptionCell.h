//
//  NewOptionCell.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/11.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    OptionCellStateUnselected = 1, // 普通闲置状态
    OptionCellStateSelected, // 正在刷新中的状态
    OptionCellStateCorrect,
    OptionCellStateError,
    OptionCellStateUnable// 所有数据加载完毕，没有更多的数据了
} OptionCellState;

@interface OptionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *checkImage;
@property (weak, nonatomic) IBOutlet UILabel *checkLabel;
@property (nonatomic) OptionCellState state;

- (void)setState:(OptionCellState)state;

@end
