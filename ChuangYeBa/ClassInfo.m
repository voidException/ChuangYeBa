//
//  ClassInfo.m
//  ChuangYeBaDemo
//
//  Created by Developer on 15/3/27.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "ClassInfo.h"

@implementation ClassInfo

+ (ClassInfo *)loadClassInfoFromLocal {
    ClassInfo *classInfo = [[ClassInfo alloc] init];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *udObject = [ud objectForKey:@"classInfo"];
    classInfo = [NSKeyedUnarchiver unarchiveObjectWithData:udObject];
    return classInfo;
}

// 保存用户信息到本地
+ (void)saveClassInfoToLocal:(ClassInfo *)classInfo {
    if (classInfo) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSData *udObject = [NSKeyedArchiver archivedDataWithRootObject:classInfo];
        [ud setObject:udObject forKey:@"classInfo"];
        [ud synchronize];
    } else {
        
    }
}

// 删除本地的用户信息
/*
+ (void)deleteUserInfoFromLocal {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:@"classInfo"];
    [ud synchronize];
}
*/

#pragma mark - Setter
- (void)setPhotoPath:(NSString *)photoPath {
    if ([photoPath class] == [NSNull class]) {
        _photoPath = @"";
    } else {
        _photoPath = photoPath;
    }
    
}

- (void)setUniversityName:(NSString *)universityName {
    if ([universityName class] == [NSNull class]) {
        _universityName = @"";
    } else {
        _universityName = universityName;
    }
}

- (void)setStudentNum:(NSNumber *)studentNum {
    if ([studentNum class] == [NSNull class]) {
        _studentNum = @0;
    } else {
        _studentNum = studentNum;
    }
}

- (void)setRealStudentNum:(NSNumber *)realStudentNum {
    if ([realStudentNum class] == [NSNull class]) {
        _realStudentNum = @0;
    } else {
        _realStudentNum = realStudentNum;
    }
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self =[super init]) {
        self.classId = [aDecoder decodeObjectForKey:@"classId"];
        self.classNo = [aDecoder decodeObjectForKey:@"classNo"];
        self.universityName = [aDecoder decodeObjectForKey:@"universityName"];
        self.universityNo = [aDecoder decodeObjectForKey:@"universityNo"];
        self.classroomName = [aDecoder decodeObjectForKey:@"classroomName"];
        self.teacher = [aDecoder decodeObjectForKey:@"teacher"];
        self.photoPath = [aDecoder decodeObjectForKey:@"classPhotoPath"];
        self.studentNum = [aDecoder decodeObjectForKey:@"studentNum"];
        self.realStudentNum = [aDecoder decodeObjectForKey:@"realStudentNum"];
        }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.classId forKey:@"classId"];
    [aCoder encodeObject:self.classNo forKey:@"classNo"];
    [aCoder encodeObject:self.universityName forKey:@"universityName"];
    [aCoder encodeObject:self.universityNo forKey:@"universityNo"];
    [aCoder encodeObject:self.classroomName forKey:@"classroomName"];
    [aCoder encodeObject:self.teacher forKey:@"teacher"];
    [aCoder encodeObject:self.photoPath forKey:@"classPhotoPath"];
    [aCoder encodeObject:self.studentNum forKey:@"studentNum"];
    [aCoder encodeObject:self.realStudentNum forKey:@"realStudentNum"];
}

#pragma mark - Copying delegate
- (id)copyWithZone:(NSZone *)zone {
    ClassInfo *copy = [[[self class] allocWithZone:zone] init];
    copy.classId = self.classId;
    copy.classNo = self.classNo;
    copy.universityName = self.universityName;
    copy.universityNo = self.universityNo;
    copy.classroomName = self.classroomName;
    copy.teacher = self.teacher;
    copy.photoPath = self.photoPath;
    copy.studentNum = self.studentNum;
    copy.realStudentNum = self.realStudentNum;
    return copy;
}

@end
