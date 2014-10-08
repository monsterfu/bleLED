//
//  ConnectionManager.h
//  bleAlarm
//
//  Created by Monster on 14-4-18.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalHeader.h"

typedef enum : NSUInteger {
    BodyCare_Status_Ble_Close,
    BodyCare_Status_Ble_Open,
    BodyCare_Status_Ble_DiscoverDevice,
    BodyCare_Status_Ble_ConnectDevice,
    BodyCare_Status_Ble_MeasureTemperature,
    BodyCare_Status_Ble_DisconnectDevice,
    BodyCare_Status_Ble_Max
} BodyCare_Status_Ble_Enum;


@protocol ConnectionManagerDelegate
//- (void) didDiscoverDevice:(TemperatureFob*)device;
//- (void) didDisconnectWithDevice:(TemperatureFob*)device;
//- (void) didConnectWithDevice:(TemperatureFob*)device;
//- (void) didUpdateTemperature:(CGFloat)temp;
@end

@protocol TemperatureFobDelegate;

@interface ConnectionManager : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>
{
    NSTimer* checkRssiTimer;
    CBUUID* _batteryUUID;
    NSUInteger _indexRSSI;
}
@property(nonatomic,assign)id<ConnectionManagerDelegate> delegate;
@property(nonatomic,assign)BodyCare_Status_Ble_Enum status;
@property(nonatomic,strong)CBCentralManager *manager;
@property(nonatomic,strong)CBPeripheral *peripheral;
@property(nonatomic,strong)CBPeripheral* perpheralConnecting;
@property(nonatomic,retain)NSMutableDictionary* peripheralDictionary;
@property(nonatomic,retain)NSMutableDictionary* characteristicDictionary;

@property(nonatomic,retain)NSMutableArray* addedDeviceArray;
@property(nonatomic,retain)NSMutableArray* newsDeviceArray;

@property(nonatomic,retain)NSMutableDictionary* deviceManagerDictionary;



+ (ConnectionManager*) sharedInstance;
- (void) startScanForDevice;
- (void) stopScanForDevice;


- (void) startMeasureTemperature;  //开始测量体温
- (void) standByTemperature;       //待机
- (void) sendWarningTemperature;   //发送警报

@end
