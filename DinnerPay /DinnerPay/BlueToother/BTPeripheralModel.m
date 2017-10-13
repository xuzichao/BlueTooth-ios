//
//  BTPeripheralModel.m
//  DinnerPay
//
//  Created by xuzichao on 2017/7/19.
//  Copyright © 2017年 FairyTail. All rights reserved.
//

#import "BTPeripheralModel.h"

@implementation BTPeripheralModel

- (BOOL)isEqual:(id)object
{

    if (object == self) {
        return YES;
    }
    
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    
   BTPeripheralModel *other = (BTPeripheralModel *)object;
    if (![other.peripheral.identifier.UUIDString isEqualToString:self.peripheral.identifier.UUIDString]) {
        return NO;
    }
    
    return YES;
}

- (NSUInteger)hash {
    return [self.peripheral.identifier.UUIDString hash];
}

@end
