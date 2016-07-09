//
//  HomeTableViewController.m
//  有赏-v1.0
//
//  Created by xfy on 15/12/28.
//  Copyright © 2015年 xfy. All rights reserved.
//

#import "HomeTableViewController.h"
#import "HomeHeaderView.h"
#import "OrderFormModel.h"
#import "PromulgateNewOrderFormVCViewController.h"
#import "OrderFormTableViewCell.h"
#import "WaitingForAdoptionViewController.h"
#import "OrderFormMessageViewController.h"
@interface HomeTableViewController ()<turnToPromulgateNewOrderFormVCViewController,UITableViewDataSource,UITableViewDelegate,UIAccelerometerDelegate>
{
    UISegmentedControl *segment;
    BOOL firstOne;
    BOOL firstTwo;
    BOOL secondOne;
    BOOL secondTwo;
    BOOL secondTired;
}
@property(nonatomic,strong)NSMutableArray *waitingForAdoption;//已回答等待采纳
@property(nonatomic,strong)NSMutableArray *pass;//已被采纳
@property(nonatomic,strong)NSMutableArray *iIssuedOrders;//发布的订单还未被回答
@property(nonatomic,strong)NSMutableArray *orderNewAnswer;//最新回复订单
@property(nonatomic,strong)NSMutableArray *completed;//已完成订单
@end
@implementation HomeTableViewController
-(NSMutableArray*)completed
{
    if (_completed==nil)
    {
        _completed=[[NSMutableArray alloc]init];
    }
    return _completed;
}
-(NSMutableArray*)orderNewAnswer
{
    if (_orderNewAnswer==nil)
    {
        _orderNewAnswer=[[NSMutableArray alloc]init];
    }
    return _orderNewAnswer;
}
-(NSMutableArray*)pass
{
    if (_pass==nil)
    {
        _pass=[[NSMutableArray alloc]init];
    }
    return _pass;
}
-(NSMutableArray*)waitingForAdoption
{
    if (_waitingForAdoption==nil)
    {
        _waitingForAdoption=[[NSMutableArray alloc]init];
    }
    return _waitingForAdoption;
}
-(NSMutableArray*)iIssuedOrders
{
    if (_iIssuedOrders==nil)
    {
        _iIssuedOrders=[[NSMutableArray alloc]init];
    }
    return _iIssuedOrders;
}
-(void)viewWillAppear:(BOOL)animated//在此时重新获取数据
{
    [super viewWillAppear:YES];
    [self getData];
    [self.tableView reloadData];
    self.tableView.tableHeaderView.bounds=CGRectMake(0, 0, view_width, 80);
}
#pragma mark 获取数据到本地
-(void)getData
{
    //发布的订单还未被回答
    [self getDataArrayWithClassName:ORDERFORM whereKey:@"userPhone" equalTo:[[NSUserDefaults standardUserDefaults]objectForKey:@"phone"] arrayName:@"iIssuedOrders"];
       //最新回复订单
    [self getDataArrayWithClassName:ORDERFORM1 whereKey:@"userPhone" equalTo:[[NSUserDefaults standardUserDefaults]objectForKey:@"phone"] arrayName:@"orderNewAnswer"];
    //已完成订单
    [self getDataArrayWithClassName:ORDERFORM2 whereKey:@"userPhone" equalTo:[[NSUserDefaults standardUserDefaults]objectForKey:@"phone"] arrayName:@"completed"];
    //已回答等待采纳
    [self getDataArrayWithClassName:ORDERFORM1 whereKey:@"ordersPersonPhone" equalTo:[[NSUserDefaults standardUserDefaults]objectForKey:@"phone"] arrayName:@"waitingForAdoption"];
    //我完成的悬赏
    [self getDataArrayWithClassName:ORDERFORM2 whereKey:@"ordersPersonPhone" equalTo:[[NSUserDefaults standardUserDefaults]objectForKey:@"phone"] arrayName:@"pass"];
    [self getImageFile];
}
-(void)getImageFile
{
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"GameScore"];
    //查找GameScore表的数据
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            //打印playerName
            NSLog(@"obj.playerName = %@", [obj objectForKey:@"playerName"]);
            //打印objectId,createdAt,updatedAt
            NSLog(@"obj.objectId = %@", [obj objectId]);
            NSLog(@"obj.createdAt = %@", [obj createdAt]);
            NSLog(@"obj.updatedAt = %@", [obj updatedAt]);
        }
    }];
}
-(void)getDataArrayWithClassName:(NSString*)className whereKey:(NSString*)key equalTo:(NSString*)value arrayName:(NSString*)arrayName//通过表名 key value来查询服务器并设置本地数组
{
    BmobQuery *bquery=[BmobQuery queryWithClassName:className];
    [bquery whereKey:key equalTo:value];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error)
        {
            NSLog(@"%@",error);
        }
        else//查询成功
        {
            NSMutableArray *tempArray=[[NSMutableArray alloc]init];
            for (BmobObject *s in array)
            {
                OrderFormModel *model=[[OrderFormModel alloc]initWith:s];
                [tempArray addObject:model];
            }
            if ([arrayName isEqualToString:@"iIssuedOrders"])
            {
                self.iIssuedOrders=[tempArray mutableCopy];
            }
            else if ([arrayName isEqualToString:@"orderNewAnswer"])
            {
                self.orderNewAnswer=[tempArray mutableCopy];
            }
            else if ([arrayName isEqualToString:@"completed"])
            {
                self.completed=[tempArray mutableCopy];
            }
            else if ([arrayName isEqualToString:@"waitingForAdoption"])
            {
                NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"phone"]);
                self.waitingForAdoption=[tempArray mutableCopy];
            }
            else if ([arrayName isEqualToString:@"pass"])
            {
                self.pass=[tempArray mutableCopy];
            }
        }
        [self.tableView reloadData];
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    firstOne=NO;
    firstTwo=NO;
    secondOne=NO;
    secondTwo=NO;
   secondTired=NO;
    [self addView];
    [self addSegment];
    [self
     .navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"homeHeaderImage"] forBarMetrics:UIBarMetricsDefault];
    UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
    accelerometer.delegate = self;
    accelerometer.updateInterval = 1.0f / 60.0f;
    self.tableView.tableFooterView=[UIView new];
//    self.view.backgroundColor=mainColor;
}
-(void)addView//添加表头
{
    HomeHeaderView *homeView=[[NSBundle mainBundle] loadNibNamed:@"HomeHeaderView" owner:nil options:nil].lastObject;
    homeView.delegate=self;
    self.tableView.tableHeaderView=homeView;
}
-(void)refresh//当选择segment时刷新列表
{
    [self getData];
    [self.tableView reloadData];
}
-(void)addSegment
{
    NSArray *items=@[@"我接的悬赏",@"我发布的悬赏"];
    segment=[[UISegmentedControl alloc]initWithItems:items];
    self.navigationItem.titleView=segment;
    [segment setTintColor:[UIColor whiteColor]];//控件线条颜色属性
    [segment addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    segment.selectedSegmentIndex=0;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (segment.selectedSegmentIndex==0)
    {
        return 2;
    }
    else
        return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (segment.selectedSegmentIndex==0)
    {
        if (section==0)//等待回复
        {
            if (firstOne) {
                return self.waitingForAdoption.count;
            }
            else
                return 0;
        }
        else//已被采纳
        {
            if (firstTwo)
            {
                return self.pass.count;
            }
            else
                return 0;
        }
    }
    else
    {
        if (section==0)//已被抢等待采纳
        {
            if (secondOne)
            {
                return self.orderNewAnswer.count;
            }
            else
                return 0;
        }
        else if (section==1)//未被抢
        {
            if (secondTwo)
            {
                return self.iIssuedOrders.count;
            }
            else
                return 0;
        }
        else//已完成
        {
            if (secondTired)
            {
                return self.completed.count;
            }
            else
                return 0;
        }
    }
    return 0;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (segment.selectedSegmentIndex==0)
    {
        if (section==0)//等待回复
        {
            return @"等待赏主采纳";
        }
        else//已被采纳
        {
            return @"我完成的悬赏";
        }
    }
    else
    {
        if (section==0)//已被抢等待采纳
        {
            return @"最新回复";
        }
        else if (section==1)//未被抢
        {
            return @"暂无动态";
        }
        else//已完成
        {
            return @"我采纳的";
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderFormModel *model;
    if (segment.selectedSegmentIndex==0)
    {
        if (indexPath.section==0)//等待回复
        {
            model=[self.waitingForAdoption objectAtIndex:indexPath.row];
        }
        else//已被采纳
        {
            model=[self.pass objectAtIndex:indexPath.row];
        }
    }
    else
    {
        if (indexPath.section==0)//已被抢等待采纳
        {
            model=[self.orderNewAnswer objectAtIndex:indexPath.row];
        }
        else if (indexPath.section==1)//未被抢
        {
            model=[self.iIssuedOrders objectAtIndex:indexPath.row];
        }
        else//已完成
        {
            model=[self.completed objectAtIndex:indexPath.row];
        }
    }
    NSString *identifier=@"cellMark";
    OrderFormTableViewCell *cell=[OrderFormTableViewCell getCellWith:tableView identifier:identifier];
    [cell setUIWith:model];
    [cell.statePhoto setImage:[UIImage imageNamed:@"不可抢状态下按钮"]];
//      cell.backgroundColor=[UIColor clearColor];
    return cell;
}

#pragma mark turnToPromulgateNewOrderFormVCViewController
-(void)turnToNext
{
    [self performSegueWithIdentifier:@"promulgate" sender:nil];
}
#pragma mark 页面跳转
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath=(NSIndexPath*)sender;
   //页面跳转
    if ([segue.identifier isEqualToString:@"waitingForAdoption"])
    {
        WaitingForAdoptionViewController *wfaVc=segue.destinationViewController;
        OrderFormModel *model=[self.orderNewAnswer objectAtIndex:indexPath.row];
        wfaVc.orderFormObject=model;
    }
    else if ([segue.identifier isEqualToString:@"lookMore"])
    {
//        waitingForAdoption
//        pass
//        iIssuedOrders
//        completed
        OrderFormMessageViewController *orderVc=segue.destinationViewController;
        OrderFormModel *model;
        if (segment.selectedSegmentIndex==0)
        {
            if (indexPath.section==0)//等待回复
            {
                model=[self.waitingForAdoption objectAtIndex:indexPath.row];
            }
            else//已被采纳
            {
                model=[self.pass objectAtIndex:indexPath.row];
            }
        }
        else
        {
            if (indexPath.section==1)//未被抢
            {
                model=[self.iIssuedOrders objectAtIndex:indexPath.row];
            }
            else//已完成
            {
                model=[self.completed objectAtIndex:indexPath.row];
            }
        }
        orderVc.myModel=model;
    }
}
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (segment.selectedSegmentIndex==1)
    {
        if (indexPath.section==0)
        {
            [self performSegueWithIdentifier:@"waitingForAdoption" sender:indexPath];
        }
        else
        {
            [self performSegueWithIdentifier:@"lookMore" sender:indexPath];
        }
    }
    else
    {
        [self performSegueWithIdentifier:@"lookMore" sender:indexPath];
    }
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView=[UIView new];
    headerView.backgroundColor=[UIColor clearColor];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0,view_width/2,20)];
    label.textColor=[UIColor whiteColor];
    UIImageView *rightView=[[UIImageView alloc]initWithFrame:CGRectMake(view_width-20, 0, 20, 20)];
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, view_width, 20)];
    button.tag=section;
    [button addTarget:self action:@selector(showCell:) forControlEvents:UIControlEventTouchDown];
if (segment.selectedSegmentIndex==0)
    {
        if (section==0)//等待回复
        {
            label.text=@"等待赏主采纳";
            if (firstOne)
            {
                [rightView setImage:[UIImage imageNamed:@"展开"]];
            }
            else
            {
                [rightView setImage:[UIImage imageNamed:@"收缩"]];
            }
        }
        else//已被采纳
        {
            label.text=@"我完成的悬赏";
            if (firstTwo)
            {
                [rightView setImage:[UIImage imageNamed:@"展开"]];
            }
            else
            {
                [rightView setImage:[UIImage imageNamed:@"收缩"]];
            }

        }

    }
    else
    {
        if (section==0)//已被抢等待采纳
        {
            label.text=@"最新回复";
            if (secondOne)
            {
               [rightView setImage:[UIImage imageNamed:@"展开"]];
            }
            else
            {
                [rightView setImage:[UIImage imageNamed:@"收缩"]];
            }
        }
        else if (section==1)//未被抢
        {
            label.text=@"暂无动态";
            if (secondTwo)
            {
                [rightView setImage:[UIImage imageNamed:@"展开"]];
            }
            else
            {
                [rightView setImage:[UIImage imageNamed:@"收缩"]];
            }
        }
        else//已完成
        {
            label.text=@"我采纳的";
            if (secondTired)
            {
                [rightView setImage:[UIImage imageNamed:@"展开"]];
            }
            else
            {
                [rightView setImage:[UIImage imageNamed:@"收缩"]];
            }
        }
    }
    [headerView addSubview:label];
    [headerView addSubview:button];
    [headerView addSubview:rightView];
    return headerView;
}
-(void)showCell:(UIButton*)button
{
    if (segment.selectedSegmentIndex==0)
    {
        if (button.tag==0)
        {
            if (self.waitingForAdoption.count==0)
            {
                firstOne=NO;//等待赏主采纳
            }
            else
            firstOne=!firstOne;
        }
        else
        {
            if (self.pass.count==0) {
                firstTwo=NO;//我完成的悬赏
            }
            else
            firstTwo=!firstTwo;
        }

    }
    else
    {
        if (button.tag==0)
        {
            if (self.orderNewAnswer.count==0) {
                secondOne=NO;
            }
            else
           secondOne=!secondOne;
        }
        else if (button.tag==1)
        {
            if (self.iIssuedOrders.count==0) {
                secondTwo=NO;
            }
            else
            secondTwo=!secondTwo;
        }
        else
        {
            if (self.completed.count==0) {
                secondTired=NO;
            }
            else
            secondTired=!secondTired;
        }
    }
    [self.tableView reloadData];
}
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    if(fabs(acceleration.x)>2.0||abs(acceleration.y>2.0)||fabs(acceleration.z)>2.0)
    {
        //摇一摇置顶
        self.tableView.contentOffset=CGPointMake(0, 0);
    }
}
@end
