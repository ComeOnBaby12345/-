//
//  RushOrdersViewController.m
//  有赏-v1.0
//
//  Created by xfy on 16/1/5.
//  Copyright © 2016年 xfy. All rights reserved.
//

#import "RushOrdersViewController.h"
#import "OrderFormModel.h"
#import "PCRequest.h"
#define cornerradius 10//圆角属性
@interface RushOrdersViewController ()

@end

@implementation RushOrdersViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addData];
    [self changeOrderFormState];
    [self setUI];
}
-(void)setUI
{
    self.view.backgroundColor=mainColor;
    self.orderFormMessage.layer.cornerRadius=cornerradius;
    self.orderFormMessage.editable=NO;
    self.myAnswer.layer.cornerRadius=cornerradius;
    self.referButton.layer.cornerRadius=cornerradius;
    self.view.layer.masksToBounds=YES;
    UIImage *itemImage=[UIImage imageNamed:@"back"];
    UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [itemButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    itemButton.frame=CGRectMake(0, 0,itemImage.size.width,itemImage.size.height);
    [itemButton setImage:itemImage forState:UIControlStateNormal];
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithCustomView:itemButton];
    self.navigationItem.leftBarButtonItem=moreItem;
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)changeOrderFormState
{
    //获取该条订单对象
  [PCRequest getBmobObiectArrayWithClassName:ORDERFORM Key:@"phone" equalTo:[[NSUserDefaults standardUserDefaults]objectForKey:@"phone"] returnBlock:^(id request) {
        for (BmobObject *object in request)
        {
            [self upDate:object];
        }
    }];
}
-(void)upDate:(BmobObject*)object
{
    //改变订单状态和接单人信息
    [object setObject:@"1" forKey:@"state"];//状态1为已被抢但答案未被采纳
    [object setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"phone"] forKey:@"ordersPersonPhone"];
    [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"更新成功");
        } else {
            NSLog(@"%@",error);
        }
    }];
}

-(void)addData
{
    _orderFormState.text=_orderFormObject.tag;//还要根据tag来确定显示内容
    _orderFormTitle.text=_orderFormObject.title;
    _orderFormMessage.text=_orderFormObject.orderFormMessage;
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

- (IBAction)referToCloud:(id)sender
{
    if (self.myAnswer.text.length>=15) {
        [self addDataToClass];//创建状态为1的订单表并添加此订单信息到表
}
    else
    {
        [self.view makeToast:@"答案不得少于15字" duration:1 position:CSToastPositionCenter];
    }
}
-(void)deleteObject
{
   BmobObject *bmobObject = [BmobObject objectWithoutDatatWithClassName:ORDERFORM  objectId:_orderFormObject.objectId];
    [bmobObject deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            //删除成功后的动作
            NSLog(@"删除successful");
            [self.navigationController popViewControllerAnimated:YES];
        } else if (error){
            NSLog(@"%@",error);
        } else {
            NSLog(@"删除操作发生 UnKnow error");
        }
    }];
}
-(void)addDataToClass//创建状态为1的订单表
{
    BmobObject *orderForm=[BmobObject objectWithClassName:ORDERFORM1];
    [orderForm setObject:_orderFormObject.title forKey:@"title"];
    [orderForm setObject:_orderFormObject.orderFormMessage forKey:@"orderFormMessage"];
    [orderForm setObject:_orderFormObject.tag forKey:@"tag"];
    [orderForm setObject:_orderFormObject.money forKey:@"money"];
    [orderForm setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"phone"] forKey:@"ordersPersonPhone"];
    [orderForm setObject:@"1" forKey:@"state"];
    [orderForm setObject:_orderFormObject.userPhone  forKey:@"userPhone"];
    [orderForm setObject:self.myAnswer.text forKey:@"answer"];
    [orderForm saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful)
        {
            //创建成功后会返回objectId，updatedAt，createdAt等信息
            //创建对象成功，打印对象值
            NSLog(@"创建表1成功");
            [self deleteObject];//在原表上删除此订单
        }
        else if (error){
            //发生错误后的动作
            NSLog(@"%@",error);
        } else {
            NSLog(@"Unknow error");
        }
    }];

}
- (IBAction)back:(id)sender {
    [PCRequest getBmobObiectArrayWithClassName:ORDERFORM Key:@"phone" equalTo:[[NSUserDefaults standardUserDefaults]objectForKey:@"phone"] returnBlock:^(id request) {
        for (BmobObject *object in request)
        {
            [self updateWhenBackWith:object];
        }
    }];
}
-(void)updateWhenBackWith:object
{
    //改变订单状态和接单人信息
    [object setObject:@"0" forKey:@"state"];
    [object setObject:@"0" forKey:@"ordersPersonPhone"];
    [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"更新成功");
        [self.navigationController popViewControllerAnimated:YES];

        } else {
            NSLog(@"%@",error);
        }
    }];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
