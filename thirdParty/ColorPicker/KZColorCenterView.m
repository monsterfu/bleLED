//
//  KZColorCenterView.m
//  bleLED
//
//  Created by Monster on 14-11-17.
//  Copyright (c) 2014年 Monster. All rights reserved.
//

#import "KZColorCenterView.h"

@implementation KZColorCenterView

#define r_rudics  (30)
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    _centerImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"btn_rainbow_normal"]];
    [self addSubview:_centerImage];
    
    [self sendSubviewToBack:_centerImage];
    
    
    _cview=[UIView new];
    _cview.frame=CGRectMake(self.frame.size.width/2 - r_rudics/2, self.frame.size.width/2 - r_rudics/2, r_rudics, r_rudics);
    _cview.backgroundColor = [UIColor greenColor];
    _cview.layer.cornerRadius=_cview.frame.size.width/2;
    [self addSubview:_cview];
}


@end
