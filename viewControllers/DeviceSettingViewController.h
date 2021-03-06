//
//  DeviceSettingViewController.h
//  bleLED
//
//  Created by Monster on 14-10-3.
//  Copyright (c) 2014年 Monster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PanelView.h"
#import "oneLedDeviceObject.h"
#import "centercolorView.h"

typedef enum : NSUInteger {
    current_Justify_No,
    current_Justify_Color,
    current_Justify_Brightness,
    current_Justify_Hue
} current_Justify_Enum;


@interface DeviceSettingViewController : UIViewController<PanelViewDelegate>
{
    float _brightness;
    float _hue;
    UITapGestureRecognizer* _tapGestureRecognizer;
    BOOL _open;
    
    current_Justify_Enum _nowJustify;
}
@property (nonatomic) HSVType currentHSV;
@property (weak, nonatomic) IBOutlet PanelView *panelSetView;
@property (weak, nonatomic) IBOutlet centerColorView *centerView;

@property (weak, nonatomic) IBOutlet UIImageView *panelImageView;
@property (nonatomic, retain)oneLedDeviceObject* device;

- (IBAction)panelCenterButtonTouch:(UIButton *)sender;


//色温
@property (weak, nonatomic) IBOutlet UISlider *colorTemperatureSlider;
- (IBAction)colorTemperatureSliderValueChange:(UISlider *)sender;

//亮度
@property (weak, nonatomic) IBOutlet UISlider *brightnessSlider;
- (IBAction)brightnessSliderValueChange:(UISlider *)sender;


@end
