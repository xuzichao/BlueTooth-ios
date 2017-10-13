//
//  BlueToothStateView.m
//  DinnerPay
//
//  Created by xuzichao on 2017/7/19.
//  Copyright © 2017年 FairyTail. All rights reserved.
//

#import "BlueToothStateView.h"
#import "UIView+Frame.h"

@interface BlueToothStateView ()

@property (nonatomic, strong) UILabel *deviceNameLabel;
@property (nonatomic, strong) UILabel *stateTipLabel;
@property (nonatomic, assign) BlueToothOptionState state;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation BlueToothStateView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor yellowColor];
        
        self.deviceNameLabel = [[UILabel alloc] init];
        self.deviceNameLabel.font = [UIFont systemFontOfSize:14];
        self.deviceNameLabel.textColor = [UIColor blueColor];
        [self addSubview:self.deviceNameLabel];
        
        self.stateTipLabel = [[UILabel alloc] init];
        self.stateTipLabel.text = @"未连接";
        self.stateTipLabel.font = [UIFont systemFontOfSize:14];
        self.stateTipLabel.textColor = [UIColor redColor];
        [self addSubview:self.stateTipLabel];
        
        self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:self.indicatorView];
    
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    [self refreshUI];
}

- (void)refreshUI
{
    [self.deviceNameLabel sizeToFit];
    self.deviceNameLabel.left = 20;
    self.deviceNameLabel.top = 20;
    
    [self.stateTipLabel sizeToFit];
    self.stateTipLabel.left = 20;
    self.stateTipLabel.top = 20 + self.deviceNameLabel.bottom;
    
    self.indicatorView.width = 20;
    self.indicatorView.height = 20;
    self.indicatorView.right = self.width - 20;
    self.indicatorView.centerY = self.height/2;
}

- (void)refreshBloothState:(BlueToothOptionState)state param:(NSDictionary *)params
{
    self.state = state;
    [self refresTipUI:state];
    if (state == BlueToothStateSucceed) {
        self.deviceNameLabel.text = [params valueForKey:@"deviceName"];
    }
    [self refreshUI];
}

- (void)refresTipUI:(BlueToothOptionState)state
{
    switch (state) {
        case BlueToothStateUnknown:
            self.stateTipLabel.text = @"未识别类型";
            [self.indicatorView startAnimating];
            break;
        case BlueToothStateResetting:
            self.stateTipLabel.text =  @"重置";
            [self.indicatorView startAnimating];
            break;
        case BlueToothStateUnsupported:
            self.stateTipLabel.text = @"不支持类型";
            [self.indicatorView startAnimating];
            break;
        case BlueToothStateUnauthorized:
            self.stateTipLabel.text = @"连接未授权";
            [self.indicatorView startAnimating];
            break;
        case BlueToothStatePoweredOff:
            self.stateTipLabel.text = @"蓝牙未打开";
            [self.indicatorView stopAnimating];
            break;
        case BlueToothStatePoweredOn:
            self.stateTipLabel.text = @"蓝牙已打开";
            [self.indicatorView startAnimating];
            break;
        case BlueToothStateDiscoverDevice:
            [self.indicatorView startAnimating];
            break;
        case BlueToothStateConnectioning:
            self.stateTipLabel.text = @"正在连接";
            [self.indicatorView startAnimating];
            break;
        case BlueToothStateSucceed:
            self.stateTipLabel.text = @"连接成功";
            [self.indicatorView stopAnimating];
            break;
        case BlueToothStateFail:
            self.stateTipLabel.text = @"连接失败";
            [self.indicatorView startAnimating];
            break;
        default:
            break;
    }
}


@end
