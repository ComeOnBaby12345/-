//
//  RegisterViewController.m
//  有赏-v1.0
//
//  Created by xfy on 15/12/27.
//  Copyright © 2015年 xfy. All rights reserved.
//
#import "RegisterViewController.h"
#import "RegisterCheck.h"
#import "AppDelegate.h"
#import <SMS_SDK/SMSSDK.h>
#import <UIView+Toast.h>
#import <MBProgressHUD.h>
@interface RegisterViewController ()<UITextFieldDelegate>
{
    MBProgressHUD *hud;
}
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *securityCode;
@property (weak, nonatomic) IBOutlet UISwitch *sharePersonMessage;
@property (weak, nonatomic) IBOutlet UITextView *privacyMessageView;
@end
@implementation RegisterViewController
- (IBAction)getSecurityCode:(id)sender {
    [hud show:YES];
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phone.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (!error) {
             NSLog(@"验证码发送成功");
            //提示发送验证码成功
            [self.view makeToast:@"验证码发送成功" duration:1.5 position:CSToastPositionCenter];
            [hud hide:YES];
        }
        else
        {
            NSLog(@"%@",error);
            //提示发送验证码失败
            [hud hide:YES];
            [self.view makeToast:@"验证码发送失败" duration:1.5 position:CSToastPositionCenter];
        }
    }];
}
- (IBAction)complete:(id)sender
{
    if ([CheckNetWork connectedToNetwork]) {
        [hud show:YES];
        if ([self check])//手机号、密码、昵称合法,验证码输入正确
        {
            BmobUser *newUser=[[BmobUser alloc]init];
            if (_sharePersonMessage.on)//检查是否开启共享数据
            {
                [newUser setObject:@"1" forKey:@"privacy"];
            }
            else
            {
                [newUser setObject:@"0" forKey:@"privacy"];
            }
            [newUser setUsername:self.phone.text];
            [newUser setPassword:self.password.text];
            [newUser setObject:@"无昵称" forKey:@"nickName"];
            [newUser setObject:@"0" forKey:@"photoUrl"];
            [newUser setObject:@"0" forKey:@"name"];//用户称号
            [newUser setObject:@"20" forKey:@"treasury"];//用户虚拟账户余额
            [newUser signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                if (!isSuccessful)
                {
                    //注册失败
                    NSLog(@"%@",error);
                    //错误处理
                    [hud hide:YES];
                    [self.view makeToast:@"注册失败" duration:1.5 position:CSToastPositionCenter];
                }
                else
                {
                    //注册成功
                    NSLog(@"注册成功");
                    [hud hide:YES];
                    [self.view makeToast:@"注册成功" duration:1.5 position:CSToastPositionCenter];
                    //提示用户注册成功并跳转到主页
                    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                    [user setObject:self.phone.text forKey:@"phone"];
                    [RegisterCheck turnToHomeView];
                }
            }];
        }
        else
        {
            NSLog(@"错误");
            [hud hide:YES];
        }
    }
    else
    {
        [self.view makeToast:@"请检查网络连接" duration:1 position:CSToastPositionCenter];
    }
}
-(BOOL)check
{
    __block BOOL mark=YES;
    if (![RegisterCheck checkTel:self.phone.text]) {
        //提示用户手机号不合法
        [self.view makeToast:@"手机号不合法" duration:1 position:CSToastPositionCenter];
        return NO;
    }
    if (![RegisterCheck validatePassword:self.password.text]) {
        mark=NO;
        //提示用户密码不合法
         [self.view makeToast:@"密码不合法" duration:1 position:CSToastPositionCenter];
        return NO;
    }
    [RegisterCheck searchInCloud:self.phone.text withBlock:^(id request) {
        if (request!=nil)
        {
            [self.view makeToast:@"手机号已存在" duration:1 position:CSToastPositionCenter];
        }
        else
        {
            //验证验证码
            [SMSSDK commitVerificationCode:self.securityCode.text phoneNumber:self.phone.text zone:@"86" result:^(NSError *error) {
                if (error) {
                    //验证码错误
                    mark=NO;
                    NSLog(@"%@",error);
                    [self.view makeToast:@"验证码错误" duration:1 position:CSToastPositionCenter];
                }
                else
                {
                    //手机号验证成功
                    NSLog(@"验证码验证成功");
                    [self.view makeToast:@"验证成功" duration:1 position:CSToastPositionCenter];
                }
            }];

        }
    }];
       return mark;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _phone.delegate=self;;
    _password.delegate=self;
    _securityCode.delegate=self;
    [self.navigationController.navigationBar setHidden:NO];
     [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    hud=[[MBProgressHUD alloc]initWithView:self.view];
    hud.labelText=@"发送中";
    [self.view addSubview:hud];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    _privacyMessageView.layer.cornerRadius=5;
    _privacyMessageView.layer.masksToBounds=YES;
    NSLog(@"%@",_sharePersonMessage);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField//在用户输入手机号或者密码结束后判断是否合法，不合法则提示
{
    if (textField==_phone)
    {
        if (![RegisterCheck checkTel:self.phone.text]) {
            //提示用户手机号不合法
        }
    }
    else if (textField==_password)
    {
        if (![RegisterCheck validatePassword:self.password.text]) {
            //提示用户密码不合法
            
        }
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
