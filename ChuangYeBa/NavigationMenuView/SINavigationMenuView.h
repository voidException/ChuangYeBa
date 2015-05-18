//
//  SINavigationMenuView.h
//  NavigationMenu
//
//  Created by Ivan Sapozhnik on 2/19/13.
//  Copyright (c) 2013 Ivan Sapozhnik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIMenuTable.h"

@protocol SINavigationMenuDelegate <NSObject>

- (void)didSelectItemAtIndex:(NSUInteger)index;
- (void)clickOnMenuButtonAtActiveState:(BOOL)isActive;
- (void)clickOnFooterButton;

@end

@interface SINavigationMenuView : UIView <SIMenuDelegate>

@property (nonatomic, weak) id <SINavigationMenuDelegate> delegate;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) SIMenuTable *table;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title;
- (void)displayMenuInView:(UIView *)view;


- (void)onHandleMenuTap:(id)sender;
- (void)onHideMenu;

@end
