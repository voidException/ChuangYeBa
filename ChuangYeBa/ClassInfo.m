//
//  ClassInfo.m
//  ChuangYeBaDemo
//
//  Created by Developer on 15/3/27.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "ClassInfo.h"

@implementation ClassInfo


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

@end
