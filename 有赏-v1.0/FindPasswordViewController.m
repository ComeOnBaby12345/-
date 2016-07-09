//
//  FindPasswordViewController.m
//  有赏-v1.0
//
//  Created by xfy on 16/1/7.
//  Copyright © 2016年 xfy. All rights reserved.
//

#import "FindPasswordViewController.h"
#import "RegisterCheck.h"
#import <SMS_SDK/SMSSDK.h>
#import "PCRequest.h"
#import <MBProgressHUD.h>
@interface FindPasswordViewController ()
{
    NSString *userphone;
    MBProgressHUD *hud;
}
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *securityCode;
@property (weak, nonatomic) IBOutlet UITextField *password;

- (IBAction)getSecurityCode:(id)sender;
- (IBAction)compelete:(id)sender;
@end

@implementation FindPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    hud=[[MBProgressHUD alloc]initWithView:self.view];
    hud.labelText=@"发送中";
    [self.view addSubview:hud];
    // Do any additional setup after loading the view.
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

- (IBAction)getSecurityCode:(id)sender
{
    [hud show:YES];
    //检查用户是否存在，不存在即不合法
    [RegisterCheck searchInCloud:self.phone.text withBlock:^(id request) {
        
        if (request==nil) {
            [self.view makeToast:@"手机号不存在" duration:1 position:CSToastPositionCenter];
                [hud hide:YES];
        }
        else
        {
            [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phone.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
                if (!error) {
                    NSLog(@"验证码发送成功");
                    [hud hide:YES];
                    //提示发送验证码成功
                       [self.view makeToast:@"验证码发送成功" duration:1 position:CSToastPositionCenter];
                    userphone=self.phone.text;//防止在验证码发送成功后用户又修改了手机号，从而导致在服务器寻找用户时出错
                }
                else
                {
                    NSLog(@"%@",error);
                    //提示发送验证码失败
                     [hud hide:YES];
                       [self.view makeToast:@"发送验证码失败" duration:1 position:CSToastPositionCenter];
                }
            }];
        }
    }];
}
- (IBAction)compelete:(id)sender
{
    if ([CheckNetWork connectedToNetwork]) {
        [SMSSDK commitVerificationCode:self.securityCode.text phoneNumber:self.phone.text zone:@"86" result:^(NSError *error) {
            if (error) {
                //验证码错误
                NSLog(@"%@",error);
                [self.view makeToast:@"验证码错误" duration:1 position:CSToastPositionCenter];
            }
            else
            {
                //手机号验证成功
                NSLog(@"验证码验证成功");
                [self.view makeToast:@"验证成功" duration:1 position:CSToastPositionCenter];
                [self changePassword];
            }
        }];
    }
    else
    {
        [self.view makeToast:@"请检查网络连接" duration:1 position:CSToastPositionCenter];
    }
}
-(void)changePassword
{
    [PCRequest getArrayWithKey:@"username" equalTo:userphone returnBlock:^(id request) {
        BmobUser *bUser=(BmobUser*)request[0];
        [bUser setObject:self.password.text forKey:@"password"];
        [bUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful)
            {
                NSLog(@"密码修改成功");
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }];
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
