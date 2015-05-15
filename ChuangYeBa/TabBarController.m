//
//  TabBarController.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/29.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "TabBarController.h"
#import "CustomSegueUnwind.h"

@interface TabBarController ()

@property (weak, nonatomic) IBOutlet UITabBar *mainTabBar;

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITabBarItem *studyItem = [self.mainTabBar.items objectAtIndex:0];
    UITabBarItem *classItem = [self.mainTabBar.items objectAtIndex:1];
    UITabBarItem *moreItem = [self.mainTabBar.items objectAtIndex:2];
    UITabBarItem *meItem = [self.mainTabBar.items objectAtIndex:3];
    [studyItem setImage:[[UIImage imageNamed:@"studyTabIconNormal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [studyItem setSelectedImage:[[UIImage imageNamed:@"studyTabIconSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [classItem setImage:[[UIImage imageNamed:@"classTabIconNormal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [classItem setSelectedImage:[[UIImage imageNamed:@"classTabIconSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [moreItem setImage:[[UIImage imageNamed:@"moreTabIconNormal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [moreItem setSelectedImage:[[UIImage imageNamed:@"moreTabIconSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [meItem setImage:[[UIImage imageNamed:@"meTabIconNormal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [meItem setSelectedImage:[[UIImage imageNamed:@"meTabIconSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIViewController *)viewControllerForUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender {
    return self;
}

- (UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController identifier:(NSString *)identifier {
    
    if ([identifier isEqualToString:@"BackToMain"]) {
        CustomSegueUnwind *unwindSegue = [[CustomSegueUnwind alloc] initWithIdentifier:identifier source:fromViewController destination:toViewController];
        return unwindSegue;
    }
    
    return [super segueForUnwindingToViewController:toViewController fromViewController:fromViewController identifier:identifier];
}

- (IBAction)returnFromSegueAction:(UIStoryboardSegue *)sender {
}



@end
