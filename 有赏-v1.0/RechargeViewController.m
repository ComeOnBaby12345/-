//
//  RechargeViewController.m
//  有赏-v1.0
//
//  Created by xfy on 16/1/19.
//  Copyright © 2016年 xfy. All rights reserved.
//

#import "RechargeViewController.h"
#import <BmobPay/BmobPay.h>
#import "PCRequest.h"
#import <UIImageView+WebCache.h>
@interface RechargeViewController () <BmobPayDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *titleArray;
    NSMutableArray *imageName;
    NSMutableArray *priceArray;
    NSString *addCount;
    NSString *tradeNo;
}
@end
@implementation RechargeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    titleArray=[[NSMutableArray alloc]init];
    imageName=[[NSMutableArray alloc]init];
    priceArray=[[NSMutableArray alloc]init];
    [self getData];
    self.myTableView.tableFooterView=[UIView new];
    self.myTableView.backgroundColor=[UIColor clearColor];
    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"主页背景"]];
    self.myTableView.backgroundView=imageView;
    // Do any additional setup after loading the view.
    UIImage *itemImage=[UIImage imageNamed:@"back"];
    UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [itemButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    itemButton.frame=CGRectMake(0, 0,itemImage.size.width,itemImage.size.height);
    [itemButton setImage:itemImage forState:UIControlStateNormal];
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithCustomView:itemButton];
    self.navigationItem.leftBarButtonItem=moreItem;
    UITextView *footView=[[UITextView alloc]initWithFrame:CGRectMake(0, 0, view_width, 100)];
    footView.text=@"注：收款方为惠州好伯乐科技有限公司（第三方支付服务商）请联系：QQ2495039981(开发者的客服联系方式)";
    self.myTableView.tableFooterView=footView;
}
-(void)getData
{
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Mall"];
    //查找GameScore表的数据
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            [priceArray addObject:[obj objectForKey:@"goodsPrice"]];
            [titleArray addObject:[obj objectForKey:@"goodsName"]];
            BmobFile *file=[obj objectForKey:@"goodsImage"];
            [imageName addObject:file.url];
        }
        [self.myTableView reloadData];
    }];}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageName[indexPath.row]] placeholderImage:[UIImage imageNamed:@"loading"]];
    cell.textLabel.text=titleArray[indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:13];
    cell.detailTextLabel.text=@"购买";
    cell.detailTextLabel.textColor=[UIColor redColor];
    cell.backgroundColor=[UIColor clearColor];
    cell.selectedBackgroundView=[UIView new];
    return cell;
}
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)//保存下充值金币数,支付成功后在服务的修改数据
    {
        case 0:
            addCount=@"20";
            break;
        case 1:
            addCount=@"50";
            break;
        case 2:
            addCount=@"200";
            break;
        case 3:
            addCount=@"500";
            break;
        default:
            break;
    }
    BmobPay* bPay = [[BmobPay alloc] init];
    //设置代理
    bPay.delegate = self;
    //设置商品价格、商品名、商品描述
    [bPay setPrice:[NSNumber numberWithInt:[priceArray[indexPath.row] intValue]]];
    [bPay setProductName:titleArray[indexPath.row]];
    [bPay setBody:titleArray[indexPath.row]];
    //appScheme为创建项目第4步中在URL Schemes中添加的标识
    [bPay setAppScheme:@"MyBounty"];
    //调用支付宝支付
    [bPay payInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            //在Bmob建立订单表
            [self addOrderFormToBmob:bPay.tradeNo orderFormStatus:bPay.tradeStatus];
            tradeNo=bPay.tradeNo;
        }
        else{
            NSLog(@"%@",[error description]);
        }
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return view_height/8;
}
#pragma mark BmobPayDelegate
-(void)paySuccess{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付结果" message:@"支付成功" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
    [alter show];
    //增加user金币
    [self changeUserMessage];
    [self changeOrderFormPayStatus];
}
-(void)changeUserMessage
{
    BmobUser *bUser = [BmobUser getCurrentUser];
    NSString *updateBefore=[bUser objectForKey:@"treasury"];
    int upDateLater=[updateBefore intValue]+[addCount intValue];
    [bUser setObject:[NSString stringWithFormat:@"%i",upDateLater] forKey:@"treasury"];
    [bUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        NSLog(@"error %@",[error description]);
    }];
}
-(void)changeOrderFormPayStatus
{
    [PCRequest getBmobObiectArrayWithClassName:orderFormPay Key:@"tradeNo" equalTo:tradeNo returnBlock:^(id request) {
        BmobObject *object=request[0];
        //此处是更新操作
        [object setObject:@"支付成功" forKey:@"tradeStatus"];
        [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                NSLog(@"更新成功，以下为对象值，可以看到score值已经改变");
                NSLog(@"%@",object);
            } else {
                NSLog(@"%@",error);
            }
        }];
}];
}
-(void)payFailWithErrorCode:(int) errorCode{
    [PCRequest getBmobObiectArrayWithClassName:orderFormPay Key:@"tradeNo" equalTo:tradeNo returnBlock:^(id request) {
        BmobObject *object=request[0];
        //此处是更新操作
        [object setObject:@"支付失败" forKey:@"tradeStatus"];
        [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                NSLog(@"更新成功，以下为对象值，可以看到score值已经改变");
                NSLog(@"%@",object);
            } else {
                NSLog(@"%@",error);
            }
        }];
    }];
    switch(errorCode){
        case 6001:{
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付结果" message:@"用户中途取消" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            [alter show];
        }
            break;
        case 6002:{
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付结果" message:@"网络连接出错" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            [alter show];
        }
            break;
        case 4000:{
            
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付结果" message:@"订单支付失败" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            [alter show];
        }
            break;
    }
}
-(void)addOrderFormToBmob:(NSString*)tradeNo orderFormStatus:(NSString*)tradeStatus//往订单表添加一条数据
{
    BmobObject *orderForm=[BmobObject objectWithClassName:@"orderFormPay"];
    [orderForm setObject:tradeNo forKey:@"tradeNo"];
    [orderForm setObject:tradeStatus forKey:@"tradeStatus"];
    [orderForm setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"phone"] forKey:@"phone"];
    [orderForm saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        //进行操作
    }];
}
@end
