//
//  DeviceSettingViewController.m
//  bleLED
//
//  Created by Monster on 14-10-3.
//  Copyright (c) 2014年 Monster. All rights reserved.
//

#import "DeviceSettingViewController.h"

#define COMMAND_SEND_TIMER    (0.12f)
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
    
    [_panelSetView startTouchChangeColor:COMMAND_SEND_TIMER];
    
    _brightnessSlider.value = _device.colorset.brightness;
    _colorTemperatureSlider.value = _device.colorset.hue;
    
    _brightness = _device.colorset.brightness;
    _hue = _device.colorset.hue;
    
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(centerViewTap)];
    [_centerView addGestureRecognizer:_tapGestureRecognizer];
    [_centerView setcenterColor:[_device.colorset currentColor]];
    _open = YES;
    _nowJustify = current_Justify_No;
}
-(void)viewDidAppear:(BOOL)animated
{
    [_panelSetView startTouchChangeColor:COMMAND_SEND_TIMER];
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
-(void)centerViewTap
{
    _open = _open?(NO):(YES);
    if (!_open) {
        [_centerView setcenterColor:[UIColor blackColor]];
        [_panelSetView stopTouchChangeColor];
        [_device open:_open];
    }else{
        [_panelSetView startTouchChangeColor:COMMAND_SEND_TIMER];
    }
    
}

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
    
    _nowJustify = current_Justify_Hue;
//    [_device setCurrentColor:keyColor brightness:tempValue hue:sender.value];
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
    _nowJustify = current_Justify_Brightness;
//    [_device setCurrentColor:keyColor brightness:sender.value hue:tempValue];
}

#pragma mark --
- (void)setDevice:(oneLedDeviceObject *)device
{
    _device = device;
}
#pragma mark --
#pragma mark -- PanelViewDelegate
-(void)touchHappened{
    _nowJustify = current_Justify_Color;
}
-(void)panelViewHSV:(HSVType)currentHSV
{
    _currentHSV = currentHSV;
    CGFloat brightness = 0.0f;
    CGFloat alpha = 0.0f;
    if (_currentHSV.h != 0 || _currentHSV.s != 0) {
        brightness = 0.5f;
        alpha = 0.5f;
    }
    
    UIColor *keyColor = [UIColor colorWithHue:_currentHSV.h
                                   saturation:_currentHSV.s
                                   brightness:brightness
                                        alpha:alpha];
    if (_open) {
        [_centerView setcenterColor:keyColor];
    }
    if (_nowJustify == current_Justify_Color) {
        [_device setCurrentColor:keyColor brightness:0 hue:1.0f];
    }else if (_nowJustify == current_Justify_Brightness) {
        if (_brightnessSlider.value <= 0.1) {
            [_device setCurrentColor:keyColor brightness:0.005 hue:1.0f];
        }else{
            [_device setCurrentColor:keyColor brightness:_brightnessSlider.value hue:1.0f];
        }
    }else if (_nowJustify == current_Justify_Hue) {
        CGFloat temp = 0.0f;
        if (_colorTemperatureSlider.value > 0.7f) {
            temp = _colorTemperatureSlider.value;
            if (_colorTemperatureSlider.value > 0.9f) {
                temp = 0.9f;
            }
            [_device setCurrentColor:[UIColor clearColor] brightness:0.005+(_colorTemperatureSlider.value - 0.7)  hue:temp];
        }
        else{
            temp = _colorTemperatureSlider.value;
            [_device setCurrentColor:[UIColor clearColor] brightness:0.005 hue:temp];
        }
        
    }else{
        [_device setCurrentColor:keyColor brightness:_brightnessSlider.value hue:_colorTemperatureSlider.value];
    }
    
}
- (IBAction)panelCenterButtonTouch:(UIButton *)sender {
}
@end
