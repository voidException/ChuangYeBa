//
//  MoreViewController.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/3.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreViewController : UIViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *insideScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControll;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewLong;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewLeftTop;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewRightTop;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewLeftDown;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewL;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewM;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewR;

- (IBAction)changPage:(id)sender;

@end
