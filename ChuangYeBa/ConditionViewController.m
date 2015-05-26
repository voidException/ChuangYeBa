//
//  ConditionViewController.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/21.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "ConditionViewController.h"
#import "UserInfo.h"

@interface ConditionViewController ()

@property (nonatomic) BOOL isUserAddedClass;
@property (nonatomic, strong) UIViewController *lastViewController;
@property (nonatomic, strong) UserInfo *userInfo;

@end

@implementation ConditionViewController
@synthesize isUserAddedClass;
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    self.userInfo = [[UserInfo alloc] initWithUserDefault];
    if ([_userInfo.roomno isEqual:@"0"]) {
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

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (segue.destinationViewController != self.lastViewController) {
        [self.lastViewController willMoveToParentViewController:nil];
        [self.lastViewController.view removeFromSuperview];
        [self.lastViewController removeFromParentViewController];
    }
    self.lastViewController = segue.destinationViewController;
}


@end
