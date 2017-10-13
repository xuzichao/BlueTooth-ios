//
//  BlueToothStateView.h
//  DinnerPay
//
//  Created by xuzichao on 2017/7/19.
//  Copyright © 2017年 FairyTail. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlueToothConst.h"

@interface BlueToothStateView : UIView

- (void)refreshBloothState:(BlueToothOptionState)state param:(NSDictionary *)params;

@end
