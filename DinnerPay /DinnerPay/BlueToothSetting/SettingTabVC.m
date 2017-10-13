//
//  SettingTabVC.m
//  DinnerPay
//
//  Created by xuzichao on 2017/7/19.
//  Copyright © 2017年 FairyTail. All rights reserved.
//

#import "SettingTabVC.h"

#import "BlueToothManager.h"
#import "BlueToothStateView.h"
#import "UIView+Frame.h"

@interface SettingTabVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) BlueToothStateView *topStateView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *deviceArray;

@end

@implementation SettingTabVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        //热敏打印机的服务，是固定的
        [[BlueToothManager sharedInstance] configureService:@"49535343-FE7D-4AE5-8FA9-9FAFD205E455"
                                            Characteristics:@"49535343-8841-43F4-A8D4-ECBE34729BB3"];
        //蓝牙自身的状态
        [BlueToothManager sharedInstance].stateUpdateBlock = [self stateUpdateBlock];
        //发现外设的操作
        [BlueToothManager sharedInstance].discoverPeripheralBlock = [self discoverPeripheralBlock];
        //连接完成的操作
        [BlueToothManager sharedInstance].connectCompleteBlock  = [self connectCompleteBlock];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"蓝牙连接设置";
    self.view.backgroundColor = [UIColor whiteColor];
    self.deviceArray = [[NSMutableArray alloc] init];
    
    CGRect topViewFrame = CGRectMake(0, 64, self.view.width, 100);
    self.topStateView = [[BlueToothStateView alloc] initWithFrame:topViewFrame];
    [self.view addSubview:self.topStateView];
    
    CGRect tableFrame  = CGRectMake(0, self.topStateView.bottom, self.view.width, self.view.height - self.topStateView.bottom);
    self.tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
}

#pragma mark self Block

- (BlueToothStateUpdateBlock)stateUpdateBlock
{
    BlueToothStateUpdateBlock block = ^(CBCentralManager *central) {
        
        BlueToothOptionState viewTipState = BlueToothStateUnknown;
        switch (central.state) {
            case CBManagerStatePoweredOn:
                viewTipState = BlueToothStatePoweredOn;
                break;
            case CBManagerStatePoweredOff:
                viewTipState = BlueToothStatePoweredOff;
                break;
            case CBManagerStateUnsupported:
                viewTipState = BlueToothStateUnsupported;
                break;
            case CBManagerStateUnauthorized:
                viewTipState = BlueToothStateUnauthorized;
                break;
            case CBManagerStateResetting:
                viewTipState = BlueToothStateResetting;
                break;
            case CBManagerStateUnknown:
                viewTipState = BlueToothStateUnknown;
                break;
        }
        [self.topStateView refreshBloothState:viewTipState param:nil];
    };
    return block;
}

- (BlueToothDiscoverPeripheralBlock)discoverPeripheralBlock
{
    BlueToothDiscoverPeripheralBlock block = ^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        if (peripheral.name.length <= 0) {
            [self.topStateView refreshBloothState:BlueToothStateDiscoverDevice param:nil];
            return ;
        }
        
        BTPeripheralModel *model = [[BTPeripheralModel alloc] init];
        model.peripheral = [peripheral copy];
        model.advertisementData = advertisementData;
        model.RSSI = RSSI;
        
        if (![self.deviceArray containsObject:model]) {
            [self.deviceArray addObject:model];
        }
    
        [self.tableView reloadData];
    };
    return block;
}

- (BlueToothConnectCompletionBlock )connectCompleteBlock {
    BlueToothConnectCompletionBlock  block = ^(CBPeripheral *peripheral, NSError *error) {
        
        if (!error) {
            if (peripheral.state == CBPeripheralStateDisconnected) {
                [self.topStateView refreshBloothState:BlueToothStateFail param:nil];
                [[BlueToothManager sharedInstance] scanWithServiceUUIDs:nil options:nil];
            }
            else  if (peripheral.state == CBPeripheralStateConnected) {
                [self.topStateView refreshBloothState:BlueToothStateSucceed param:nil];
            }
        }
        else {
            [self.topStateView refreshBloothState:BlueToothStateFail param:nil];
            [[BlueToothManager sharedInstance] scanWithServiceUUIDs:nil options:nil];
        }
        
        [self.tableView reloadData];
    };
    return block;
}

#pragma mark - UITableViewDataSource-Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.deviceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"deviceId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    BTPeripheralModel *model = [self.deviceArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"名称:%@",model.peripheral.name];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"信号强度:%@",model.RSSI];
    if (model.peripheral.state == CBPeripheralStateConnected) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BTPeripheralModel *model = [self.deviceArray objectAtIndex:indexPath.row];
    [[BlueToothManager sharedInstance] connectPeripheral:model.peripheral connectOptions:nil];
    [[BlueToothManager sharedInstance] stopScan];
}

@end
