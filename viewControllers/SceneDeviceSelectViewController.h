//
//  SceneDeviceSelectViewController.h
//  bleLED
//
//  Created by Monster on 14-10-3.
//  Copyright (c) 2014年 Monster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalHeader.h"
#import "deviceSelectedCell.h"

@interface SceneDeviceSelectViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,deviceSelectedCellDelegate>
{
    deviceSelectedCell* _cell;
    UIBarButtonItem* _rightButtonItem;
    oneLedDeviceObject* _device;
}
@property(nonatomic, retain)SceneArrayDeviceObject* sceneArrayDeviceObj;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, retain)NSMutableArray* deviceArray;
@property (nonatomic, retain)NSMutableArray* selectedArray;

@end
