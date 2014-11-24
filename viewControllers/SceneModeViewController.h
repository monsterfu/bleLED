//
//  SceneModeViewController.h
//  bleLED
//
//  Created by Monster on 14-10-3.
//  Copyright (c) 2014年 Monster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalHeader.h"
#import "sceneModeCell.h"

@interface SceneModeViewController : UIViewController<sceneModeCellDelegate>
{
    EmptyModeViewController* _emptyModeViewController;
    SceneArrayDeviceObject* _sceneArrayDeviceObject;
    sceneModeCell* _cell;
}

- (IBAction)addButtonTouched:(UIBarButtonItem *)sender;

@property(nonatomic, retain)NSMutableArray* sceneArry;

@end
