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
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
