//
//  AnswerSheetCell.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/23.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuizCollectionCell.h"

@class AnswerSheetCell;

@protocol AnswerSheetDelegate

- (void)answerSheet:(AnswerSheetCell *)answerSheet didSelectedAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface AnswerSheetCell : UITableViewCell <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *testResultArray;

@property (weak, nonatomic) id <AnswerSheetDelegate> delegate;


- (void)reloadData;

@end
