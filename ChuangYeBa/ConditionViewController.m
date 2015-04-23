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

@end

@implementation ConditionViewController
@synthesize isUserAddedClass;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *number = [ud objectForKey:@"isUserAddedClass"];
    if (number == nil) {
        isUserAddedClass = NO;
    } else {
        isUserAddedClass = [number isEqualToNumber:[NSNumber numberWithBool:YES]];
    }
    if (!isUserAddedClass) {
        [self performSegueWithIdentifier:@"ShowAddClass" sender:self];
    } else {
        [self performSegueWithIdentifier:@"ShowClassMain" sender:self];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
