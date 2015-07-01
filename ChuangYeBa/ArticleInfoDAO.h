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

/**
 *  文章信息数据访问对象
 *
 *  @return 文章数据访问对象单例
 */
+ (ArticleInfoDAO *)shareManager;

/**
 *  插入文章列表
 *
 *  @param articleList 待保存的文章列表数组
 *  @param fileName    保存的文件名称
 */
- (void)create:(NSMutableArray *)articleList flieName:(NSString *)fileName;

/**
 *  删除文章列表
 *
 *  @param fileName 文件名称
 */
- (void)clean:(NSString *)fileName;

/**
 *  查询所有数据
 *
 *  @param fileName 文件名称
 *
 *  @return 文章列表Array
 */
- (NSMutableArray *)findAll:(NSString *)fileName;

@end
