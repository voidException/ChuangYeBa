//
//  ConditionViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/21.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "ConditionViewController.h"

@interface ConditionViewController ()

@property (nonatomic) BOOL isUserAddedClass;
@property (nonatomic, strong) UIViewController *lastViewController;

@end

@implementation ConditionViewController
@synthesize isUserAddedClass;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarAttributes];
}

- (void)viewWillAppear:(BOOL)animated {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *number = [ud objectForKey:@"isUserAddedClass"];
    if (number == nil) {
        isUserAddedClass = NO;
        self.navigationItem.title = @"加入班级";
    } else {
        isUserAddedClass = [number isEqualToNumber:[NSNumber numberWithBool:YES]];
    }
    if (!isUserAddedClass) {
        self.navigationItem.title = @"加入班级";
        [self performSegueWithIdentifier:@"ShowAddClass" sender:self];
        
    } else {
        self.navigationItem.title = nil;
        [self performSegueWithIdentifier:@"ShowClassMain" sender:self];
        

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method
- (void)setNavigationBarAttributes {
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:44.0/255 green:149.0/255 blue:255.0/255 alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
}


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (segue.destinationViewController != self.lastViewController) {
        [self.lastViewController willMoveToParentViewController:nil];
        [self.lastViewController.view removeFromSuperview];
        [self.lastViewController removeFromParentViewController];
    }
    self.lastViewController = segue.destinationViewController;
}


@end
