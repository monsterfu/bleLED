//
//  SceneSettingViewController.m
//  bleLED
//
//  Created by Monster on 14-10-3.
//  Copyright (c) 2014年 Monster. All rights reserved.
//

#import "SceneSettingViewController.h"

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
    [_panelView startTouchChangeColor];
    
    _brightnessSlider.value = _sceneArrayDeviceObj.colorSet.brightness;
    _colorTemperatureSlider.value = _sceneArrayDeviceObj.colorSet.hue;
    
    _sceneNameTextField.text = _sceneArrayDeviceObj.name;
}

-(void)viewDidAppear:(BOOL)animated
{
    [_panelView startTouchChangeColor];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [_panelView stopTouchChangeColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [_sceneArrayDeviceObj.colorSet dataCommondWithColor:keyColor brightness:_brightnessSlider.value hue:_colorTemperatureSlider.value];
    for (_device in _sceneArrayDeviceObj.deviceArray) {
        [_device setCurrentColor:keyColor brightness:_brightnessSlider.value hue:_colorTemperatureSlider.value];
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
