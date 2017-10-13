//
//  BTPeripheralModel.h
//  DinnerPay
//
//  Created by xuzichao on 2017/7/19.
//  Copyright © 2017年 FairyTail. All rights reserved.
//

#import "BlueToothConst.h"

@interface BTPeripheralModel : NSObject

@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, copy) NSDictionary *advertisementData;
@property (nonatomic, copy) NSNumber *RSSI;

@end
