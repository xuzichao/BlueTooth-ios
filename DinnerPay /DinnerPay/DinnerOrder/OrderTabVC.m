//
//  OrderTabVC.m
//  DinnerPay
//
//  Created by xuzichao on 2017/7/19.
//  Copyright © 2017年 FairyTail. All rights reserved.
//

#import "OrderTabVC.h"
#import "OrderPageModel.h"
#import "OrderPrintManager.h"
#import "UIView+Frame.h"

@interface OrderTabVC  () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) OrderPrintManager *printManager;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableModelArray;
@property (nonatomic, assign) PrintOrderBlock printOrderBlock;

@end

@implementation OrderTabVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor greenColor];
    self.tableModelArray = [[NSMutableArray alloc] init];
    self.printManager = [[OrderPrintManager alloc] init];
    
    CGRect tableFrame  = CGRectMake(0, 64, self.view.width, self.view.height - 64);
    self.tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    OrderPageModel *pageModel = [[OrderPageModel alloc] init];
    pageModel.brandName = @"妖精的尾巴餐饮";
    pageModel.restaurantName = @"妖精的小面";
    pageModel.orderId = @"424234234146574234";
    pageModel.address = @"重庆观音桥店新世界大楼B1";
    pageModel.totalPrice = @(66);
    pageModel.endSentence = @"吃不了兜着走，欢迎再次光临";
    pageModel.time = @(1482498418);
    
    ItemModel *item1 = [[ItemModel alloc] init];
    item1.name = @"糖醋排骨";
    item1.price = @(48);
    item1.count = @(1);
    
    
    ItemModel *item2 = [[ItemModel alloc] init];
    item2.name = @"现炸酥肉";
    item2.price = @(23);
    item2.count = @(2);
    
    ItemModel *item3 = [[ItemModel alloc] init];
    item3.name = @"荷塘小炒";
    item3.price = @(21);
    item3.count = @(1);
    
    ItemModel *item4 = [[ItemModel alloc] init];
    item4.name = @"羊肉串";
    item4.price = @(5);
    item4.count = @(10);
    
    ItemModel *item5 = [[ItemModel alloc] init];
    item5.name = @"江小白";
    item5.price = @(12);
    item5.count = @(4);

    pageModel.buyItems = @[item1,item2,item3,item4,item5];
    
    //放了一个测试订单
    [self.tableModelArray addObject:pageModel];
    
    [self.tableView reloadData];

}

- (PrintOrderBlock)printOrderBlock
{
    if (!_printOrderBlock) {
        _printOrderBlock = ^(OrderPageModel *model) {
        };
    }
    return _printOrderBlock;
}

#pragma mark - UITableViewDataSource-Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"deviceId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    OrderPageModel *model = [self.tableModelArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"菜数量:%@",@(model.buyItems.count)];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"价格:%@",model.totalPrice];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OrderPageModel *model = [self.tableModelArray objectAtIndex:indexPath.row];
    
    [self.printManager printOrderWithModel:model completeBlock:self.printOrderBlock];
}

@end
