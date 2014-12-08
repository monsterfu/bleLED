//
//  centerColorView.m
//  bleLED
//
//  Created by Monster on 14-10-16.
//  Copyright (c) 2014年 Monster. All rights reserved.
//

#import "centerColorView.h"

#define RADIS   (82)
@implementation centerColorView

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor (context,  _red, _green, _blue, 1.0);
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height/2, RADIS/2, 0, 2*M_PI, 0); //添加一个圆
    CGContextDrawPath(context, kCGPathFill);
    
}

-(void)setcenterColor:(UIColor*)color
{
    CGFloat _alpha;
    self.backgroundColor = [UIColor clearColor];
    if (color) {
        [color getRed:&_red green:&_green blue:&_blue alpha:&_alpha];
        [self setNeedsDisplay];
    }
}
@end
