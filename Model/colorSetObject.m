//
//  colorSetObject.m
//  bleLED
//
//  Created by Monster on 14-11-16.
//  Copyright (c) 2014年 Monster. All rights reserved.
//

#import "colorSetObject.h"

#define MAX_VALUE_I     (250.0f)

@implementation colorSetObject

+(colorSetObject*)createWithInit
{
    colorSetObject* colorSet = [[colorSetObject alloc]init];
    colorSet.r = 1;
    colorSet.g = 1;
    colorSet.b = 1;
    colorSet.brightness = 1;
    colorSet.hue = 1;
    return colorSet;
}


+(colorSetObject*)createWithColor:(UIColor*)color brightness:(float)brightness hue:(float)hue
{
    colorSetObject* colorSet = [[colorSetObject alloc]init];
    CGFloat r, g, b, alpha;
    
    if ([color getRed:&r green:&g blue:&b alpha:&alpha]) {
        colorSet.r = r;
        colorSet.g = g;
        colorSet.b = b;
        colorSet.brightness = brightness;
        colorSet.hue = hue;
        return colorSet;
    }
    return nil;
}

-(UIColor*)currentColor
{
    return [UIColor colorWithRed:_r green:_g blue:_b alpha:1.0];
}

- (NSData*)dataCommondWithDefaultValue
{
    unsigned char command1[20] = {0x55,0x08,0x00,0x01,0x01,  self.brightness*MAX_VALUE_I,self.hue*MAX_VALUE_I, self.r*MAX_VALUE_I,self.g*MAX_VALUE_I,self.b*MAX_VALUE_I};
    int total = 0;
    total += command1[3];
    total += command1[4];
    total += command1[5];
    total += command1[6];
    total += command1[7];
    total += command1[8];
    total += command1[9];
    
    command1[10] = 256 - total%256;
    command1[11] = 0xAA;
    
    return [[NSData alloc]initWithBytes:command1 length:12];
}

- (NSData*)dataCommondWithColor:(UIColor*)color brightness:(float)brightness hue:(float)hue
{
    CGFloat r, g, b, alpha;
    if ([color getRed:&r green:&g blue:&b alpha:&alpha]) {
        self.r = r;
        self.g = g;
        self.b = b;
        self.brightness = brightness;
        self.hue = 1.0f - hue;
    }
    if (self.brightness + self.hue > 1) {
        CGFloat upFloat = self.brightness + self.hue - 1;
        if (upFloat/2.0f > self.brightness) {
            self.hue -= upFloat;
        }else if (upFloat/2.0f > self.hue) {
            self.brightness -= upFloat;
        }else{
            self.brightness -= upFloat/2.0f;
            self.hue -= upFloat/2.0f;
        }
    }
    
    unsigned char command1[20] = {0x55,0x08,0x00,0x01,0x01,  self.brightness*MAX_VALUE_I,self.hue*MAX_VALUE_I, self.r*MAX_VALUE_I,self.g*MAX_VALUE_I,self.b*MAX_VALUE_I};
    int total = 0;
    total += command1[3];
    total += command1[4];
    total += command1[5];
    total += command1[6];
    total += command1[7];
    total += command1[8];
    total += command1[9];
    
    command1[10] = 256 - total%256;
    command1[11] = 0xAA;
    
    return [[NSData alloc]initWithBytes:command1 length:12];
}

#pragma mark ---
#pragma mark ---  Encode

#define R_VALUE_KEY           @"int"
#define G_VALUE_KEY          @"name"
#define B_VALUE_KEY          @"bool"
#define Bright_VALUE_KEY    @"identifier"
#define Hue_VALUE_KEY      @"colorset"


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeFloat:_r forKey:R_VALUE_KEY];
    [aCoder encodeFloat:_g forKey:G_VALUE_KEY];
    [aCoder encodeFloat:_b forKey:B_VALUE_KEY];
    [aCoder encodeFloat:_brightness forKey:Bright_VALUE_KEY];
    [aCoder encodeFloat:_hue forKey:Hue_VALUE_KEY];
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]){
        _r = [aDecoder decodeFloatForKey:R_VALUE_KEY];
        _g = [aDecoder decodeFloatForKey:G_VALUE_KEY];
        _b = [aDecoder decodeFloatForKey:B_VALUE_KEY];
        _brightness = [aDecoder decodeFloatForKey:Bright_VALUE_KEY];
        _hue = [aDecoder decodeFloatForKey:Hue_VALUE_KEY];
    }
    return self;
}
@end
