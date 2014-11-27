//
//  SceneSettingViewController.h
//  bleLED
//
//  Created by Monster on 14-10-3.
//  Copyright (c) 2014年 Monster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PanelView.h"
#import "SceneArrayDeviceObject.h"
#import "SceneDeviceSelectViewController.h"
#import "centerColorView.h"

@interface SceneSettingViewController : UIViewController<UITextFieldDelegate,PanelViewDelegate>
{
    UITapGestureRecognizer* _tapGestureRecognizer;
    SceneDeviceSelectViewController* _sceneDeviceSelectViewController;
    BOOL _open;
}
@property (nonatomic) HSVType currentHSV;

@property(nonatomic, retain)SceneArrayDeviceObject* sceneArrayDeviceObj;
@property (nonatomic, retain)oneLedDeviceObject* device;

@property (weak, nonatomic) IBOutlet UITextField *sceneNameTextField;

//色板
@property (weak, nonatomic) IBOutlet PanelView *panelView;

@property (weak, nonatomic) IBOutlet centerColorView *centerView;

//色温
@property (weak, nonatomic) IBOutlet UISlider *colorTemperatureSlider;
- (IBAction)colorTemperatureSliderValueChanged:(UISlider *)sender;

//亮度
@property (weak, nonatomic) IBOutlet UISlider *brightnessSlider;
- (IBAction)brightnessSliderValueChanged:(UISlider *)sender;

@end
