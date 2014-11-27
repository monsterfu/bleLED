//
//  SceneArrayDeviceObject.h
//  bleLED
//
//  Created by Monster on 14-11-22.
//  Copyright (c) 2014年 Monster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "oneLedDeviceObject.h"
#import "colorSetObject.h"

@interface SceneArrayDeviceObject : NSObject
{
    oneLedDeviceObject* _device;
}
@property(nonatomic, retain)NSMutableArray* deviceArray;
@property(nonatomic, retain)colorSetObject* colorSet;
@property(nonatomic, retain)NSString* name;


+(SceneArrayDeviceObject*)createWithName:(NSString*)name;
//首次连接设置默认情景模式色值
-(void)setDefaultValue;
@end
