//
//  KZColorPickerWheel.m
//
//  Created by Alex Restrepo on 5/11/11.
//  Copyright 2011 KZLabs http://kzlabs.me
//  All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "KZColorPickerHSWheel.h"


@interface KZColorPickerHSWheel()
@property (nonatomic, retain) UIImageView *wheelImageView;
@property (nonatomic, retain) UIImageView *wheelKnobView;
@end

#define circular_r     (200)

@implementation KZColorPickerHSWheel
@synthesize wheelImageView;
@synthesize wheelKnobView;
@synthesize currentHSV;

- (id)initAtOrigin:(CGPoint)origin
{
    if ((self = [super initWithFrame:CGRectMake(origin.x, origin.y, circular_r, circular_r)]))
	{
        // Initialization code
		// add the imageView for the color wheel
        self.backgroundColor = [UIColor whiteColor];
		UIImageView *wheel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pickerColorWheel.png"]];
		wheel.contentMode = UIViewContentModeCenter;
		wheel.frame = CGRectMake(0, 0, circular_r, circular_r);
		[self addSubview:wheel];
		self.wheelImageView = wheel;
		[wheel release];
        
        _centerView = [[KZColorCenterView alloc] initWithFrame:CGRectMake(0, 0, 125, 125)];
        _centerView.backgroundColor = [UIColor clearColor];
        [self.wheelImageView addSubview:_centerView];
        
        
		UIImageView *wheelKnob = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"colorPickerKnob.png"]];
//		[self addSubview:wheelKnob];
		self.wheelKnobView = wheelKnob;
		[wheelKnob release];
		
		self.userInteractionEnabled = YES;		
		self.currentHSV = HSVTypeMake(0, 0, 1);				
    }
    return self;
}
-(void)layoutSubviews
{
    NSLog(@"layoutSubviews self.wheelImageView.center:%f,%f",self.wheelImageView.center.x,self.wheelImageView.center.y);
    _centerView.center = self.wheelImageView.center;
    _centerView.centerImage.center = self.wheelImageView.center;
    _centerView.cview.center = _centerView.centerImage.center;
}
- (void)dealloc
{
	[wheelImageView release];
	[wheelKnobView release];
    [super dealloc];
}

- (void) mapPointToColor:(CGPoint) point
{	
	CGPoint center = CGPointMake(self.wheelImageView.bounds.size.width * 0.5, 
								 self.wheelImageView.bounds.size.height * 0.5);
    double radius = self.wheelImageView.bounds.size.width * 0.5;
    double dx = ABS(point.x - center.x);
    double dy = ABS(point.y - center.y);
    double angle = atan(dy / dx);
	if (isnan(angle))
		angle = 0.0;
	
    double dist = sqrt(pow(dy, 2) + pow(dx, 2));
    double saturation = MIN(dist/radius, 1.0);
	
	if (dist < 10)
        saturation = 0; // snap to center	
	
    if (point.x < center.x)
        angle = M_PI - angle;
	
    if (point.y > center.y)
        angle = 2.0 * M_PI - angle;
	
	NSLog(@"on click h:%f s:%f", angle, saturation);
	
	self.currentHSV = HSVTypeMake(angle / (2.0 * M_PI), saturation, 1.0);	
	[self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void) setCurrentHSV:(HSVType)hsv
{
	currentHSV = hsv;
	currentHSV.v = 1.0;
	double angle = currentHSV.h * 2.0 * M_PI;
	CGPoint center = CGPointMake(self.wheelImageView.bounds.size.width * 0.5, 
								 self.wheelImageView.bounds.size.height * 0.5);
	double radius = self.wheelImageView.bounds.size.width * 0.5 - 3.0f;
	radius *= currentHSV.s;
	
	CGFloat x = center.x + cosf(angle) * radius;
	CGFloat y = center.y - sinf(angle) * radius;
	
	x = roundf(x - self.wheelKnobView.bounds.size.width * 0.5) + self.wheelKnobView.bounds.size.width * 0.5;
	y = roundf(y - self.wheelKnobView.bounds.size.height * 0.5) + self.wheelKnobView.bounds.size.height * 0.5;
	self.wheelKnobView.center = CGPointMake(x + self.wheelImageView.frame.origin.x, y + self.wheelImageView.frame.origin.y);
}

- (CGFloat) hue
{
	return currentHSV.h;
}

- (CGFloat) saturation
{
	return currentHSV.s;
}

- (CGFloat) brightness
{
	return currentHSV.v;
}

#pragma mark -
#pragma mark Touches
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint mousepoint = [touch locationInView:self];
	if (!CGRectContainsPoint(self.wheelImageView.frame, mousepoint)) 
		return NO;
	
	[self mapPointToColor:[touch locationInView:self.wheelImageView]];
	return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	[self mapPointToColor:[touch locationInView:self.wheelImageView]];
	return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	[self continueTrackingWithTouch:touch withEvent:event];
}

@end
