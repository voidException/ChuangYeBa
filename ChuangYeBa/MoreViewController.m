//
//  MoreViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/3.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "MoreViewController.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"更多";
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    NSLog(@"width = %f, h = %f", size.width, size.height);
    
    // 怎么简化这样的代码
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOnImageView)];
    UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOnImageView)];
    UITapGestureRecognizer *singleTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOnImageView)];
    UITapGestureRecognizer *singleTap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOnImageView)];
    UITapGestureRecognizer *singleTap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOnImageView)];
    UITapGestureRecognizer *singleTap6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOnImageView)];
    UITapGestureRecognizer *singleTap7 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOnImageView)];
    self.imageViewL.userInteractionEnabled = YES;
    [self.imageViewL addGestureRecognizer:singleTap1];
    self.imageViewM.userInteractionEnabled = YES;
    [self.imageViewM addGestureRecognizer:singleTap2];
    self.imageViewR.userInteractionEnabled = YES;
    [self.imageViewR addGestureRecognizer:singleTap3];
    self.imageViewLong.userInteractionEnabled = YES;
    [self.imageViewLong addGestureRecognizer:singleTap4];
    self.imageViewLeftTop.userInteractionEnabled = YES;
    [self.imageViewLeftTop addGestureRecognizer:singleTap5];
    self.imageViewRightTop.userInteractionEnabled = YES;
    [self.imageViewRightTop addGestureRecognizer:singleTap6];
    self.imageViewLeftDown.userInteractionEnabled = YES;
    [self.imageViewLeftDown addGestureRecognizer:singleTap7];
    
    /*
    NSArray *arr = [[NSArray alloc] initWithObjects:self.imageViewL,self.imageViewM,self.imageViewR,self.imageViewLong,self.imageViewLeftTop,self.imageViewRightTop,self.imageViewLeftDown, nil];
     不知道为什么这样不可以设置
    for (int i; i < arr.count; i++) {
        UIImageView *iv = arr[i];
        NSLog(@"w = %f, h = %f", iv.bounds.size.width, iv.bounds.size.height);
        iv.userInteractionEnabled = YES;
        [iv addGestureRecognizer:singleTap];
    }
     */
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickOnImageView {
    NSLog(@"click On image V");
    [self performSegueWithIdentifier:@"ShowMoreDetail" sender:self];
}

- (IBAction)changPage:(id)sender {
    [UIView animateWithDuration:0.3f animations:^{
        NSInteger whichPage = self.pageControll.currentPage;
        self.insideScrollView.contentOffset = CGPointMake(self.insideScrollView.frame.size.width * whichPage, 0.0f);
    }];
}

#pragma mark - Scroll View Delegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    self.pageControll.currentPage = offset.x / self.insideScrollView.frame.size.width;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
