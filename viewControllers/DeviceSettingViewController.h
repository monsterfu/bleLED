//
//  DeviceSettingViewController.h
//  bleLED
//
//  Created by Monster on 14-10-3.
//  Copyright (c) 2014年 Monster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PanelView.h"

@interface DeviceSettingViewController : UIViewController


@property (weak, nonatomic) IBOutlet PanelView *panelSetView;

//色温
@property (weak, nonatomic) IBOutlet UISlider *colorTemperatureSlider;
- (IBAction)colorTemperatureSliderValueChange:(UISlider *)sender;

//亮度
@property (weak, nonatomic) IBOutlet UISlider *brightnessSlider;
- (IBAction)brightnessSliderValueChange:(UISlider *)sender;


@end
