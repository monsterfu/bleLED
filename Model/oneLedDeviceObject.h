//
//  oneLedDeviceObject.h
//  bleLED
//
//  Created by Monster on 14-11-16.
//  Copyright (c) 2014年 Monster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalHeader.h"



#define INT_VALUE_KEY           @"int"
#define NAME_VALUE_KEY          @"name"
#define BOOL_VALUE_KEY          @"bool"
#define IDENTIFIER_VALUE_KEY    @"identifier"
#define COLORSET_VALUE_KEY      @"colorset"



@interface oneLedDeviceObject : NSObject

@property(nonatomic, retain)CBPeripheral *peripheral;
@property(nonatomic, retain)CBCharacteristic *characteristic;
@property(nonatomic, retain)CBCharacteristic *characteristic2;
@property(nonatomic, retain)NSString *name;
@property(nonatomic, retain)NSString *identifier;
@property(nonatomic, assign)BOOL open;
@property(nonatomic, assign)BOOL connected;
@property(nonatomic, assign)BOOL isConnecting;

@property(nonatomic, retain)colorSetObject* colorset;

//创建
+(oneLedDeviceObject*) createDeviceObjectWithName:(NSString*)name identifier:(NSString*)identifier;

//开关灯
-(void)open:(BOOL)status;

//设置色温
-(void)setHue:(UIColor*)color;

//设置亮度
-(void)setBrightness:(UIColor*)color;

//首次连接设置默认色值等
-(void)setDefaultValue;

//设置情景模式默认色值
-(void)setDefaultSceneValue:(colorSetObject*)colorset;

//设置色彩
-(void)setCurrentColor:(UIColor*)color brightness:(float)brightness hue:(float)hue;

@end
