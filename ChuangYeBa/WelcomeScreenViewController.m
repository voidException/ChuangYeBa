//
//  WelcomeScreenViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/6/26.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "WelcomeScreenViewController.h"

@interface WelcomeScreenViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;

@end

@implementation WelcomeScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    float screenWidth = self.view.frame.size.width;
    float screenHeight = self.view.frame.size.height;
    _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _scrollView.contentSize = CGSizeMake(4 * screenWidth, screenHeight);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"WelcomeScreen" bundle:nil];
    UIViewController *screen1 = [storyboard instantiateViewControllerWithIdentifier:@"WelcomeScreen1"];
    UIViewController *screen2 = [storyboard instantiateViewControllerWithIdentifier:@"WelcomeScreen2"];
    UIViewController *screen3 = [storyboard instantiateViewControllerWithIdentifier:@"WelcomeScreen3"];
    UIViewController *screen4 = [storyboard instantiateViewControllerWithIdentifier:@"WelcomeScreen4"];
    screen1.view.frame = CGRectMake(0 * screenWidth, 0, screenWidth, screenHeight);
    screen2.view.frame = CGRectMake(1 * screenWidth, 0, screenWidth, screenHeight);
    screen3.view.frame = CGRectMake(2 * screenWidth, 0, screenWidth, screenHeight);
    screen4.view.frame = CGRectMake(3 * screenWidth, 0, screenWidth, screenHeight);
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 132, 35)];
    [button addTarget:self action:@selector(clickOnButton:) forControlEvents:UIControlEventTouchUpInside];
    button.center = CGPointMake(self.view.center.x, screenHeight - 115);
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 15.f;
    button.layer.borderWidth = 1.f;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    [button setTitle:@"立即体验" forState:UIControlStateNormal];
    [screen4.view addSubview:button];
    
    [_scrollView addSubview:screen1.view];
    [_scrollView addSubview:screen2.view];
    [_scrollView addSubview:screen3.view];
    [_scrollView addSubview:screen4.view];
    [self.view addSubview:_scrollView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    _pageControl.center = CGPointMake(self.view.center.x, screenHeight - 20);
    _pageControl.numberOfPages = 4;
    _pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:0.500 alpha:0.500];
    _pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    
    [self.view addSubview:_pageControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _pageControl.currentPage = scrollView.contentOffset.x / self.view.frame.size.width;
}

- (void)clickOnButton:(id)sender {
    
#ifdef STUDENT_VERSION
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStudent" bundle:nil];
#elif TEACHER_VERSION
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainTeacher" bundle:nil];
#endif
    UIViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    [self presentViewController:rootViewController animated:YES completion:nil];
    // 保存当前的版本号
    NSString *key = @"CFBundleShortVersionString";
    NSString *version = [NSBundle mainBundle].infoDictionary[key];
    [[NSUserDefaults standardUserDefaults] setObject:version forKey:key];
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
