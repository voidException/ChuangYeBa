//
//  ClassInfo.h
//  ChuangYeBaDemo
//
//  Created by Developer on 15/3/27.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassInfo : NSObject
// 非表中的
@property (nonatomic, copy) NSString *teacherName;
// 表中的
@property (nonatomic, copy) NSString *classroomName;
@property (nonatomic, copy) NSString *studentNum;
@property (nonatomic, copy) NSString *realStudentNum;
@property (nonatomic, copy) NSString *universityNo;
@property (nonatomic, copy) NSString *universityName;
@property (nonatomic, copy) NSString *photo;
// 重要，唯一自动生成的班级号
@property (nonatomic, strong) NSNumber *classNo;

@property (nonatomic, strong) NSNumber *classId;

@end
