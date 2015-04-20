//
//  StudyHostViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/2.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "StudyHostViewController.h"

@interface StudyHostViewController ()

@end

@implementation StudyHostViewController


#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    self.dataSource = self;
    
    self.title = @"学习";
    
    // 初始化分类列表的标题
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"studyCategory" ofType:@"plist"];
    self.categoryArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
    
    // 添加ShowStudyDetail的通知接受
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showStudyDetail:) name:@"ShowStudyDetail" object:nil];
    // 配置导航条颜色字体等属性
    [self setNavigationBarAttributes];
}

- (void)setNavigationBarAttributes {
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:44.0/255 green:149.0/255 blue:255.0/255 alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    //self.tabBarController.tabBar.hidden = NO;
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *isUserDidLogin = [ud objectForKey:@"isUserDidLogin"];
    if ([isUserDidLogin isEqualToNumber:[NSNumber numberWithBool:NO]]) {
        [self performSegueWithIdentifier:@"ShowLoginView" sender:self];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 处理通知
- (void)showStudyDetail:(NSNotification *)notification {
    // 接受通知
    self.hidesBottomBarWhenPushed = YES;
    
    [self performSegueWithIdentifier:@"ShowStudyDetail" sender:self];
    self.hidesBottomBarWhenPushed = NO;
    
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return 6;
}
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15.0];
    label.text = self.categoryArray[index];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    
    StudyContentViewController *studyContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StudyContentViewController"];
    studyContentViewController.tag = (NSInteger)index;
    return studyContentViewController;
}

#pragma mark - ViewPagerDelegate
// 设置viewPager的可选设置
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
            break;
        case ViewPagerOptionCenterCurrentTab:
            return 0.0;
            break;
        case ViewPagerOptionTabLocation:
            return 1.0;
            break;
        case ViewPagerOptionTabHeight:
            return 36.0;
            break;
        case ViewPagerOptionTabWidth:
            return 75.0;
            break;
            
        default:
            break;
    }
    
    return value;
}

- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ViewPagerIndicator:
            return [UIColor colorWithRed:44.0/255 green:149.0/255 blue:255.0/255 alpha:1];
            break;
        case ViewPagerTabsView:
            return [UIColor colorWithRed:243.0/255 green:244.0/255 blue:244.0/255 alpha:0.75];
            break;
        default:
            break;
    }
    return color;
}

@end
