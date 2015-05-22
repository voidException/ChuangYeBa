//
//  StudyHostViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/2.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "StudyHostViewController.h"
#import "ArticleInfoDAO.h"

@interface StudyHostViewController ()

@property (strong, nonatomic) NSNumber *articleId;
@property (strong, nonatomic) NSMutableArray *contentViewControllers;

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
    [self initUI];
    [self initContentViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *isUserDidLogin = [ud objectForKey:@"isUserDidLogin"];
    if (isUserDidLogin == nil) {
        isUserDidLogin = @NO;
    }
    if ([isUserDidLogin isEqualToNumber:[NSNumber numberWithBool:NO]]) {
        [self performSegueWithIdentifier:@"ShowLoginView" sender:self];
    }
}

#pragma mark - Private Method
- (void)initUI {
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:44.0/255 green:149.0/255 blue:255.0/255 alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}


- (void)initContentViewController{
    self.contentViewControllers = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.categoryArray.count; i++) {
        StudyContentViewController *studyContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StudyContentViewController"];
        NSDictionary *dic = self.categoryArray[i];
        studyContentViewController.tag = [[dic objectForKey:@"tag"] integerValue];
        [self.contentViewControllers addObject:studyContentViewController];
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowStudyDetail"]) {
        id destinationVC = [segue destinationViewController];
        [destinationVC setValue:self.articleId forKey:@"articleId"];
    }
}


#pragma mark - 处理通知
- (void)showStudyDetail:(NSNotification *)notification {
    // 接受通知
    self.articleId = [notification.userInfo objectForKey:@"articleId"];
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
    if ([[UIScreen mainScreen] bounds].size.width == 320) {
        label.font = [UIFont systemFontOfSize:13.0];
        
    } else {
        label.font = [UIFont systemFontOfSize:15.0];
    }
    
    NSDictionary *dic = self.categoryArray[index];
    label.text = [dic objectForKey:@"title"];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:109.0/255 green:109.0/255 blue:109.0/255 alpha:1];
    [label sizeToFit];
    return label;
}

- (UIView *)viewPager:(ViewPagerController *)viewPager activeViewForTabAtIndex:(NSUInteger)index {
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    if ([[UIScreen mainScreen] bounds].size.width == 320) {
        label.font = [UIFont systemFontOfSize:16.0];
        
    } else {
        label.font = [UIFont systemFontOfSize:18.0];
    }
    NSDictionary *dic = self.categoryArray[index];
    label.text = [dic objectForKey:@"title"];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:44.0/255 green:149.0/255 blue:255.0/255 alpha:1];
    [label sizeToFit];
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    return [self.contentViewControllers objectAtIndex:index];
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
            if ([[UIScreen mainScreen] bounds].size.width == 320) {
                return 35.0;
            } else {
                return 43.0;
            }
            break;
        case ViewPagerOptionTabWidth:
            if ([[UIScreen mainScreen] bounds].size.width == 320) {
                return 64.0;
            } else {
                return 75.0;
            }
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
