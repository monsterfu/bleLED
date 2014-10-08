//
//  SceneSettingViewController.h
//  bleLED
//
//  Created by Monster on 14-10-3.
//  Copyright (c) 2014年 Monster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PanelView.h"


@interface SceneSettingViewController : UIViewController<UITextFieldDelegate>
{
    UITapGestureRecognizer* _tapGestureRecognizer;
}

@property (weak, nonatomic) IBOutlet UITextField *sceneNameTextField;

//色板
@property (weak, nonatomic) IBOutlet PanelView *panelView;


//色温
@property (weak, nonatomic) IBOutlet UISlider *colorTemperatureSlider;
- (IBAction)colorTemperatureSliderValueChanged:(UISlider *)sender;

//亮度
@property (weak, nonatomic) IBOutlet UISlider *brightnessSlider;
- (IBAction)brightnessSliderValueChanged:(UISlider *)sender;

@end
