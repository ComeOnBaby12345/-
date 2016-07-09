//
//  RegisterCheck.m
//  有赏-v1.0
//
//  Created by xfy on 15/12/27.
//  Copyright © 2015年 xfy. All rights reserved.
//

#import "RegisterCheck.h"
#import "AppDelegate.h"
@implementation RegisterCheck
+ (BOOL)validateNickname:(NSString *)nickname//检查昵称是否合法
{
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{4,8}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:nickname];
}
//+ (BOOL)checkTel:(NSString *)str//检查手机号是否合法
//{
//    if ([str length] == 0) {
//    return NO;
//    }
//    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
//    
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    
//    BOOL isMatch = [pred evaluateWithObject:str];
//    return isMatch;
//}
+ (BOOL)checkTel:(NSString *)mobileNum//检查手机号是否合法
{
    
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10 * 中国移动：China Mobile
     11 * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12 */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15 * 中国联通：China Unicom
     16 * 130,131,132,152,155,156,185,186
     17 */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20 * 中国电信：China Telecom
     21 * 133,1349,153,180,189
     22 */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25 * 大陆地区固话及小灵通
     26 * 区号：010,020,021,022,023,024,025,027,028,029
     27 * 号码：七位或八位
     28 */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
+ (BOOL) validatePassword:(NSString *)passWord//检查密码是否合法
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}
+(void)searchInCloud:(NSString*)phone withBlock:(returnUser)returnBlock//检查用户是否已存在数据库中
{
    BmobQuery *query=[BmobUser query];
    [query whereKey:@"username" equalTo:phone];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count!=0)
        {
            returnBlock([array lastObject]);
        }
        else
        {
            returnBlock(nil);
        }
    }];
}
+(void)returnPassword:(NSString*)phone//根据手机号返回密码用于比对用户是否输入正确
{
    BmobQuery *query=[BmobUser query];
   __block NSString *password;
    [query whereKey:@"username" equalTo:phone];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array!=nil)
        {
            BmobUser *user=[array lastObject];
            password=user.password;
        }
    }];
}
+(void)turnToHomeView//跳转到主页
{
    AppDelegate *delegate=[UIApplication sharedApplication].delegate;
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *tabvc=[storyboard instantiateViewControllerWithIdentifier:@"homeTabvc"];
    delegate.window.rootViewController=tabvc;
    
}
@end
