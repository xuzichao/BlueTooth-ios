//
//  OrderPrintManager.h
//  DinnerPay
//
//  Created by 卡图不安分 on 2017/7/20.
//  Copyright © 2017年 FairyTail. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderPageModel.h"

typedef void(^PrintOrderBlock)(OrderPageModel *model);

@interface OrderPrintManager : NSObject

- (void)printOrderWithModel:(OrderPageModel *)model completeBlock:(PrintOrderBlock)block;

@end
