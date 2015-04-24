//
//  AnswerSheetCell.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/23.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "AnswerSheetCell.h"

static NSString *quizCollectionCellIdentifier = @"QuizCollectionCell";

@implementation AnswerSheetCell

- (void)awakeFromNib {
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"QuizCollectionCell" bundle:nil] forCellWithReuseIdentifier:quizCollectionCellIdentifier];
    self.collectionView.bounces = NO;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadData {
    [self.collectionView reloadData];
}


// 这个可以单独封装解析类，不过可以先暂时放在这里
- (BOOL)isUserCorrect:(NSNumber *)testResult {
    NSInteger result = [testResult integerValue];
    if (result%10 == 1) {
        return YES;
    } else {
        return NO;
    }
}


#pragma Collection View Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"选择了题目：%lu", indexPath.row + 1);
}

#pragma Collection View Data Source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.testResultArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QuizCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:quizCollectionCellIdentifier forIndexPath:indexPath];
    NSInteger row = [indexPath row] + 1;
    cell.quizNoLabel.text = [NSString stringWithFormat:@"%lu", row];
    
    NSInteger index = [indexPath row];
    NSDictionary *dic = self.testResultArray[index];
    NSNumber *testResult = [dic objectForKey:@"testresult"];
    if (![self isUserCorrect:testResult]) {
        [cell.imageView setImage:[UIImage imageNamed:@"testResultSheetErrorBG.png"]];
    }

    return cell;
}

@end
