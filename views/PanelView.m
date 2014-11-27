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
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGFloat r, g, b, alpha;
//    if ([_centerColor getRed:&r green:&g blue:&b alpha:&alpha]){
//         CGContextSetRGBFillColor (context,  r, g, b, alpha);
//    }else{
//        if ([[UIColor clearColor] getRed:&r green:&g blue:&b alpha:&alpha]){
//            CGContextSetRGBFillColor (context,  r, g, b, alpha);
//        }
//    }
//    CGContextAddArc(context, self.frame.size.width/2+1, self.frame.size.height/2+0.5, RADIS/2, 0, 2*M_PI, 0); //添加圆
//    CGContextDrawPath(context, kCGPathFill);
}


-(void)startTouchChangeColor
{
    if(!_commondSendTimer)
    {
    _commondSendTimer = [NSTimer timerWithTimeInterval:0.4 target:self selector:@selector(sendColorToDevice) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:_commondSendTimer forMode:NSRunLoopCommonModes];
    }
}
-(void)stopTouchChangeColor
{
    [_commondSendTimer invalidate];
    _commondSendTimer = nil;
}
//touch events
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    [self mapPointToColor:[touch locationInView:self]];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    [self mapPointToColor:[touch locationInView:self]];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    [self mapPointToColor:[touch locationInView:self]];
}
#pragma mark --
#pragma mark -----

- (void) mapPointToColor:(CGPoint) point
{
    CGPoint center = CGPointMake(self.frame.size.width * 0.5,
                                 self.frame.size.height * 0.5);
    double radius = self.frame.size.width * 0.5;
    double dx = ABS(point.x - center.x);
    double dy = ABS(point.y - center.y);
    double angle = atan(dy / dx);
    if (isnan(angle))
        angle = 0.0;
    
    double dist = sqrt(pow(dx, 2) + pow(dy, 2));
    double saturation = MIN(dist/radius, 1.0);
    
    if (dist < 10)
        saturation = 0; // snap to center
    
    if (point.x < center.x)
        angle = M_PI - angle;
    
    if (point.y > center.y)
        angle = 2.0 * M_PI - angle;
    
    //NSLog(@"on click h:%f s:%f", angle, saturation);
    
    self.currentHSV = HSVTypeMake(angle / (2.0 * M_PI), saturation, 1.0);
}

- (void) setCurrentHSV:(HSVType)hsv
{
    _currentHSV = hsv;
    _centerColor = [UIColor colorWithHue:hsv.h
                                   saturation:hsv.s
                                   brightness:1.0
                                        alpha:1.0];
    [self setNeedsDisplay];
}

-(void) sendColorToDevice
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(panelViewHSV:)]) {
        [self.delegate panelViewHSV:_currentHSV];
    }
}
@end
