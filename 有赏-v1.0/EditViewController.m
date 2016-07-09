//
//  EditViewController.m
//  有赏-v1.0
//
//  Created by xfy on 15/12/29.
//  Copyright © 2015年 xfy. All rights reserved.
//

#import "EditViewController.h"
#import "PCRequest.h"
#import <BmobSDK/BmobProFile.h>
#import <UIImageView+WebCache.h>
#import <UIView+Toast.h>
#import <SMS_SDK/SMSSDK.h>
#import "RegisterCheck.h"
#import <MBProgressHUD.h>
@interface EditViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
{
    UIImagePickerController *imagePicker;
    NSString *photoUrl;
    MBProgressHUD *hud;
}
@end
@implementation EditViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if ([[[BmobUser getCurrentUser]objectForKey:@"privacy"] isEqualToString:@"0"])
    {
        _shareData.on=NO;
    }
    else
    {
        _shareData.on=YES;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [PCRequest getArrayWithKey:@"username" equalTo:[[NSUserDefaults standardUserDefaults]objectForKey:@"phone"] returnBlock:^(id request) {
        [self setUiWithArray:request];
    }];
    self.view.layer.backgroundColor=backGroundColor.CGColor;
    imagePicker=[[UIImagePickerController alloc]init];
    imagePicker.delegate=self;
    imagePicker.allowsEditing=NO;
    self.securityCode.hidden=YES;
    self.getSecurityCodeButton.hidden=YES;
    self.phone.delegate=self;
    self.phone.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"phone"];
    [self addhud];
    self.userPhoto.layer.cornerRadius=self.userPhoto.bounds.size.width/2;
    self.userPhoto.layer.masksToBounds=YES;
    UIImage *itemImage=[UIImage imageNamed:@"back"];
    UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [itemButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    itemButton.frame=CGRectMake(0, 0,itemImage.size.width,itemImage.size.height);
    [itemButton setImage:itemImage forState:UIControlStateNormal];
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithCustomView:itemButton];
    self.navigationItem.leftBarButtonItem=moreItem;
    self.view.backgroundColor=mainColor;
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)addhud
{
    hud=[[MBProgressHUD alloc]initWithView:self.view];
    hud.labelText=@"修改头像中";
    [self.view addSubview:hud];
}
#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.securityCode.hidden=NO;
    self.getSecurityCodeButton.hidden=NO;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.phone.text isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:@"phone"]])
    {
        self.securityCode.hidden=YES;
        self.getSecurityCodeButton.hidden=YES;
    }
}
-(void)setUiWithArray:(NSArray*)request
{
    NSDictionary *dic=[request firstObject];
    NSString *url=[dic objectForKey:@"photoUrl"];
    if ([url isEqualToString:@"0"])//说明用户未设置头像，启用默认头像
    {
         [self.userPhoto sd_setImageWithURL:[NSURL URLWithString:@"http://img5.duitang.com/uploads/item/201410/03/20141003213449_vExEj.jpeg"]];
    }
    else
    {
        //用户上传了头像，使用用户上传头像
        [self.userPhoto sd_setImageWithURL:[NSURL URLWithString:getUrl(url)]];
    }
    if ([[dic objectForKey:@"nickName"] isEqualToString:@"0"])//说明用户未设置昵称，使用手机号代替
    {
        self.nickName.text=[dic objectForKey:@"phone"];
    }
    else
    {
        //用户编辑了昵称，使用用户设置的昵称
        self.nickName.text=[dic objectForKey:@"nickName"];
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

- (IBAction)uploadPhoto:(id)sender
{
    [self presentViewController:imagePicker animated:YES completion:nil];
}
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo
{
    [self.userPhoto setImage:image];
    NSData *data=UIImageJPEGRepresentation(image, 0.5);//传原图太大容易失败，压缩后传入
    [self uploadImageWith:data];
    [self dismissViewControllerAnimated:YES completion:nil];
    [hud show:YES];
}
#pragma mark 上传头像
-(void)uploadImageWith:(NSData*)data
{
    //通过NSData上传文件
    //构造NSData
//    NSString *mainBundlePath = [[NSBundle mainBundle] bundlePath];
//    NSData *data = [NSData dataWithContentsOfFile:[mainBundlePath stringByAppendingPathComponent:@"image.jpg"]];
    //上传文件
    //搞个时间戳给文件命名
    NSDate *now=[NSDate date];
    NSDateFormatter *formmtter=[[NSDateFormatter alloc]init];
    [formmtter setDateFormat:@"yyyyMMdd:HHmmss"];
    NSString *timeStr=[formmtter stringFromDate:now];
    [BmobProFile uploadFileWithFilename:timeStr fileData:data block:^(BOOL isSuccessful, NSError *error, NSString *filename, NSString *url,BmobFile *bmobFile) {
        if (isSuccessful) {
            photoUrl=url;
        } else {
            if (error) {
                NSLog(@"error %@",error);
            }
        }
    } progress:^(CGFloat progress) {
        //上传进度，此处可编写进度条逻辑
        NSLog(@"progress %f",progress);
        if (progress==1.0)
        {
            [hud hide:YES];//当图片上传完成
        }
    }];
}
- (IBAction)complete:(id)sender {
    if ([self.phone.text isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:@"phone"]])//说明用户没有修改手机
    {
        [self changeUserData];
    }
    else
    {
        [self checkWithblock:^(id request) {
            if ([request isEqualToString:@"1"])//手机号合法
            {
                //验证验证码
                [SMSSDK commitVerificationCode:self.securityCode.text phoneNumber:[[NSUserDefaults standardUserDefaults]objectForKey:@"phone"] zone:@"86" result:^(NSError *error) {
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
                        [self changeUserData];
                    }
                }];
            }
        }];
    }
   
}
-(void)changeUserData
{
    BmobUser *bUser = [BmobUser getCurrentUser];//获取当前用户
    [bUser setObject:photoUrl forKey:@"photoUrl"];
    [bUser setObject:_nickName.text forKey:@"nickName"];
    if (![self.phone.text isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:@"phone"]])
    {
         [bUser setObject:self.phone.text forKey:@"username"];
    }
    [bUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
              [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (IBAction)getSecurityCode:(id)sender {
    //判断用户手机号是否改变、是否合法、是否存在，没有改变则不获取
    if ([self.phone.text isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:@"phone"]])
    {
        //提醒用户手机号未改变
         [self.view makeToast:@"请输入其它手机号" duration:1 position:CSToastPositionCenter];
    }
    else
    {
        [self checkWithblock:^(id request) {
            if ([request isEqualToString:@"1"])//合法
            {
                //获取验证码
                [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:[[NSUserDefaults standardUserDefaults]objectForKey:@"phone"] zone:@"86" customIdentifier:nil result:^(NSError *error) {
                    if (!error) {
                        NSLog(@"验证码发送成功");
                        //提示发送验证码成功
                    }
                    else
                    {
                        NSLog(@"%@",error);
                        //提示发送验证码失败
                    }
                }];
            }
        }];
    }
}
-(void)checkWithblock:(returnBlock)returnResult//验证手机号是否合法
{
    if (![RegisterCheck checkTel:self.phone.text]) {
        //提示用户手机号不合法
        [self.view makeToast:@"手机号不合法" duration:1 position:CSToastPositionCenter];
        returnResult(@"0");
    }
    else
    {
        [RegisterCheck searchInCloud:self.phone.text withBlock:^(id request) {
            if (request==nil)
            {
                returnResult(@"1");
            }
            else
            {
                 [self.view makeToast:@"手机号已存在" duration:1 position:CSToastPositionCenter];
                returnResult(@"0");
            }
        }];
    }
}
- (IBAction)shareData:(id)sender//更改user中privacy属性
{
    BmobUser *user=[BmobUser getCurrentUser];
    if (_shareData.on)
    {
        [user setObject:@"1" forKey:@"privacy"];
    }
    else
    {
        [user setObject:@"0" forKey:@"privacy"];
    }
    [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        NSLog(@"error %@",[error description]);
    }];
}
@end
