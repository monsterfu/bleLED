//
//  colorSetObject.h
//  bleLED
//
//  Created by Monster on 14-11-16.
//  Copyright (c) 2014年 Monster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@interface colorSetObject : NSObject


@property(nonatomic,assign)CGFloat r;
@property(nonatomic,assign)CGFloat g;
@property(nonatomic,assign)CGFloat b;

@property(nonatomic,assign)CGFloat hue;
@property(nonatomic,assign)CGFloat brightness;


+ (colorSetObject*)createWithInit;
+(colorSetObject*)createWithColor:(UIColor*)color brightness:(float)brightness hue:(float)hue;
-(UIColor*)currentColor;

- (NSData*)dataCommondWithDefaultValue;
- (NSData*)dataCommondWithColor:(UIColor*)color brightness:(float)brightness hue:(float)hue;

@end
