//
//  ClassInfo.h
//  ChuangYeBaDemo
//
//  Created by Developer on 15/3/27.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

@interface ClassInfo : NSObject <NSCopying>

@property (nonatomic, strong) UserInfo *teacher;
// 表中的
@property (nonatomic, copy) NSString *classroomName;
@property (nonatomic, copy) NSNumber *studentNum;
@property (nonatomic, copy) NSNumber *realStudentNum;
@property (nonatomic, copy) NSString *universityNo;
@property (nonatomic, copy) NSString *universityName;
@property (nonatomic, copy) NSString *photoPath;

// 重要，唯一自动生成的班级号
@property (nonatomic, strong) NSNumber *classNo;

@property (nonatomic, strong) NSNumber *classId;

+ (ClassInfo *)loadClassInfoFromLocal;

+ (void)saveClassInfoToLocal:(ClassInfo *)classInfo;

+ (void)deleteClassInfoFromLocal;

- (void)setPhotoPathWithStorageURL:(NSString *)key;

@end
