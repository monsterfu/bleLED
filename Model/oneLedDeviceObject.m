//
//  oneLedDeviceObject.m
//  bleLED
//
//  Created by Monster on 14-11-16.
//  Copyright (c) 2014年 Monster. All rights reserved.
//

#import "oneLedDeviceObject.h"

@implementation oneLedDeviceObject


//创建
+(oneLedDeviceObject*) createDeviceObjectWithName:(NSString*)name identifier:(NSString*)identifier
{
    oneLedDeviceObject* device = [[oneLedDeviceObject alloc]init];
    device.name = name;//[name stringByAppendingString:[identifier substringToIndex:4]];
    device.isConnecting = NO;
    device.connected = NO;
    device.open = NO;
    
    device.colorset = [colorSetObject createWithInit];
    return device;
}

//开关灯
-(void)open:(BOOL)status
{
    if (status) {
        unsigned char command[9] = {0x55,0x04,0x00,0x01,0x01,0x22,0xDC,0xAA};
        NSData* lookdata = [[NSData alloc]initWithBytes:command length:8];
        if (_characteristic) {
            [_peripheral writeValue:lookdata forCharacteristic:_characteristic type:CBCharacteristicWriteWithResponse];
        }
        
    }else{
        
        unsigned char command[12] = {0x55,0x08,0x00,0x01,0x00,0x00, 0x00,0x00,0x00,0x00, 0xFF,0xAA};
        NSData* lookdata = [[NSData alloc]initWithBytes:command length:12];
        if (_characteristic) {
            [_peripheral writeValue:lookdata forCharacteristic:_characteristic type:CBCharacteristicWriteWithResponse];
        }
    }
}

//设置色温
-(void)setHue:(UIColor*)color
{
    
}

//设置亮度
-(void)setBrightness:(UIColor*)color
{
    
}

-(void)setDefaultValue
{
    NSData* colorData = [self.colorset dataCommondWithDefaultValue];
    NSLog(@"setColor , data :%@", colorData);
    if (_characteristic) {
        [_peripheral writeValue:colorData forCharacteristic:_characteristic type:CBCharacteristicWriteWithResponse];
    }
}
-(void)setDefaultSceneValue:(colorSetObject*)colorset
{
    NSData* colorData = [colorset dataCommondWithDefaultValue];
    NSLog(@"setColor , data :%@", colorData);
    if (_characteristic) {
        [_peripheral writeValue:colorData forCharacteristic:_characteristic type:CBCharacteristicWriteWithResponse];
    }
}
//设置色彩
-(void)setCurrentColor:(UIColor*)color brightness:(float)brightness hue:(float)hue
{
    NSData* colorData = [self.colorset dataCommondWithColor:color brightness:brightness hue:hue];
    NSLog(@"setColor , data :%@", colorData);
    if (_characteristic) {
        [_peripheral writeValue:colorData forCharacteristic:_characteristic type:CBCharacteristicWriteWithResponse];
    };
}

-(void)setDeviceName:(NSString*)name
{
    NSData* nameData = [name dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger len = nameData.length;
    unsigned char command[30];
    memset(command, 0, 30);
    command[0] = 0x55;
    command[1] = len+2;
    command[2] = 0;
    command[3] = 4;
    int total = 4;
    
    
    Byte *nameByte = (Byte *)[nameData bytes];
    for(int i = 0; i < len; i++)
    {
        command[4 +i] = nameByte[i];
        total += nameByte[i];
    }
    command[4 + len] = 256 - total%256;
    command[4 + len +1] = 0xAA;
    
//    unsigned char command1[30] = {0x55, 0x0E, 0x00, 0x04, 0xe5 , 0xae , 0xa2 , 0xe5 , 0x8e , 0x85 , 0xe4 , 0xb8 , 0xad , 0xe9 , 0x97 , 0xb4 , 0x52, 0xAA};
//    NSData* lookdata = [[NSData alloc]initWithBytes:command1 length:18];
    NSData* lookdata = [[NSData alloc]initWithBytes:command length:4 + len +2];
    if (_characteristic) {
        [_peripheral writeValue:lookdata forCharacteristic:_characteristic type:CBCharacteristicWriteWithResponse];
    }
}
#pragma mark --



#pragma mark ---
#pragma mark ---  Encode

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_name forKey:NAME_VALUE_KEY];
    [aCoder encodeBool:_open forKey:BOOL_VALUE_KEY];
    [aCoder encodeObject:_identifier forKey:IDENTIFIER_VALUE_KEY];
    [aCoder encodeObject:_colorset forKey:COLORSET_VALUE_KEY];
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]){
        _name  = [aDecoder decodeObjectForKey:NAME_VALUE_KEY];
        _open  = [aDecoder decodeBoolForKey:BOOL_VALUE_KEY];
        _identifier = [aDecoder decodeObjectForKey:IDENTIFIER_VALUE_KEY];
        _colorset = [aDecoder decodeObjectForKey:COLORSET_VALUE_KEY];
    }
    return self;
}
@end
