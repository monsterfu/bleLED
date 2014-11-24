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
+(oneLedDeviceObject*) createDeviceObjectWithName:(NSString*)name
{
    oneLedDeviceObject* device = [[oneLedDeviceObject alloc]init];
    device.name = name;
    device.isConnecting = NO;
    device.connected = NO;
    device.open = NO;
    
    device.colorset = [colorSetObject createWithInit];
    return device;
}

//开关灯
-(void)open:(BOOL)status
{
    unsigned char command1[20] = {0x55,0x08,0x00,0x01,0x01,  0x01,0x01,0x01,0x01,0x01,0xF9,0xAA};
    if (status) {
        unsigned char command[9] = {0x55,0x04,0x00,0x01,0x01,0x22,0xDC,0xAA};
        NSData* lookdata = [[NSData alloc]initWithBytes:command length:8];
        [_peripheral writeValue:lookdata forCharacteristic:_characteristic type:CBCharacteristicWriteWithResponse];
        //[_peripheral writeValue:lookdata forCharacteristic:_characteristic2 type:CBCharacteristicWriteWithoutResponse];
    }else{
        unsigned char command[9] = {0x55,0x04,0x00,0x00,0x00,0x01,0xFF,0xAA};
        NSData* lookdata = [[NSData alloc]initWithBytes:command1 length:12];
        [_peripheral writeValue:lookdata forCharacteristic:_characteristic type:CBCharacteristicWriteWithResponse];
        //[_peripheral writeValue:lookdata forCharacteristic:_characteristic2 type:CBCharacteristicWriteWithoutResponse];
    }
    
//    unsigned char arrayOfByte[] = { 0x55, 8, 0, 1, 1,
//        0xFF, 0xFF, 0xFF,0xFF,
//        0xFF, 0, 0xAA};
//    switch (currentMode) {
//        case BR_MODE:
//            // for lightness
//            arrayOfByte[5] = (byte) (currentLightness & 0xff);
//            break;
//        case CT_MODE:
//            // // for CT
//            arrayOfByte[6] = (byte) (currentDim & 0xff);
//            break;
//        case COLOR_MODE:
//            // // for Red Dim
//            arrayOfByte[7] = (byte) (curRed & 0xff);
//            // // : for Green Dim
//            arrayOfByte[8] = (byte) (curGreen & 0xff);
//            // // : for Blue Dim
//            arrayOfByte[9] = (byte) (curBlue & 0xff);
//            break;
//        default:
//            break;
//    }
//    
//    int crc = 0;
//    for (int i = 0; i < arrayOfByte[1]; i++) {
//        crc = crc + arrayOfByte[2 + i];
//    }
//    crc = (~crc) & (byte) (0xFF);
//    crc = (crc + 1) & (byte) (0xFF);
//    arrayOfByte[arrayOfByte[1] + 2] = (byte) (crc);
//    if (!bleWrite(arrayOfByte)) {
//        // Toast.makeText(mContext, "该设备不支持该功能", Toast.LENGTH_SHORT).show();
//        return false;
//    }
//    return true;
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
    [_peripheral writeValue:colorData forCharacteristic:_characteristic type:CBCharacteristicWriteWithResponse];
}

//设置色彩
-(void)setCurrentColor:(UIColor*)color brightness:(float)brightness hue:(float)hue
{
    NSData* colorData = [self.colorset dataCommondWithColor:color brightness:brightness hue:hue];
    NSLog(@"setColor , data :%@", colorData);
    [_peripheral writeValue:colorData forCharacteristic:_characteristic type:CBCharacteristicWriteWithResponse];
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
