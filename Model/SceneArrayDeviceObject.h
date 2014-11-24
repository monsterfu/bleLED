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

@property(nonatomic, retain)NSMutableArray* deviceArray;
@property(nonatomic, retain)colorSetObject* colorSet;
@property(nonatomic, retain)NSString* name;


+(SceneArrayDeviceObject*)createWithName:(NSString*)name;

@end
