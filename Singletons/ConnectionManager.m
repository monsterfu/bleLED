//
//  ConnectionManager.m
//  bleAlarm
//
//  Created by Monster on 14-4-18.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "ConnectionManager.h"

#define TRANSFER_SERVICE_UUID @"FFF0"
#define TRANSFER_CHARACTERISTIC_UUID    @"FFF1"
#define TRANSFER_BATTERY_UUID  @"FFB0"

#define TRANSFER_SERVICE_COMMONDCHANNEL_UUID  @"FFE5"
#define TRANSFER_CHARACTERISTIC_COMMONDCHANNEL_UUID    @"FFE9"
#define TRANSFER_SERVICE_READTEMPCHANNEL_UUID  @"FFE0"
#define TRANSFER_CHARACTERISTIC_READTEMPCHANNEL_UUID  @"FFE4"

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
        _status = BodyCare_Status_Ble_Close;
        manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        
        _peripheralDictionary = [NSMutableDictionary dictionary];
        _characteristicDictionary = [NSMutableDictionary dictionary];
        
        _addedDeviceArray = [NSMutableArray array];
        _newsDeviceArray = [NSMutableArray array];
        
        _deviceManagerDictionary = [NSMutableDictionary dictionary];
        _indexRSSI = 0;
//        NSData* aData = [USER_DEFAULT objectForKey:KEY_DEVICELIST_INFO];
//        _addedDeviceArray = [NSKeyedUnarchiver unarchiveObjectWithData:aData];
//        if (_addedDeviceArray == nil) {
//            _addedDeviceArray = [NSMutableArray array];
//        }else{
//            
//            for (TemperatureFob* device in _addedDeviceArray) {
//                [_deviceManagerDictionary setObject:device forKey:device.uuid];
//            }
//        }
    }
    return self;
}

-(void)dealloc
{
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:NSNotificationCenter_dismissRecordChange object:nil];
}

-(void)deviceDismissInfoChange
{
//    [USER_DEFAULT removeObjectForKey:KEY_DEVICELIST_INFO];
//    NSData* aDate = [NSKeyedArchiver archivedDataWithRootObject:_addedDeviceArray];
//    [USER_DEFAULT setObject:aDate forKey:KEY_DEVICELIST_INFO];
//    [USER_DEFAULT synchronize];
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
                _status = BodyCare_Status_Ble_Open;
            }
            else
            {
//                [_delegate isBluetoothEnabled:NO];
                _status = BodyCare_Status_Ble_Close;
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

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)args_peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    
    //屏蔽不可连接设备
    BOOL connectable = [[advertisementData objectForKey:@"kCBAdvDataIsConnectable"]boolValue];
    if (!connectable) {
        return;
    }
    if (![[args_peripheral name] isEqualToString:@"iBody-Manridy"]) {
//        NSLog(@"Discovered unknown device, %@", [args_peripheral name]);
        return;
    }
    
    NSDictionary *serviceData = [advertisementData objectForKey:@"kCBAdvDataServiceData"];
//    if (!serviceData ||
//        (![serviceData objectForKey:[TemperatureFob thermometerServiceUUID]] ||
//         ![serviceData objectForKey:[TemperatureFob batteryServiceUUID]]))
//    {
////        NSLog(@"Discovered unknown device, %@", [args_peripheral name]);
////        return;
//    }
    //屏蔽已连接设备
//    if ([_peripheralDictionary objectForKey:args_peripheral.identifier]) {
//        return;
//    }
//    
//    _selectedPerson = [PersonDetailInfo PersonWithPersonId:[USER_DEFAULT stringForKey:KEY_PERSONID]];
//    _selectedDevFob = [_selectedPerson foundFobWithUUid:[args_peripheral.identifier UUIDString]];
//    
//    if (_selectedDevFob == nil)
//    {
//        _selectedDevFob = [_selectedPerson createFobWithName:[args_peripheral name] UUid:[[args_peripheral identifier]UUIDString]];
////        _selectedDevFob.delegate = self;
//        _status = BodyCare_Status_Ble_DiscoverDevice;
//        [self.delegate didDiscoverDevice:_selectedDevFob];
//    }
    if (_perpheralConnecting == nil) {
        _perpheralConnecting = args_peripheral;
        [manager connectPeripheral:args_peripheral options:nil];
    }
}

-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)arg_peripheral error:(NSError *)error{
    NSLog(@"Connecting Fail: %@",error);
    [manager connectPeripheral:arg_peripheral options:nil];
}


- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)persipheral error:(NSError *)error
{
    NSLog(@"disconnect!!!!  error: %@",error);
    _status = BodyCare_Status_Ble_DisconnectDevice;
    
    
    [manager connectPeripheral:persipheral options:nil];
}

-(void)peripheralDidUpdateRSSI:(CBPeripheral *)arg_peripheral error:(NSError *)error
{
//    NSLog(@"[[[[[[[[[[[[[[[peripheral.ddd:%f]]]]]]]]]]]]]]]",[arg_peripheral.RSSI floatValue]);
}

-(void)updateRSSIAction
{
    [_peripheral readRSSI];
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)args_peripheral
{
    [args_peripheral setDelegate:self];
    [args_peripheral readRSSI];
    [args_peripheral discoverServices:nil];
}

-(void)peripheral:(CBPeripheral *)args_peripheral didDiscoverServices:(NSError *)error{
    if (error) {
        NSLog(@"Error discover service: %@",[error localizedDescription]);
        return;
    }
    
    for(CBService *service in args_peripheral.services){
        NSLog(@"Service found with UUID: %@",service.UUID);
        if ([service.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_SERVICE_COMMONDCHANNEL_UUID]]) {
            [args_peripheral discoverCharacteristics:nil forService:service];
        }else if ([service.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_SERVICE_READTEMPCHANNEL_UUID]]) {
            [args_peripheral discoverCharacteristics:nil forService:service];
        }
    }
    
}

-(void)peripheral:(CBPeripheral *)args_peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    
    if (error) {
        NSLog(@"Error discover Character");
        //;
        return;
    }
    if ([service.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_SERVICE_COMMONDCHANNEL_UUID]])
    {
        for (CBCharacteristic *aChar in service.characteristics)
        {
//            NSLog(@"Characteristic FOUND111: %@ %@ %u",aChar.value,aChar.UUID,aChar.properties);
//            [_peripheralDictionary setObject:args_peripheral forKey:_selectedDevFob.uuid];
//            [_characteristicDictionary setObject:aChar forKey:_selectedDevFob.uuid];
            [self startMeasureTemperature];
        }
    }
    if ([service.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_SERVICE_READTEMPCHANNEL_UUID]])
    {
        for (CBCharacteristic *aChar in service.characteristics)
        {
//            NSLog(@"Characteristic FOUND: %@ %@ %u",aChar.value,aChar.UUID,aChar.properties);
            [args_peripheral setNotifyValue:YES forCharacteristic:aChar];
        }
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        return;
    }
    NSLog(@"Characteristic value : %@ with ID %@",  [[NSString alloc] initWithData:characteristic.value encoding:NSASCIIStringEncoding], characteristic.UUID);
    NSLog(@"Characteristic value : %@ with ID %@",  characteristic.value, characteristic.UUID);
//    [_selectedDevFob addReadingWithRawData:characteristic.value person:_selectedPerson];
//    [self.delegate didUpdateTemperature:[_selectedDevFob.temperature floatValue]];
}

-(void)peripheral:(CBPeripheral *)args_peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    if (error) {
        NSLog(@"didUpdateNotificationStateForCharacteristic error:%@",error);
    }
    NSLog(@"characteristic.UUID:%@  value:%@, characteristic.properties:%d,characteristic:%@",characteristic.UUID,characteristic.value,characteristic.properties,characteristic);
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_COMMONDCHANNEL_UUID]]) {
        [_characteristicDictionary setObject:characteristic forKey:[args_peripheral.identifier UUIDString]];
         [args_peripheral readValueForCharacteristic:characteristic];
    }
}

#pragma mark -- device commond about

- (void) startMeasureTemperature
{
    unsigned char command[17] = {0x3C,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x6D,0x04,0xFF,0xFF,0xFF,0xFF,0x03,0x3E};
//    CBPeripheral* _selectedPeripheral = [_peripheralDictionary objectForKey:_selectedDevFob.uuid];
//    CBCharacteristic* _selectedCharacteristic = [_characteristicDictionary objectForKey:_selectedDevFob.uuid];
//    [_selectedPeripheral writeValue:[[NSData alloc] initWithBytes:&command length:17] forCharacteristic:_selectedCharacteristic type:CBCharacteristicWriteWithoutResponse];
    _status = BodyCare_Status_Ble_MeasureTemperature;
}
- (void) standByTemperature
{
    unsigned char command[17] = {0x3C,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x6D,0x04,0xFF,0xFF,0xFF,0xFF,0x03,0x3E};
//    CBPeripheral* _selectedPeripheral = [_peripheralDictionary objectForKey:_selectedDevFob.uuid];
//    CBCharacteristic* _selectedCharacteristic = [_characteristicDictionary objectForKey:_selectedDevFob.uuid];
//    [_selectedPeripheral writeValue:[[NSData alloc] initWithBytes:&command length:17] forCharacteristic:_selectedCharacteristic type:CBCharacteristicWriteWithoutResponse];
}
- (void) sendWarningTemperature
{
    unsigned char command[17] = {0x3C,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x6D,0x04,0xFF,0xFF,0xFF,0xFF,0x03,0x3E};
//    CBPeripheral* _selectedPeripheral = [_peripheralDictionary objectForKey:_selectedDevFob.uuid];
//    CBCharacteristic* _selectedCharacteristic = [_characteristicDictionary objectForKey:_selectedDevFob.uuid];
//    [_selectedPeripheral writeValue:[[NSData alloc] initWithBytes:&command length:17] forCharacteristic:_selectedCharacteristic type:CBCharacteristicWriteWithoutResponse];
}

@end
