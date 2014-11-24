//
//  DeviceSettingViewController.m
//  bleLED
//
//  Created by Monster on 14-10-3.
//  Copyright (c) 2014年 Monster. All rights reserved.
//

#import "DeviceSettingViewController.h"

@interface DeviceSettingViewController ()

@end

@implementation DeviceSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_colorTemperatureSlider setMinimumTrackImage:[UIImage imageNamed:@"line_progress"] forState:UIControlStateNormal];
    [_colorTemperatureSlider setMaximumTrackImage:[UIImage imageNamed:@"line_progress_bg"] forState:UIControlStateNormal];
    
    [_brightnessSlider setMinimumTrackImage:[UIImage imageNamed:@"line_progress"] forState:UIControlStateNormal];
    [_brightnessSlider setMaximumTrackImage:[UIImage imageNamed:@"line_progress_bg"] forState:UIControlStateNormal];
    
    
    _panelSetView.delegate = self;
    [_panelSetView startTouchChangeColor];
    
    _brightnessSlider.value = _device.colorset.brightness;
    _colorTemperatureSlider.value = _device.colorset.hue;
}
-(void)viewDidAppear:(BOOL)animated
{
    [_panelSetView startTouchChangeColor];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [_panelSetView stopTouchChangeColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)colorTemperatureSliderValueChange:(UISlider *)sender {
    NSLog(@"colorTemperatureSliderValueChange:%f",sender.value);
    float tempValue = 0.0f;
    tempValue = _brightnessSlider.value;
    UIColor *keyColor = [UIColor colorWithHue:_currentHSV.h
                                   saturation:_currentHSV.s
                                   brightness:1.0
                                        alpha:1.0];
    if ((sender.value + _brightnessSlider.value) > 1.0f ) {
        float addValue = sender.value - 0.5;
        tempValue -= addValue;
    }
    [_device setCurrentColor:keyColor brightness:tempValue hue:sender.value];
}
- (IBAction)brightnessSliderValueChange:(UISlider *)sender {
    NSLog(@"brightnessSliderValueChange:%f",sender.value);
    float tempValue = 0.0f;
    tempValue = _colorTemperatureSlider.value;
    UIColor *keyColor = [UIColor colorWithHue:_currentHSV.h
                                   saturation:_currentHSV.s
                                   brightness:1.0
                                        alpha:1.0];
    if ((sender.value + _colorTemperatureSlider.value) > 1.0f ) {
        float addValue = sender.value - 0.5;
        tempValue -= addValue;
    }
    [_device setCurrentColor:keyColor brightness:sender.value hue:tempValue];
}

#pragma mark --
- (void)setDevice:(oneLedDeviceObject *)device
{
    _device = device;
}
#pragma mark --
#pragma mark -- PanelViewDelegate
-(void)panelViewHSV:(HSVType)currentHSV
{
    _currentHSV = currentHSV;
    
    UIColor *keyColor = [UIColor colorWithHue:_currentHSV.h
                                   saturation:_currentHSV.s
                                   brightness:1.0
                                        alpha:1.0];
    [_device setCurrentColor:keyColor brightness:_brightnessSlider.value hue:_colorTemperatureSlider.value];
}
- (IBAction)panelCenterButtonTouch:(UIButton *)sender {
}
@end
