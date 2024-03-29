//
//  SAMenuTable.h
//  NavigationMenu
//
//  Created by Ivan Sapozhnik on 2/19/13.
//  Copyright (c) 2013 Ivan Sapozhnik. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SIMenuDelegate <NSObject>
- (void)didBackgroundTap;
- (void)clickOnFooterButton;
- (void)didSelectItemAtIndex:(NSUInteger)index;
@end

@interface SIMenuTable : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id <SIMenuDelegate> menuDelegate;
@property (nonatomic, strong) NSArray *items;

- (id)initWithFrame:(CGRect)frame items:(NSArray *)items;
- (void)reloadData;
- (void)show;
- (void)hide;

@end
