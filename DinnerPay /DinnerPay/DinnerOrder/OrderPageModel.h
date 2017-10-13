//
//  OrderPageModel.h
//  DinnerPay
//
//  Created by 卡图不安分 on 2017/7/20.
//  Copyright © 2017年 FairyTail. All rights reserved.
//

#import <JSONModel.h>

@interface ItemModel : JSONModel

@property (nonatomic, copy) NSString *name; //菜名
@property (nonatomic, copy) NSNumber *price;//菜价
@property (nonatomic, copy) NSNumber *count;//数量

@end

@interface OrderPageModel : JSONModel

@property (nonatomic, copy) NSString *barCode; //二维码
@property (nonatomic, copy) NSString *brandName; //品牌
@property (nonatomic, copy) NSString *restaurantName;// 饭店名
@property (nonatomic, copy) NSString *orderId;// 订单ID
@property (nonatomic, copy) NSString *address;// 地址
@property (nonatomic, copy) NSNumber *totalPrice;// 总价
@property (nonatomic, copy) NSString *endSentence;// 结束语
@property (nonatomic, copy) NSNumber *time;//时间
@property (nonatomic, strong) NSArray<ItemModel *> *buyItems;//下的菜单

@end
