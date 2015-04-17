//
//  ArticleInfo.h
//  ChuangYeBa
//
//  Created by Developer on 15/4/16.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define screenWidth [UIScreen mainScreen].bounds.size.width

@interface ArticleInfo : NSObject

@property (copy, nonatomic) NSString *articleId;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *viceTitle;
@property (copy, nonatomic) NSString *miniPhotoURL;
@property (copy, nonatomic) NSString *realURL;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *articleType;
@property (copy, nonatomic) NSString *labelOne;
@property (copy, nonatomic) NSString *labelTwe;
@property (copy, nonatomic) NSString *comments;
@property (copy, nonatomic) NSString *likes;
@property (copy, nonatomic) NSString *collects;
@property (strong, nonatomic) NSDate *publishDate;
- (float)getHeightOfArticleString:(NSString *)string fontOfSize:(NSUInteger)fontOfSize;

@end
