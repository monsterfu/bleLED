//
//  DeviceColorSetViewController.h
//  bleLED
//
//  Created by Monster on 14-11-16.
//  Copyright (c) 2014年 Monster. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DeviceColorSetViewControllerDelegate;

@interface DeviceColorSetViewController : UIViewController
{
    UIColor *selectedColor;
//    id<DeviceColorSetViewControllerDelegate> delegate;
}
@property(nonatomic, weak) id<DeviceColorSetViewControllerDelegate> delegate;
@property(nonatomic, retain) UIColor *selectedColor;
@end

@protocol DeviceColorSetViewControllerDelegate
- (void) defaultColorController:(DeviceColorSetViewController *)controller didChangeColor:(UIColor *)color;


@end
