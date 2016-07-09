//
//  MyViewController.m
//  有赏-v1.0
//
//  Created by xfy on 16/1/8.
//  Copyright © 2016年 xfy. All rights reserved.
//

#import "MyViewController.h"
#import "PCRequest.h"
@interface MyViewController ()
{
    UITableViewController *myOrderformVc;
}
@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"newsCount"];
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(checkNewsCount) userInfo:nil repeats:YES];//检查有没有新消息
    NSArray *normalImageNameArray=@[@"主页",@"我的悬赏",@"必答",@"个人中心"];
    NSArray *selectImageNameArray=@[@"主页选中",@"我的悬赏选中",@"必答选中",@"个人中心选中"];
    for (int i=0; i<=3; i++)
    {
        UIImage *homeImage = [UIImage imageNamed:normalImageNameArray[i]];
        homeImage = [homeImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//禁止渲染
        UIImage *homeImageSelect = [UIImage imageNamed:selectImageNameArray[i]];
        homeImageSelect = [homeImageSelect imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//禁止渲染
         UITableViewController *vc=[self.viewControllers objectAtIndex:i];//主页
        [vc.tabBarItem setSelectedImage:homeImageSelect];
        [vc.tabBarItem setImage:homeImage];

    }
    //    //改变字体选中颜色
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:18/255.0 green:150/255.0 blue:219/255.0 alpha:1]}forState:UIControlStateSelected];
    [self setBadgeValue];
}
-(void)checkNewsCount
{
    [PCRequest  getBmobObiectArrayWithClassName:ORDERFORM1 Key:@"userPhone" equalTo:[[NSUserDefaults standardUserDefaults]objectForKey:@"phone"] returnBlock:^(id request) {
        NSArray *requestArray=request;
        NSString *newsCount=[[NSUserDefaults standardUserDefaults]objectForKey:@"newsCount"];
        if (![newsCount intValue]==requestArray.count)
        {
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%lu",requestArray.count] forKey:@"newsCount"];
            [self setBadgeValue];
        }
    }];
}
-(void)setBadgeValue
{
    //设置tabBar角标
    NSString *newsCount=[[NSUserDefaults standardUserDefaults]objectForKey:@"newsCount"];
    if ([newsCount isEqualToString:@"0"]) {
        
        myOrderformVc.tabBarItem.badgeValue = nil; //设置tabBar的角标
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;// 设置应用程序的角标
    }else
    {
        myOrderformVc.tabBarItem.badgeValue = newsCount;
        [UIApplication sharedApplication].applicationIconBadgeNumber =[newsCount intValue];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
