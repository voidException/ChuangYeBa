//
//  AnswerSheetCell.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/23.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuizCollectionCell.h"

@interface AnswerSheetCell : UITableViewCell <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *testResultArray;

- (void)reloadData;

@end
