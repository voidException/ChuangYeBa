//
//  ClassInfo.m
//  ChuangYeBaDemo
//
//  Created by Developer on 15/3/27.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "ClassInfo.h"

@implementation ClassInfo

@synthesize classNo;
@synthesize classId;
@synthesize universityName;
@synthesize classroomName;
@synthesize teacher;

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self =[super init]) {
        classId = [aDecoder decodeObjectForKey:@"classId"];
        classNo = [aDecoder decodeObjectForKey:@"classNo"];
        universityName = [aDecoder decodeObjectForKey:@"universityName"];
        classroomName = [aDecoder decodeObjectForKey:@"classroomName"];
        teacher = [aDecoder decodeObjectForKey:@"teacher"];
        }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:classId forKey:@"classId"];
    [aCoder encodeObject:classNo forKey:@"classNo"];
    [aCoder encodeObject:universityName forKey:@"universityName"];
    [aCoder encodeObject:classroomName forKey:@"classroomName"];
    [aCoder encodeObject:teacher forKey:@"teacher"];

}

@end
