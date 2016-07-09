//
//  AppDelegate.m
//  有赏-v1.0
//
//  Created by xfy on 15/12/27.
//  Copyright © 2015年 xfy. All rights reserved.
//

#import "AppDelegate.h"
#import <SMS_SDK/SMSSDK.h>
#import <AlipaySDK/AlipaySDK.h>
#import <BmobPay/BmobPay.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "LoginViewController.h"
#import "GuideViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //2.设置根视图控制器（就是你要显示的视图控制器）
    //选中状态默认被渲染成蓝色
    UIStoryboard *board=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *loginNv=[board instantiateViewControllerWithIdentifier:@"loginNv"];
    //判断是否是第一次启动 如果是进入引导页
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"FirstLoad"]==nil){
        GuideViewController *guideVc = [[GuideViewController alloc] init];
        self.window.rootViewController = guideVc;
    }else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"FirstLoad"] isEqualToString:@"1"]){
        
        self.window.rootViewController =loginNv;
    }
    [Bmob registerWithAppKey:@"6b776d0aaaa39a9e05254406fdf01659"];//Bmob初始化代码
    [SMSSDK registerApp:@"de99e63769f0" withSecret:@"77054fa418203dce6985151517650b3f"];//短信验证初始化代码
    [BmobPaySDK registerWithAppKey:@"6b776d0aaaa39a9e05254406fdf01659"];//Bmob-ios支付
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    //请求发送通知许可
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>8.0) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    //3.让主窗口显示
    [self.window makeKeyAndVisible];
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.host isEqualToString:@"safepay"]) {
        
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {}];
    }
    return YES;
}
@end
