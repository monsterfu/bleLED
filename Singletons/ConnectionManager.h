//
//  ConnectionManager.h
//  bleAlarm
//
//  Created by Monster on 14-4-18.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalHeader.h"

@class oneLedDeviceObject;

@protocol ConnectionManagerDelegate
- (void) didDiscoverDevice:(oneLedDeviceObject*)device;
- (void) didDisconnectWithDevice:(oneLedDeviceObject*)device;
- (void) didConnectWithDevice:(oneLedDeviceObject*)device;
//- (void) didUpdateTemperature:(CGFloat)temp;
@end

@interface ConnectionManager : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>
{
    NSTimer* checkRssiTimer;
    CBUUID* _batteryUUID;
    NSUInteger _indexRSSI;
    oneLedDeviceObject* _deviceObject;
}
@property(nonatomic,assign)id<ConnectionManagerDelegate> delegate;
@property(nonatomic,strong)CBCentralManager *manager;

@property(nonatomic,retain)NSMutableArray* addedDeviceArray;
@property(nonatomic,retain)NSMutableArray* existDeviceArray;

@property(nonatomic,retain)NSMutableDictionary* deviceManagerDictionary;



+ (ConnectionManager*) sharedInstance;
- (void) startScanForDevice;
- (void) stopScanForDevice;

@end
