//
//  centerColorView.h
//  bleLED
//
//  Created by Monster on 14-10-16.
//  Copyright (c) 2014年 Monster. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface centerColorView : UIView
{
    CGFloat _red;
    CGFloat _green;
    CGFloat _blue;
}

-(void)setcenterColor:(UIColor*)color;
@end
