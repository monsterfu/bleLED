//
//  PanelView.m
//  bleLED
//
//  Created by Monster on 14-10-3.
//  Copyright (c) 2014年 Monster. All rights reserved.
//

#import "PanelView.h"

#define RADIS   (32)

@implementation PanelView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor (context,  1, 0, 0, 1.0);
    CGContextAddArc(context, self.frame.size.width/2+1, self.frame.size.height/2+0.5, RADIS/2, 0, 2*M_PI, 0); //添加一个圆
    CGContextDrawPath(context, kCGPathFill);
    
}

//touch events
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    NSLog(@"touchesBegan  x:%f,  y:%f", point.x, point.y);
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    NSLog(@"touchesMoved  x:%f,  y:%f", point.x, point.y);
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    NSLog(@"touchesEnded  x:%f,  y:%f", point.x, point.y);
}
@end
