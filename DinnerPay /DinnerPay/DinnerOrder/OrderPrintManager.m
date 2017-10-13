//
//  OrderPrintManager.m
//  DinnerPay
//
//  Created by 卡图不安分 on 2017/7/20.
//  Copyright © 2017年 FairyTail. All rights reserved.
//

#import "OrderPrintManager.h"

#import "JBPrinter.h"
#import "BlueToothManager.h"

@interface OrderPrintManager ()

@property (nonatomic, strong) NSMutableArray *printModelArray;
@property (nonatomic, assign) PrintOrderBlock printOrderBlock;
@property (nonatomic, assign) BOOL isWorking;

@end

@implementation OrderPrintManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.printModelArray = [[NSMutableArray alloc] init];
        self.isWorking = NO;
    }
    return self;
}

- (void)printOrderWithModel:(OrderPageModel *)model completeBlock:(PrintOrderBlock)block
{
    [self.printModelArray addObject:model];
    if (!self.printOrderBlock || block != self.printOrderBlock) {
        self.printOrderBlock = block;
    }
    
    if (!self.isWorking) {
        self.isWorking = YES;
        [self startPrintEngine];
    }
}

- (void)startPrintEngine
{
    __block BOOL connected = [[BlueToothManager sharedInstance] isConnectedPerpheral];
    if (self.printModelArray.count > 0 && connected) {
        
        OrderPageModel *model = [self.printModelArray firstObject];
        JBPrinter *printer = [self getPrinterWithModel:model];
        NSData *data = [printer getFinalData];
            
        [[BlueToothManager sharedInstance] writeValue:data completeBlock:nil];
        /*
         ^(CBCharacteristic *characteristic, NSError *error) {
         connected = [[BlueToothManager sharedInstance] isConnectedPerpheral];
         if (!error && connected) {
         if (self.printOrderBlock) {
         self.printOrderBlock(model);
         }
         [self.printModelArray removeObject:model];
         [self startPrintEngine];
         }
         }
         */
    }
    else {
        self.isWorking = NO;
    }
}

- (JBPrinter *)getPrinterWithModel:(OrderPageModel *)model
{
    JBPrinter *printer = [[JBPrinter alloc] init];
    
    //品牌、店名
    [printer appendText:model.brandName alignment:JBTextAlignmentCenter fontSize:JBFontSizeTitleSmalle];
    [printer appendText:model.restaurantName alignment:JBTextAlignmentCenter fontSize:JBFontSizeTitleMiddle];
    
    // 条形码
    [printer appendBarCodeWithInfo:model.barCode];
    [printer appendSeperatorLine];
    
    //时间、订单、地址
    NSDate *orderDate = [NSDate dateWithTimeIntervalSince1970:model.time.doubleValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    NSString *dateString = [dateFormatter stringFromDate:orderDate];

    [printer appendTitle:@"时间:" value:dateString valueOffset:150];
    [printer appendTitle:@"订单:" value:model.orderId valueOffset:150];
    [printer appendText:model.address alignment:JBTextAlignmentLeft];
    
    [printer appendSeperatorLine];
    
    //单品
    [printer appendLeftText:@"商品" middleText:@"数量" rightText:@"单价" isTitle:YES];
    
    CGFloat total = 0.0;
    for (ItemModel *obj in model.buyItems) {
        [printer appendLeftText:obj.name middleText:obj.count.stringValue rightText:obj.price.stringValue isTitle:NO];
        total += [obj.price floatValue] * [obj.count intValue];
    }
    
    [printer appendSeperatorLine];
    
    //总计
    NSString *totalStr = [NSString stringWithFormat:@"%.2f",total];
    [printer appendTitle:@"总计:" value:totalStr];
    
    [printer appendSeperatorLine];
    
    // 二维码
    [printer appendText:@"指令方式打印二维码" alignment:JBTextAlignmentCenter];
    [printer appendQRCodeWithInfo:@"www.baidu.com" size:12];
    
    [printer appendSeperatorLine];
    
    //谢谢光临
    [printer appendText:model.endSentence alignment:JBTextAlignmentCenter];
    
    return printer;
}

@end
