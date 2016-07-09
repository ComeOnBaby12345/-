//
//  LoginViewController.m
//  有赏-v1.0
//
//  Created by xfy on 15/12/27.
//  Copyright © 2015年 xfy. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterCheck.h"
#import <MBProgressHUD.h>
@interface LoginViewController ()
{
    MBProgressHUD *hud;
}
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *password;
- (IBAction)login:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *rememberPassword;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)rememberPw:(id)sender;
@end
@implementation LoginViewController
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"remember"] intValue]==1)//如果用户记住密码
    {
        _phone.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"phone"];
        _password.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
        _rememberPassword.on=YES;
    }
    else
    {
        _rememberPassword.on=NO;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeUI];
    [self setIcon];
    [self.navigationController.navigationBar setHidden:YES];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    _loginButton.layer.cornerRadius=10;
    _loginButton.layer.masksToBounds=YES;
    hud=[[MBProgressHUD alloc]initWithView:self.view];
    hud.labelText=@"登录中";
    [self.view addSubview:hud];
//    _rememberPassword 
}
//修改UI界面
-(void)changeUI
{
//    CGRect frame = [self.phone bounds];
//    frame.size.width = frame.size.height;
//    _phone.leftView.frame=frame;
//    _phone.leftViewMode=UITextFieldViewModeUnlessEditing;
//    UIImageView *leftView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"iconfont-zdgli-3"]];
//    _phone.leftView=leftView;
//    _password.leftView.frame=frame;
//    _password.leftViewMode=UITextFieldViewModeUnlessEditing;
//    UIImageView *rightView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"iconfont-pwd-2"]];
//    _password.leftView=rightView;
}
-(void)setIcon
{
    //设置textfiled图标
//    _phone.leftViewMode=UITextFieldViewModeAlways;
//    CGRect frame=[self.phone bounds];
//    frame.size.width=frame.size.height;
//    UIImageView *phoneImage=[[UIImageView alloc]initWithFrame:frame];
//    [phoneImage setImage:[UIImage imageNamed:@"iconfont-shoujirenzheng-7"]];
//    _phone.leftView=phoneImage;
//    _password.leftViewMode=UITextFieldViewModeAlways;
//    UIImageView *passwordImage=[[UIImageView alloc]initWithFrame:frame];
//    [passwordImage setImage:[UIImage imageNamed:@"iconfont-pwd-4"]];
//    _password.leftView=passwordImage;
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
- (IBAction)login:(id)sender {
    if ([CheckNetWork connectedToNetwork])
    {
        [hud show:YES];
        [RegisterCheck searchInCloud:self.phone.text withBlock:^(id request) {
            if (request==nil)
            {
                [self.view makeToast:@"用户不存在" duration:1 position:CSToastPositionCenter];
                [hud hide:YES];
            }
            else
            {
                //使用手机号+密码登陆
                [BmobUser loginWithUsernameInBackground:self.phone.text password:self.password.text block:^(BmobUser *user, NSError *error)
                 {
                     if (error==nil)
                     {
                         //登陆成功
                         NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                         [user setObject:self.phone.text forKey:@"phone"];
                         if ([[user objectForKey:@"remember"] intValue]==1) {
                             [user setObject:self.password.text forKey:@"password"];
                         }
                         [hud hide:YES];
                         [RegisterCheck turnToHomeView];
                     }
                     else
                     {
                         //登陆失败
                         [hud hide:YES];
                         [self.view makeToast:@"密码错误" duration:1 position:CSToastPositionCenter];
                     }
                 }];
            }
        }];
    }
    else
    {
        [self.view makeToast:@"请检查网络连接" duration:1 position:CSToastPositionCenter];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (IBAction)rememberPw:(id)sender {
    if (_rememberPassword.on)//记住密码
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"remember"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"password"];
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"phone"];
         [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"remember"];
    }
}
@end
