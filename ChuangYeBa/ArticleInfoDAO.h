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


//插入Note方法
- (int)create:(NSMutableArray *)model tag:(NSInteger)tag;

//删除Note方法
- (int)clean;

//查询所有数据方法
- (NSMutableArray *)findAll:(NSInteger)tag;

@end
