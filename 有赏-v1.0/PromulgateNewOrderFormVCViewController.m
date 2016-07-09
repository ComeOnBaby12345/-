//
//  PromulgateNewOrderFormVCViewController.m
//  有赏-v1.0
//
//  Created by xfy on 15/12/28.
//  Copyright © 2015年 xfy. All rights reserved.
//

#import "PromulgateNewOrderFormVCViewController.h"
#import "RegisterCheck.h"
#import "PCRequest.h"
@interface PromulgateNewOrderFormVCViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIPickerView *pickerView;
    NSArray *groupName;
}
@property (weak, nonatomic) IBOutlet UITextField *orderFormTitle;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *choiceTag;
@property (weak, nonatomic) IBOutlet UITextField *money;
- (IBAction)money:(id)sender;
- (IBAction)upload:(id)sender;
@end

@implementation PromulgateNewOrderFormVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addPickView];
    groupName=@[@"求安慰",@"求打赏",@"其它",@"求主意",@"求资源"];
    self.view.backgroundColor=mainColor;
    self.navigationController.navigationBar.shadowImage=[UIImage new
                                                         ];
       [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,[UIFont fontWithName:@"Arial-BoldItalicMT" size:18],NSFontAttributeName,nil]];
    //设置title字体
    UIImage *itemImage=[UIImage imageNamed:@"back"];
    UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [itemButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    itemButton.frame=CGRectMake(0, 0,itemImage.size.width,itemImage.size.height);
    [itemButton setImage:itemImage forState:UIControlStateNormal];
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithCustomView:itemButton];
    self.navigationItem.leftBarButtonItem=moreItem;
    self.textView.layer.cornerRadius=5;
    self.textView.layer.borderWidth=2;
    self.textView.layer.borderColor=backGroundColor.CGColor;
    self.textView.layer.masksToBounds=YES;
    _orderFormTitle.layer.borderColor=backGroundColor.CGColor;
    _orderFormTitle.layer.borderWidth=2;
    _orderFormTitle.layer.cornerRadius=5;
    _orderFormTitle.layer.masksToBounds=YES;
    _choiceTag.layer.borderWidth=2;
    _choiceTag.layer.borderColor=backGroundColor.CGColor;
    _choiceTag.layer.cornerRadius=5;
    _choiceTag.layer.masksToBounds=YES;
    _money.layer.borderColor=backGroundColor.CGColor;
    _money.layer.borderWidth=2;
    _money.layer.cornerRadius=5;
    _money.layer.masksToBounds=YES;
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)addPickView
{
    pickerView=[[UIPickerView alloc]init];
    pickerView.delegate=self;
    pickerView.dataSource=self;
    _choiceTag.inputView=pickerView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 5;
}
#pragma mark UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 100;
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [groupName objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
   _choiceTag.text=[groupName objectAtIndex:row];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)money:(id)sender {
    
}
- (IBAction)upload:(id)sender {
    if ([self check])//如果检查悬赏订单内容合法就创建订单并提交
    {
        [self createAndUpload];
    }
}
-(BOOL)check//检查订单输入是否合法
{

    BmobUser *user=[BmobUser getCurrentUser];
    if ([_orderFormTitle.text isEqualToString:@""])//输入不能为空且标题小于10个字
    {
        [self.view makeToast:@"标题不能为空" duration:1 position:CSToastPositionCenter];
         return NO;
    }
    if (_orderFormTitle.text.length>=10)
    {
          [self.view makeToast:@"标题字数超限" duration:1 position:CSToastPositionCenter];
        return NO;
    }
    NSString *money=[user objectForKey:@"treasury"];
    if ((![self isPureNumandCharacters:self.money.text])||[self.money.text isEqualToString:@""])
    {
        [self.view makeToast:@"赏金必须为纯数字哦" duration:1 position:CSToastPositionCenter];
        return NO;
    }
    if ([money intValue]<[_money.text intValue])//赏金不可为空且为整数,且小于用户金库余额，赏金可以为0
    {
        //提示用户余额不足或金额不合法
         [self.view makeToast:@"余额不足" duration:1 position:CSToastPositionCenter];
        return NO;
    }
    if ([self.money.text intValue]<=0)
    {
        [self.view makeToast:@"输入金额小于1" duration:1 position:CSToastPositionCenter];
        return NO;
    }
        int tag=0;
        for (NSString *name in groupName)//标签不等于给定标签
        {
            if ([name isEqualToString:self.choiceTag.text])
            {
                tag++;
            }
        }
        if (tag==0) {
            [self.view makeToast:@"请选择标签" duration:1 position:CSToastPositionCenter];
            return NO;
        }
    return YES;
}
-(void)createAndUpload//创建新订单并上传(当表不存在会自动创建)
{
    BmobObject *orderForm=[BmobObject objectWithClassName:ORDERFORM];
    [orderForm setObject:self.orderFormTitle.text forKey:@"title"];
    [orderForm setObject:self.textView.text forKey:@"orderFormMessage"];
    [orderForm setObject:self.choiceTag.text forKey:@"tag"];
    [orderForm setObject:self.money.text forKey:@"money"];
    [orderForm setObject:@"0" forKey:@"ordersPersonPhone"];
    [orderForm setObject:@"0" forKey:@"state"];
    [orderForm setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"phone"]  forKey:@"userPhone"];
    [orderForm setObject:@"" forKey:@"answer"];
    [orderForm saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful)
        {
            //创建成功后会返回objectId，updatedAt，createdAt等信息
            //创建对象成功，打印对象值
            NSLog(@"%@",orderForm);
            [self deductingMoney];
        }
        else if (error){
            //发生错误后的动作
            NSLog(@"%@",error);
        } else {
            NSLog(@"Unknow error");
        }
    }];
}
-(void)createLeaderboard
{
   [PCRequest getBmobObiectArrayWithClassName:LEADERBOARD Key:@"userPhone" equalTo:[[NSUserDefaults standardUserDefaults ]objectForKey:@"phone"] returnBlock:^(id request) {
       NSArray *array=(NSArray*)request;
       if (array.count==0)
       {
           BmobObject *orderForm=[BmobObject objectWithClassName:LEADERBOARD];
           [orderForm setObject:self.money.text forKey:@"money"];
           [orderForm setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"phone"]  forKey:@"userPhone"];
           [orderForm saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError  *error) {
               if (isSuccessful)
               {
                    [self.navigationController popViewControllerAnimated:YES];
               }
               else if (error){
                   NSLog(@"%@",error);
               } else {
                   NSLog(@"Unknow error");
               }
           }];
       }
       else//表存在
       {
           [self addMoneyToLeaderboard];
       }
   }];
}
//从用户虚拟账户扣除赏金
-(void)deductingMoney
{
    [PCRequest getArrayWithKey:@"username" equalTo:[[NSUserDefaults standardUserDefaults]objectForKey:@"phone"] returnBlock:^(id request) {
        BmobUser *user=request[0];
        int balance=[[user objectForKey:@"treasury"] intValue]-[self.money .text intValue];
        [user setObject:[NSString stringWithFormat:@"%d",balance]
         forKey:@"treasury"];
        [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful)
            {
                if ([[[BmobUser getCurrentUser] objectForKey:@"privacy"] isEqualToString:@"1"])//判断用户是否开启了数据展示
                {
                      [self createLeaderboard];
                }
                else
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
            NSLog(@"error %@",[error description]);
        }];
    }];
}
//向赏金统计表增加赏金
-(void)addMoneyToLeaderboard
{
    [PCRequest getBmobObiectArrayWithClassName:LEADERBOARD Key:@"userPhone" equalTo:[[NSUserDefaults standardUserDefaults]objectForKey:@"phone"] returnBlock:^(id request) {
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"phone"]);
        BmobObject *object=request[0];
        int balance=[[object objectForKey:@"money"] intValue]+[self.money.text intValue];
        [object setObject:[NSString stringWithFormat:@"%d",balance]
                 forKey:@"money"];
        [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                  [self.navigationController popViewControllerAnimated:YES];
            }
            NSLog(@"error %@",[error description]);
        }];
    }];
}
- (BOOL)isPureNumandCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
