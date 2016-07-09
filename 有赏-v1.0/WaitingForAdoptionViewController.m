//
//  WaitingForAdoptionViewController.m
//  有赏-v1.0
//
//  Created by xfy on 16/1/6.
//  Copyright © 2016年 xfy. All rights reserved.
//

#import "WaitingForAdoptionViewController.h"
#import "OrderFormModel.h"
#import "PCRequest.h"
#import <UIImageView+WebCache.h>
@interface WaitingForAdoptionViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
{
    UIPickerView *pickView;
}
@property (weak, nonatomic) IBOutlet UITextField *orderFormTitle;
@property (weak, nonatomic) IBOutlet UITextView *orderFormMessage;

@property (weak, nonatomic) IBOutlet UIImageView *ordersPersonPhoto;
@property (weak, nonatomic) IBOutlet UILabel *ordersPersonNickname;
@property (weak, nonatomic) IBOutlet UILabel *ordersPersonName;
@property (weak, nonatomic) IBOutlet UITextView *ordersPersonAnswer;

- (IBAction)accept:(id)sender;
- (IBAction)refuse:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *shareState;
@end

@implementation WaitingForAdoptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addPickView];
    [self addOrderFormData];
    self.view.backgroundColor=mainColor;
    UIImage *itemImage=[UIImage imageNamed:@"back"];
    UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [itemButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    itemButton.frame=CGRectMake(0, 0,itemImage.size.width,itemImage.size.height);
    [itemButton setImage:itemImage forState:UIControlStateNormal];
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithCustomView:itemButton];
    self.navigationItem.leftBarButtonItem=moreItem;
    _orderFormMessage.layer.cornerRadius=5;
    self.orderFormMessage.editable=NO;
    _ordersPersonAnswer.layer.cornerRadius=5;
    _orderFormMessage.layer.masksToBounds=YES;
    _ordersPersonAnswer.editable=NO;
    _ordersPersonAnswer.layer.masksToBounds=YES;
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)addOrderFormData
{
    _orderFormTitle.text=_orderFormObject.title;
    _orderFormMessage.text=_orderFormObject.orderFormMessage;
    //通过ordersPerson的Phone找到用户信息
    [PCRequest getArrayWithKey:@"username" equalTo:_orderFormObject.ordersPersonPhone returnBlock:^(id request) {
        BmobUser *user=((NSArray*)request)[0];
        NSString *photoUrl=[user objectForKey:@"photoUrl"];
        if ([photoUrl isEqualToString:@"0"])
        {
             [_ordersPersonPhoto sd_setImageWithURL:[NSURL URLWithString:@"http://img5.duitang.com/uploads/item/201410/03/20141003213449_vExEj.jpeg"]];
        }
        else
        {
             [_ordersPersonPhoto sd_setImageWithURL:[NSURL URLWithString:getUrl(photoUrl)]];
        }
        _ordersPersonNickname.text=[user objectForKey:@"nickName"];
        _ordersPersonName.text=[self getName:[user objectForKey:@"name"]];
//        _ordersPersonName.text=[user objectForKey:@"name"];
    }];
    _ordersPersonAnswer.text=_orderFormObject.answer;
}
-(NSString*)getName:(NSString*)name
{
    int nameValue=[name intValue];
    if (nameValue<=2)
    {
        return @"游学者";
    }
    else if (nameValue>2&&nameValue<=7)
    {
        return @"俊才";
    }
    else if (nameValue>7&&nameValue<=13)
    {
        return @"初师";
    }
    else if (nameValue>13&&nameValue<=21)
    {
        return @"智者";
    }
    else if (nameValue>21&&nameValue<=31)
    {
        return @"仁师";
    }
    else if (nameValue>31&&nameValue<=43)
    {
       return @"仁者";
    }
    else if (nameValue>43&&nameValue<=57)
    {
        return @"尊者";
    }
    else if (nameValue>57&&nameValue<=100)
    {
        return @"大智尊";
    }
    else if (nameValue>100)
    {
        return @"坛圣";
    }
    else
        return @"屌炸天";
}
-(void)addPickView
{
    pickView=[[UIPickerView alloc]init];
    pickView.delegate=self;
    pickView.dataSource=self;
    _shareState.text=@"共享";//默认共享
    _shareState.inputView=pickView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}
#pragma mark UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 80;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row==0)
    {
        return @"共享";
    }
    else
        return @"不共享";
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (row==0)
    {
        _shareState.text=@"共享";
    }
    else
    {
        _shareState.text=@"不共享";
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

- (IBAction)accept:(id)sender
{
    if ([self.shareState.text isEqualToString:@"共享"])//默认公开
    {
        [self addObjectWithClassName:ORDERFORM2 state:@"2"];
        [self addObjectWithClassName:ORDERFORM3 state:@"2"];
        [self deleteObject];
    }
    else
    {
        [self addObjectWithClassName:ORDERFORM2 state:@"2"];
        [self deleteObject];
    }
    [self changeAccountBalance];//接单者账户增加赏金数额
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)changeAccountBalance
{
    [PCRequest getArrayWithKey:@"username" equalTo:_orderFormObject.ordersPersonPhone returnBlock:^(id request) {
        BmobUser *user=request[0];
        int balance=[[user objectForKey:@"treasury"] intValue]+[_orderFormObject.money intValue];
        NSLog(@"%i%@",balance,_orderFormObject.ordersPersonPhone);
        [user setObject:[NSString stringWithFormat:@"%d",balance]
                 forKey:@"treasury"];
        [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            NSLog(@"error %@",[error description]);
        }];
    }];
}
- (IBAction)refuse:(id)sender
{
   [self addObjectWithClassName:ORDERFORM state:@"0"];
    [self deleteObject];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)deleteObject
{
    BmobObject *bmobObject = [BmobObject objectWithoutDatatWithClassName:ORDERFORM1  objectId:_orderFormObject.objectId];
        [bmobObject deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                //删除成功后的动作
                NSLog(@"删除successful");
            } else if (error){
                NSLog(@"%@",error);
            } else {
                NSLog(@"删除操作发生 UnKnow error");
            }
        }];
}
-(void)addObjectWithClassName:(NSString*)className state:(NSString*)state
{
    BmobObject *orderForm=[BmobObject objectWithClassName:className];
    [orderForm setObject:_orderFormObject.title forKey:@"title"];
    [orderForm setObject:_orderFormObject.orderFormMessage forKey:@"orderFormMessage"];
    [orderForm setObject:_orderFormObject.tag forKey:@"tag"];
    [orderForm setObject:_orderFormObject.money forKey:@"money"];
    [orderForm setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"phone"] forKey:@"userPhone"];
    [orderForm setObject:state forKey:@"state"];
    [orderForm setObject:_orderFormObject.ordersPersonPhone  forKey:@"ordersPersonPhone"];
    if ([className isEqualToString:ORDERFORM])
    {
        [orderForm setObject:@"0" forKey:@"answer"];//清空网友答案
    }
    else
    {
         [orderForm setObject:_orderFormObject.answer forKey:@"answer"];
    }
    [orderForm saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful)
        {
            //创建成功后会返回objectId，updatedAt，createdAt等信息
            //创建对象成功，打印对象值
        }
        else if (error){
            //发生错误后的动作
            NSLog(@"%@",error);
        } else {
            NSLog(@"Unknow error");
        }
    }];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
