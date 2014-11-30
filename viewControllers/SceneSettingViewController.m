//
//  SceneSettingViewController.m
//  bleLED
//
//  Created by Monster on 14-10-3.
//  Copyright (c) 2014年 Monster. All rights reserved.
//

#import "SceneSettingViewController.h"

#define COMMAND_SEND_TIMER    (0.3f)
@interface SceneSettingViewController ()

@end

@implementation SceneSettingViewController


-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    [_sceneNameTextField resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _sceneNameTextField.delegate = self;
    
    [_colorTemperatureSlider setMinimumTrackImage:[UIImage imageNamed:@"line_progress"] forState:UIControlStateNormal];
    [_colorTemperatureSlider setMaximumTrackImage:[UIImage imageNamed:@"line_progress_bg"] forState:UIControlStateNormal];
    
    [_brightnessSlider setMinimumTrackImage:[UIImage imageNamed:@"line_progress"] forState:UIControlStateNormal];
    [_brightnessSlider setMaximumTrackImage:[UIImage imageNamed:@"line_progress_bg"] forState:UIControlStateNormal];
    
    
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:_tapGestureRecognizer];
    
    _panelView.delegate = self;
    [_panelView startTouchChangeColor:COMMAND_SEND_TIMER];
    
    _brightnessSlider.value = _sceneArrayDeviceObj.colorSet.brightness;
    _colorTemperatureSlider.value = _sceneArrayDeviceObj.colorSet.hue;
    
    _sceneNameTextField.text = _sceneArrayDeviceObj.name;
    
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(centerViewTap)];
    [_centerView addGestureRecognizer:_tapGestureRecognizer];
    [_centerView setcenterColor:[_sceneArrayDeviceObj.colorSet currentColor]];
    _open = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [_panelView startTouchChangeColor:COMMAND_SEND_TIMER];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [_panelView stopTouchChangeColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)centerViewTap
{
    _open = _open?(NO):(YES);
    if (!_open) {
        [_centerView setcenterColor:[UIColor blackColor]];
        [_panelView stopTouchChangeColor];
        for (_device in _sceneArrayDeviceObj.deviceArray) {
            [_device open:_open];;
        }
        
    }else{
        [_panelView startTouchChangeColor:COMMAND_SEND_TIMER];
    }
}
#pragma mark --
#pragma mark -- PanelViewDelegate
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
    [_sceneArrayDeviceObj.colorSet dataCommondWithColor:keyColor brightness:_brightnessSlider.value hue:_colorTemperatureSlider.value];
    for (_device in _sceneArrayDeviceObj.deviceArray) {
        [_device setCurrentColor:keyColor brightness:_brightnessSlider.value hue:_colorTemperatureSlider.value];
    }
}
#pragma mark --
#pragma mark -- UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length) {
        _sceneArrayDeviceObj.name = textField.text;
    }
    
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"deviceSelectIdentifier"]) {
        _sceneDeviceSelectViewController = (SceneDeviceSelectViewController*)segue.destinationViewController;
        _sceneDeviceSelectViewController.sceneArrayDeviceObj = _sceneArrayDeviceObj;
    }
}

-(void)tap
{
    [_sceneNameTextField resignFirstResponder];
}

- (IBAction)brightnessSliderValueChanged:(UISlider *)sender {
}
- (IBAction)colorTemperatureSliderValueChanged:(UISlider *)sender {
}
@end
