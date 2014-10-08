//
//  GlobalHeader.h
//  bleLED
//
//  Created by Monster on 14-10-2.
//  Copyright (c) 2014年 Monster. All rights reserved.
//

#ifndef bleLED_GlobalHeader_h
#define bleLED_GlobalHeader_h


#import <CoreBluetooth/CoreBluetooth.h>
#import "UIColor+getColor.h"
#import "CommonNavigationController.h"
#import "thirdParty/MBProgressHUD.h"
#import "ConnectionManager.h"
#import "EmptyOneViewController.h"
#import "EmptyModeViewController.h"

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7 ?YES:NO)
#define DEVICE_WIDTH  [UIScreen mainScreen].bounds.size.width
#define DEVICE_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

#endif
