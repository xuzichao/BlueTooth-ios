//
//  BlueToothConst.h
//  BlueToothBluetoothDemo
//
//  Created by xuzichao on 16/4/29.
//  Copyright © 2016年 Halley. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

#ifndef BlueToothConst_h
#define BlueToothConst_h

typedef NS_ENUM(NSInteger, BlueToothOptionState) {
    
    BlueToothStateUnknown,  //蓝牙未识别
    BlueToothStateResetting, //蓝牙重置
    BlueToothStateUnsupported,  //蓝牙不支持
    BlueToothStateUnauthorized,  //蓝牙未授权
    BlueToothStatePoweredOff,  //蓝牙已关闭
    BlueToothStatePoweredOn, //蓝牙已打开
    BlueToothStateConnectioning,       //蓝牙正在连接
    BlueToothStateDiscoverDevice,       //蓝牙发现设备
    BlueToothStateSucceed,            //蓝牙连接成功
    BlueToothStateFail,         //蓝牙连接失败
};

#pragma mark ------------------- block的定义 --------------------------
/** 蓝牙状态改变的block */
typedef void(^BlueToothStateUpdateBlock)(CBCentralManager *central);

/** 发现一个蓝牙外设的block */
typedef void(^BlueToothDiscoverPeripheralBlock)(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI);

/** 连接完成的block,失败error就不为nil */
typedef void(^BlueToothConnectCompletionBlock)(CBPeripheral *peripheral, NSError *error);

/** 搜索到连接上的蓝牙外设的服务block */
typedef void(^BlueToothDiscoveredServicesBlock)(CBPeripheral *peripheral, NSArray *services, NSError *error);

/** 搜索某个服务的子服务 的回调 */
typedef void(^BlueToothDiscoveredIncludedServicesBlock)(CBPeripheral *peripheral,CBService *service, NSArray *includedServices, NSError *error);

/** 搜索到某个服务中的特性的block */
typedef void(^BlueToothDiscoverCharacteristicsBlock)(CBPeripheral *peripheral, CBService *service, NSArray *characteristics, NSError *error);

/** 收到某个特性值更新的回调 */
typedef void(^BlueToothNotifyCharacteristicBlock)(CBPeripheral *peripheral,CBCharacteristic *characteristic,NSError *error);

/** 查找到某个特性的描述 block */
typedef void(^BlueToothDiscoverDescriptorsBlock)(CBPeripheral *peripheral,CBCharacteristic *characteristic,NSArray *descriptors, NSError *error);

/** 获取特性中的值 */
typedef void(^BlueToothValueForCharacteristicBlock)(CBCharacteristic *characteristic, NSData *value, NSError *error);

/** 获取描述中的值 */
typedef void(^BlueToothValueForDescriptorBlock)(CBDescriptor *descriptor,NSData *data,NSError *error);

/** 往特性中写入数据的回调 */
typedef void(^BlueToothWriteToCharacteristicBlock)(CBCharacteristic *characteristic, NSError *error);

/** 往描述中写入数据的回调 */
typedef void(^BlueToothWriteToDescriptorBlock)(CBDescriptor *descriptor, NSError *error);

/** 获取蓝牙外设信号的回调 */
typedef void(^BlueToothGetRSSIBlock)(CBPeripheral *peripheral,NSNumber *RSSI, NSError *error);

#endif /* BlueToothConst_h */
