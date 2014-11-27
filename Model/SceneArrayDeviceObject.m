//
//  SceneArrayDeviceObject.m
//  bleLED
//
//  Created by Monster on 14-11-22.
//  Copyright (c) 2014年 Monster. All rights reserved.
//

#import "SceneArrayDeviceObject.h"

#define NAME_VALUE_KEY                  @"name"
#define COLORSET_VALUE_KEY              @"colorset"
#define DEVICEARRAY_VALUE_KEY           @"deviceArray"

@implementation SceneArrayDeviceObject

+(SceneArrayDeviceObject*)createWithName:(NSString*)name
{
    SceneArrayDeviceObject* sceneArrayDeviceObject = [[SceneArrayDeviceObject alloc]init];
    sceneArrayDeviceObject.name = name;
    sceneArrayDeviceObject.deviceArray = [NSMutableArray array];
    sceneArrayDeviceObject.colorSet = [colorSetObject createWithInit];
    return sceneArrayDeviceObject;
}

-(void)setDefaultValue
{
    for (_device in self.deviceArray) {
        [_device setDefaultSceneValue:self.colorSet];
    }
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_name forKey:NAME_VALUE_KEY];
    [aCoder encodeObject:_colorSet forKey:COLORSET_VALUE_KEY];
    [aCoder encodeObject:_deviceArray forKey:DEVICEARRAY_VALUE_KEY];
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]){
        _name  = [aDecoder decodeObjectForKey:NAME_VALUE_KEY];
        _colorSet  = [aDecoder decodeObjectForKey:COLORSET_VALUE_KEY];
        _deviceArray = [aDecoder decodeObjectForKey:DEVICEARRAY_VALUE_KEY];
    }
    return self;
}
@end
