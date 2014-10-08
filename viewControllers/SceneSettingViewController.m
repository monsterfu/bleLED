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

-(void)tap
{
    [_sceneNameTextField resignFirstResponder];
}

- (IBAction)brightnessSliderValueChanged:(UISlider *)sender {
}
- (IBAction)colorTemperatureSliderValueChanged:(UISlider *)sender {
}
@end
