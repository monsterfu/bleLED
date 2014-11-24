//
//  MainViewController.h
//  bleLED
//
//  Created by Monster on 14-10-3.
//  Copyright (c) 2014年 Monster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalHeader.h"
#import "deviceListCell.h"
#import "DeviceSettingViewController.h"

@interface MainViewController : UIViewController<MBProgressHUDDelegate,UITableViewDataSource,UITableViewDelegate,deviceListCellDelegate,ConnectionManagerDelegate>
{
    MBProgressHUD* _hud;
    EmptyOneViewController* _emptyViewController;
    deviceListCell* _cell;
    DeviceSettingViewController* _deviceSettingViewController;
    
    oneLedDeviceObject* _device;
}

@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, retain)NSMutableArray* deviceArray;

@end
