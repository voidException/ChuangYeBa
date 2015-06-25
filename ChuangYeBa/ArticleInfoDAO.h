//
//  ArticleInfoDAO.h
//  ChuangYeBa
//
//  Created by Developer on 15/5/6.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArticleInfo.h"

@interface ArticleInfoDAO : NSObject

+ (ArticleInfoDAO *)shareManager;


//插入Article方法
- (void)create:(NSMutableArray *)articleList flieName:(NSString *)fileName;

//删除Article方法
- (void)clean:(NSString *)fileName;

//查询所有数据方法
- (NSMutableArray *)findAll:(NSString *)fileName;

@end
