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
@synthesize teacherName;
@synthesize classroomName;

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self =[super init]) {
        classId = [aDecoder decodeObjectForKey:@"classId"];
        classNo = [aDecoder decodeObjectForKey:@"classNo"];
        universityName = [aDecoder decodeObjectForKey:@"universityName"];
        teacherName = [aDecoder decodeObjectForKey:@"teacherName"];
        classroomName = [aDecoder decodeObjectForKey:@"classroomName"];
        
        }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:classId forKey:@"classId"];
    [aCoder encodeObject:classNo forKey:@"classNo"];
    [aCoder encodeObject:universityName forKey:@"universityName"];
    [aCoder encodeObject:teacherName forKey:@"teacherName"];
    [aCoder encodeObject:classroomName forKey:@"classroomName"];

}

@end
