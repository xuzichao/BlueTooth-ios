//
//  BlueToothManager.m
//  DinnerPay
//
//  Created by xuzichao on 2017/7/19.
//  Copyright © 2017年 FairyTail. All rights reserved.
//

#import "BlueToothManager.h"


@interface BlueToothManager ()<CBCentralManagerDelegate,CBPeripheralDelegate>

@property (nonatomic, strong) CBCentralManager *centalManager; //中心
@property (nonatomic, strong) CBPeripheral *connectedPerpheral; //外设
@property (nonatomic, strong) CBService *service; //服务
@property (nonatomic, strong) CBCharacteristic *characteristic; //特征

@property (nonatomic, copy) NSString *perpheralUUID;
@property (nonatomic, copy) NSString *serviceUUID;
@property (nonatomic, copy) NSString *characteristicUUID;

@end

@implementation BlueToothManager
{
    NSString *_perpheralUUID;
}

+ (instancetype)sharedInstance
{
    static BlueToothManager *obj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[BlueToothManager alloc] init];
    });
    
    return obj;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSDictionary *options = @{CBCentralManagerOptionShowPowerAlertKey:@(YES)};
        self.centalManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue() options:options];
    }
    
    return self;
}


- (void)configureService:(NSString *)serviceUUID
         Characteristics:(NSString *)characteristicUUID
{
    self.serviceUUID = serviceUUID;
    self.characteristicUUID = characteristicUUID;
}

- (void)stopScan
{
    [self.centalManager stopScan];
}

- (BOOL)isConnectedPerpheral
{
    return self.connectedPerpheral && self.connectedPerpheral.state == CBPeripheralStateConnected && self.centalManager.state == CBManagerStatePoweredOn;
}

- (NSString *)perpheralUUID
{
    if (!_perpheralUUID) {
        _perpheralUUID = [[NSUserDefaults standardUserDefaults] stringForKey:@"perpheralUUID"];
    }
    return _perpheralUUID;
}

- (void)setPerpheralUUID:(NSString *)perpheralUUID
{
    if (![_perpheralUUID isEqualToString:perpheralUUID]) {
        _perpheralUUID = perpheralUUID;
        [[NSUserDefaults standardUserDefaults] setValue:perpheralUUID forKey:@"perpheralUUID"];
    }
}

- (void)scanWithServiceUUIDs:(NSArray<CBUUID *> *)uuids
                     options:(NSDictionary<NSString *, id> *)options
{
    [self.centalManager scanForPeripheralsWithServices:uuids options:options];
}


- (void)connectPeripheral:(CBPeripheral *)peripheral
           connectOptions:(NSDictionary<NSString *,id> *)connectOptions
{
    if (self.connectedPerpheral != peripheral && self.connectedPerpheral) {
        [self.centalManager cancelPeripheralConnection:self.connectedPerpheral];
    }
    
    if (peripheral) {
        self.connectedPerpheral = peripheral;
        [self.centalManager connectPeripheral:self.connectedPerpheral  options:connectOptions];
        self.connectedPerpheral.delegate = self;
    }
}

- (void)writeValue:(NSData *)data completeBlock:(BlueToothWriteToCharacteristicBlock)block
{
    [self.connectedPerpheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
}


#pragma mark CBCentralManagerDelegate -- 扫描外设
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (!self.isConnectedPerpheral && central.state == CBManagerStatePoweredOn) {
        [self scanWithServiceUUIDs:nil options:nil];
    }
    
    if (self.stateUpdateBlock) {
        self.stateUpdateBlock(central);
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    if (self.discoverPeripheralBlock) {
        self.discoverPeripheralBlock(central, peripheral, advertisementData, RSSI);
    }
}

#pragma mark CBPeripheralDelegate -- 连接外设

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    if (self.connectCompleteBlock) {
        self.connectCompleteBlock(peripheral, nil);
    }
    
    [self.connectedPerpheral discoverServices:nil];
    self.perpheralUUID = peripheral.identifier.UUIDString;
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error
{
    if (self.connectCompleteBlock) {
        self.connectCompleteBlock(peripheral, error);
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error
{
    [central cancelPeripheralConnection:peripheral];
    
    if (self.connectCompleteBlock) {
        self.connectCompleteBlock(peripheral, error);
    }
}

#pragma mark CBPeripheralDelegate -- Service连接

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error
{
    if (!error) {
        // 找到对应服务
        for (CBService *service in peripheral.services) {
            if ([service.UUID.UUIDString isEqualToString:self.serviceUUID]) {
                self.service = service;
                [service.peripheral discoverCharacteristics:nil forService:service];
                break;
            }
        }
    }
}

#pragma mark CBPeripheralDelegate -- Characteristic连接

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error
{

    for (CBCharacteristic *characteristic in service.characteristics) {
        
        
        if (characteristic.properties & CBCharacteristicPropertyWrite ||characteristic.properties & CBCharacteristicPropertyWriteWithoutResponse) {
            
            if ([characteristic.UUID.UUIDString isEqualToString:self.characteristicUUID] ) {
                self.characteristic = characteristic;
                break;
            }
            
        }
        
        if (characteristic.properties & CBCharacteristicPropertyNotify) {
            
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
        
        if (characteristic.properties & CBCharacteristicPropertyRead) {
            
            [peripheral readValueForCharacteristic:characteristic];
        }
    }
}


#pragma mark CBPeripheralDelegate -- Characteristic读取数据

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error
{
    
}

#pragma mark CBPeripheralDelegate -- Characteristic写入数据的回调

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error
{
    if (self.writeToCharacteristicBlock) {
        self.writeToCharacteristicBlock(characteristic, error);
    }
}



@end
