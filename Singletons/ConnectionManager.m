//
//  ConnectionManager.m
//  bleAlarm
//
//  Created by Monster on 14-4-18.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "ConnectionManager.h"

#define TRANSFER_SERVICE_TEST_UUID                       @"F1ED"
#define TRANSFER_CHARACTERISTIC_TEST_UUID                @"F1EE"
#define TRANSFER_SERVICE_COMMONDCHANNEL1_UUID            @"F000CCC0-0451-4000-B000-000000000000"
#define TRANSFER_SERVICE_COMMONDCHANNEL2_UUID            @"F000FFC0-0451-4000-B000-000000000000"
#define TRANSFER_CHARACTERISTIC1_SETCOMMAND_UUID         @"F000FFC1-0451-4000-B000-000000000000"
#define TRANSFER_CHARACTERISTIC2_SETCOMMAND_UUID         @"F000FFC2-0451-4000-B000-000000000000"
@implementation ConnectionManager
@synthesize manager;

static ConnectionManager *sharedConnectionManager;

+ (ConnectionManager*) sharedInstance
{
    if (sharedConnectionManager == nil)
    {
        sharedConnectionManager = [[ConnectionManager alloc]initWithDelegate:nil];
    }
    return sharedConnectionManager;
}
- (ConnectionManager*) initWithDelegate:(id<ConnectionManagerDelegate>) delegate
{
    if (self = [super init])
    {
        _delegate = delegate;
        manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        
        _addedDeviceArray = [NSMutableArray array];
        
        _deviceManagerDictionary = [NSMutableDictionary dictionary];
        _indexRSSI = 0;
//        NSData* aData = [USER_DEFAULT objectForKey:KEY_DEVICELIST_INFO];
//        _addedDeviceArray = [NSKeyedUnarchiver unarchiveObjectWithData:aData];
        _existDeviceArray = [NSMutableArray array];
        if (_addedDeviceArray == nil) {
            _addedDeviceArray = [NSMutableArray array];
        }else{
            
            for (oneLedDeviceObject* device in _addedDeviceArray) {
                [_deviceManagerDictionary setObject:device forKey:device.identifier];
            }
        }
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appWillDetemin) name:NSNotificationCenter_AppWillDetemin object:nil];
    }
    return self;
}
-(void)appWillDetemin
{
    [USER_DEFAULT removeObjectForKey:KEY_DEVICELIST_INFO];
    NSData* aDate = [NSKeyedArchiver archivedDataWithRootObject:_addedDeviceArray];
    [USER_DEFAULT setObject:aDate forKey:KEY_DEVICELIST_INFO];
    [USER_DEFAULT synchronize];
}
-(void)dealloc
{
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:NSNotificationCenter_dismissRecordChange object:nil];
}

#pragma mark -scan
- (void) startScanForDevice
{
    NSDictionary* scanOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    
    // Make sure we start scan from scratch
    [manager stopScan];
    
    [manager scanForPeripheralsWithServices:nil options:scanOptions];
}

- (void) stopScanForDevice
{
    [manager stopScan];
}


#pragma mark - center delegate
-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
        {
            if ([central state] == CBCentralManagerStatePoweredOn)
            {
//                [_delegate isBluetoothEnabled:YES];
            }
            else
            {
//                [_delegate isBluetoothEnabled:NO];
            }
            
            NSLog(@"CBCentralManagerStatePoweredOn");
        }
            break;
        case CBCentralManagerStatePoweredOff:
            NSLog(@"CBCentralManagerStatePoweredOff");
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@"CBCentralManagerStateUnsupported");
            break;
        case CBCentralManagerStateResetting:
            NSLog(@"CBCentralManagerStateResetting");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@"CBCentralManagerStateUnauthorized");
            break;
        case CBCentralManagerStateUnknown:
            NSLog(@"CBCentralManagerStateUnknown");
            break;
            
        default:
            NSLog(@"CM did Change State");
            
            break;
    }
}
-(void)resetDeviceConnectingStatus:(id)sender
{
    NSLog(@"sssssss:%@",_checkConnectTimer.userInfo);
    oneLedDeviceObject* dev = _checkConnectTimer.userInfo;
    dev.isConnecting = NO;
}
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)args_peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    
    //屏蔽不可连接设备
    BOOL connectable = [[advertisementData objectForKey:@"kCBAdvDataIsConnectable"]boolValue];
    if (!connectable) {
        return;
    }
    if (![[args_peripheral name] isEqualToString:@"LED DEMO SGP"]) {
        NSLog(@"Discovered unknown device, %@,%@", [args_peripheral name],[args_peripheral.identifier UUIDString]);
//        return;
    }
    
//    NSDictionary *serviceData = [advertisementData objectForKey:@"kCBAdvDataServiceData"];
//    if (!serviceData ||
//        (![serviceData objectForKey:[TemperatureFob thermometerServiceUUID]] ||
//         ![serviceData objectForKey:[TemperatureFob batteryServiceUUID]]))
//    {
////        NSLog(@"Discovered unknown device, %@", [args_peripheral name]);
////        return;
//    }
    //屏蔽已连接设备
    if ([_deviceManagerDictionary objectForKey:[args_peripheral.identifier UUIDString]]) {
        _deviceObject = [_deviceManagerDictionary objectForKey:[args_peripheral.identifier UUIDString]];
        _deviceObject.peripheral = args_peripheral;
        if (!_deviceObject.isConnecting) {
            [manager connectPeripheral:args_peripheral options:nil];
            _deviceObject.isConnecting = YES;
            _checkConnectTimer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(resetDeviceConnectingStatus:) userInfo:_deviceObject repeats:NO];
            [[NSRunLoop currentRunLoop]addTimer:_checkConnectTimer forMode:NSRunLoopCommonModes];
        }
        return;
    }else{
        _deviceObject = [oneLedDeviceObject createDeviceObjectWithName:[args_peripheral name] identifier:[args_peripheral.identifier UUIDString]];
        _deviceObject.identifier = [args_peripheral.identifier UUIDString];
        _deviceObject.peripheral = args_peripheral;
        [_addedDeviceArray addObject:_deviceObject];
        [_deviceManagerDictionary setObject:_deviceObject forKey:_deviceObject.identifier];
        
        
        [USER_DEFAULT removeObjectForKey:KEY_DEVICELIST_INFO];
        NSData* aDate = [NSKeyedArchiver archivedDataWithRootObject:_addedDeviceArray];
        [USER_DEFAULT setObject:aDate forKey:KEY_DEVICELIST_INFO];
        [USER_DEFAULT synchronize];
    }
    
}

-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)arg_peripheral error:(NSError *)error{
    NSLog(@"Connecting Fail: %@",error);
    [manager connectPeripheral:arg_peripheral options:nil];
}


- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)persipheral error:(NSError *)error
{
    NSLog(@"disconnect!!!!  error: %@",error);
    
    [_existDeviceArray removeObject:[_deviceManagerDictionary objectForKey:[persipheral.identifier UUIDString]]];
    [self.delegate didDiscoverDevice:_deviceObject];
    [USER_DEFAULT removeObjectForKey:KEY_DEVICELIST_INFO];
    NSData* aDate = [NSKeyedArchiver archivedDataWithRootObject:[ConnectionManager sharedInstance].addedDeviceArray];
    [USER_DEFAULT setObject:aDate forKey:KEY_DEVICELIST_INFO];
    [USER_DEFAULT synchronize];
    
    [manager connectPeripheral:persipheral options:nil];
}

-(void)peripheralDidUpdateRSSI:(CBPeripheral *)arg_peripheral error:(NSError *)error
{
//    NSLog(@"[[[[[[[[[[[[[[[peripheral.ddd:%f]]]]]]]]]]]]]]]",[arg_peripheral.RSSI floatValue]);
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)args_peripheral
{
    [args_peripheral setDelegate:self];
    [args_peripheral readRSSI];
    [args_peripheral discoverServices:nil];
    [_existDeviceArray removeObject:[_deviceManagerDictionary objectForKey:[args_peripheral.identifier UUIDString]]];
    [_existDeviceArray addObject:[_deviceManagerDictionary objectForKey:[args_peripheral.identifier UUIDString]]];
    [self.delegate didDiscoverDevice:_deviceObject];
}

-(void)peripheral:(CBPeripheral *)args_peripheral didDiscoverServices:(NSError *)error{
    if (error) {
        NSLog(@"Error discover service: %@",[error localizedDescription]);
        return;
    }
    
    for(CBService *service in args_peripheral.services){
        NSLog(@"Service found with UUID: %@",service.UUID);
//        [args_peripheral discoverCharacteristics:nil forService:service];
        if ([service.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_SERVICE_TEST_UUID]]) {
            [args_peripheral discoverCharacteristics:nil forService:service];
        }
//        else if ([service.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_SERVICE_COMMONDCHANNEL2_UUID]]) {
//            [args_peripheral discoverCharacteristics:nil forService:service];
//        }
    }
    
}

-(void)peripheral:(CBPeripheral *)args_peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    
    if (error) {
        NSLog(@"Error discover Character");
        //;
        return;
    }
    
    for (CBCharacteristic *aChar in service.characteristics)
    {
//        NSLog(@"Characteristic test FOUND: %@ %@ %u",aChar.value,aChar.UUID,aChar.properties);
//        if ([aChar.UUID isEqual:[CBUUID UUIDWithString:@"CCC1"]]) {
        if ([aChar.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_TEST_UUID]]) {
        
//        unsigned char command[] = {0x55,0x08,0x00,0x01,0x01,0x01,0x21,0x01,0x01,0x01,0xD9,0xAA};
//        [args_peripheral writeValue:[[NSData alloc] initWithBytes:&command length:12] forCharacteristic:aChar type:CBCharacteristicWriteWithoutResponse];
        
            _deviceObject = [_deviceManagerDictionary objectForKey:[args_peripheral.identifier UUIDString]];
            _deviceObject.characteristic = aChar;
            _deviceObject.connected = YES;
            [_deviceObject setDefaultValue];
        }
//        if ([aChar.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC2_SETCOMMAND_UUID]]) {
//            
//            //        unsigned char command[] = {0x55,0x08,0x00,0x01,0x01,0x01,0x21,0x01,0x01,0x01,0xD9,0xAA};
//            //        [args_peripheral writeValue:[[NSData alloc] initWithBytes:&command length:12] forCharacteristic:aChar type:CBCharacteristicWriteWithoutResponse];
//            
//            _deviceObject = [_deviceManagerDictionary objectForKey:[args_peripheral.identifier UUIDString]];
//            _deviceObject.characteristic2 = aChar;
//        }
    
        
    }
    
//    if ([service.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_SERVICE_COMMONDCHANNEL_UUID]])
//    {
//        for (CBCharacteristic *aChar in service.characteristics)
//        {
//            unsigned char command[17] = {0x55,0x04,0x00,0x01,0x01,0xF9,0xFF,0xAA};
//            
//            [_perpheralConnecting writeValue:[[NSData alloc] initWithBytes:&command length:8] forCharacteristic:aChar type:CBCharacteristicWriteWithoutResponse];
//        }
//    }
//    if ([service.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_SERVICE_READTEMPCHANNEL_UUID]])
//    {
//        for (CBCharacteristic *aChar in service.characteristics)
//        {
//            unsigned char command[17] = {0x55,0x04,0x00,0x01,0x01,0xF9,0xFF,0xAA};
//            
//            [_perpheralConnecting writeValue:[[NSData alloc] initWithBytes:&command length:8] forCharacteristic:aChar type:CBCharacteristicWriteWithoutResponse];
//        }
//    }
}

- (void) peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:
(CBCharacteristic *)characteristic error:(NSError *)error
{
//    NSLog(@"Did write characteristic value : %@ with ID %@", characteristic.value, characteristic.UUID);
//    NSLog(@"With error: %@", [error localizedDescription]);
    
    //code...
}
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
//        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        return;
    }
//    NSLog(@"Characteristic value : %@ with ID %@",  [[NSString alloc] initWithData:characteristic.value encoding:NSASCIIStringEncoding], characteristic.UUID);
//    NSLog(@"Characteristic value : %@ with ID %@",  characteristic.value, characteristic.UUID);
//    [_selectedDevFob addReadingWithRawData:characteristic.value person:_selectedPerson];
//    [self.delegate didUpdateTemperature:[_selectedDevFob.temperature floatValue]];
}

-(void)peripheral:(CBPeripheral *)args_peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    if (error) {
//        NSLog(@"didUpdateNotificationStateForCharacteristic error:%@",error);
    }
//    NSLog(@"characteristic.UUID:%@  value:%@, characteristic.properties:%d,characteristic:%@",characteristic.UUID,characteristic.value,characteristic.properties,characteristic);
//    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_COMMONDCHANNEL_UUID]]) {
//        [_characteristicDictionary setObject:characteristic forKey:[args_peripheral.identifier UUIDString]];
//         [args_peripheral readValueForCharacteristic:characteristic];
//    }
}

@end
