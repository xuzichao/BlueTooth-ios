//
//  BlueToothManager.h
//  DinnerPay
//
//  Created by xuzichao on 2017/7/19.
//  Copyright © 2017年 FairyTail. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BlueToothConst.h"
#import "BTPeripheralModel.h"

@interface BlueToothManager : NSObject

#pragma mark - properties
/** 蓝牙模块状态改变的回调 */
@property (copy, nonatomic) BlueToothStateUpdateBlock                      stateUpdateBlock;
/** 发现一个蓝牙外设的回调 */
@property (copy, nonatomic) BlueToothDiscoverPeripheralBlock               discoverPeripheralBlock;
/** 连接外设完成的回调 */
@property (copy, nonatomic) BlueToothConnectCompletionBlock                connectCompleteBlock;
/** 将数据写入特性中的回调 */
@property (copy, nonatomic) BlueToothWriteToCharacteristicBlock            writeToCharacteristicBlock;

@property (strong, nonatomic, readonly)   CBPeripheral     *connectedPerpheral;  /**< 当前连接的外设 */

/**
 * 每次发送的最大数据长度，因为部分型号的蓝牙打印机一次写入数据过长，会导致打印乱码。
 * iOS 9之后，会调用系统的API来获取特性能写入的最大数据长度。
 * 但是iOS 9之前需要自己测试然后设置一个合适的值。默认值是146，我使用佳博58MB-III的限度。
 * 所以，如果你打印乱码，你考虑将该值设置小一点再试试。
 */
@property (assign, nonatomic)   NSInteger             limitLength;

/**
 *  全局使用单例
 */

+ (instancetype)sharedInstance;

- (void)configureService:(NSString *)serviceUUID
         Characteristics:(NSString *)characteristicUUID;

- (void)stopScan;

- (BOOL)isConnectedPerpheral;

/**
 *  开始搜索蓝牙外设，每次在block中返回一个蓝牙外设信息
 *
 *  @param uuids         服务的CBUUID
 *  @param options        其他可选参数
 */
- (void)scanWithServiceUUIDs:(NSArray<CBUUID *> *)uuids
                     options:(NSDictionary<NSString *, id> *)options;

/**
 *  连接某个蓝牙外设，并查询服务，特性，特性描述
 *
 *  @param peripheral          要连接的蓝牙外设
 *  @param connectOptions      连接的配置参数
 */
- (void)connectPeripheral:(CBPeripheral *)peripheral
           connectOptions:(NSDictionary<NSString *,id> *)connectOptions;

/**
 *  往某个特性中写入数据
 *
 *  @param data           写入的数据
 *  @param block          回调
 */
- (void)writeValue:(NSData *)data completeBlock:(BlueToothWriteToCharacteristicBlock)block;

@end
