//
//  HomeTabBarVC.m
//  BanQuan
//
//  Created by xuzichao on 2017/6/8.
//  Copyright © 2017年 FairyTail. All rights reserved.
//

#import "HomeTabBarVC.h"
#import "OrderTabVC.h"
#import "SettingTabVC.h"


@interface HomeTabBarVC ()<UITabBarControllerDelegate>

@end

@implementation HomeTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    
    [self constructTabVC];
}

//构建
- (void)constructTabVC
{
    NSMutableArray *vcs = [NSMutableArray array];
    
    OrderTabVC *feedVC = [[OrderTabVC alloc] init];
    feedVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"订单消息"
                                                        image:[[UIImage imageNamed:@"tab_icon_3_gray"]
                                                               imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                selectedImage:[[UIImage imageNamed:@"tab_icon_3_green"]
                                                               imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [vcs addObject:feedVC];
    
    SettingTabVC *mineVC = [[SettingTabVC alloc] init];
    mineVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"蓝牙设置"
                                                      image:[[UIImage imageNamed:@"tab_icon_4_gray"]
                                                             imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                              selectedImage:[[UIImage imageNamed:@"tab_icon_4_green"]
                                                             imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [vcs addObject:mineVC];
    
    [self setViewControllers:vcs];
}


#pragma mark tabBarController协议

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
//    self.currentVC = tabBarController.selectedViewController;
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
//    if ([viewController isKindOfClass:[SDPersonalCenterHomeVC class]] || [viewController isKindOfClass:[SDNotificationCenterVC class]]) {
//        if (![[VCManager loginVC] isLogin]) {
//            [[VCManager mainVC] presentVC:[VCManager loginManagerVC] animated:YES];
//            tabBarController.selectedViewController = self.currentVC;
//        }
//    }
}

@end
