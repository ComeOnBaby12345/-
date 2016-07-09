//
//  HallViewController.m
//  有赏-v1.0
//
//  Created by xfy on 15/12/31.
//  Copyright © 2015年 xfy. All rights reserved.
//

#import "HallViewController.h"
#import "HallHeaderView.h"
#import "HallCellModel.h"
#import "OrderFormModel.h"
#import "OrderFormTableViewCell.h"
#import "RushOrdersViewController.h"
#import "BannerImage.h"
#import "MJRefresh.h"
@interface HallViewController ()<rushOrders,orderFormGroup,UITableViewDelegate,UIAccelerometerDelegate>
{
    int count;
}
@property(nonatomic,strong)NSMutableArray *modelArray;
@end

@implementation HallViewController
-(NSMutableArray*)modelArray
{
    if (_modelArray==nil)
    {
        _modelArray=[[NSMutableArray
                      alloc]init];
    }
    return _modelArray;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self addHeaderView];
    [self headerRefresh];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self addData];
    [self addRefreshView];
    count=0;
    UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
    accelerometer.delegate = self;
    accelerometer.updateInterval = 1.0f / 60.0f;
}
-(void)setUI
{
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    [self
     .navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"homeHeaderImage"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.tabBarController.tabBar setBackgroundImage:[UIImage new]];
}
-(void)addRefreshView
{
    self.tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    self.tableView.header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
}
-(void)headerRefresh
{
    count=0;
    [HallCellModel getCellModelArrayWithlimit:10 skip:count block:^(id request) {
        self.modelArray=request;
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
    }];
    count=count+10;
}
-(void)footRefresh
{
    //将HallCellModel中count置为10
    [self addData];
}
#pragma mark orderFormGroup
-(void)turnToOrderFormGroup
{
    [self performSegueWithIdentifier:@"orderFormGroup" sender:nil];
}
-(void)turnToLeaderboard
{
    [self performSegueWithIdentifier:@"leaderboard" sender:nil];
}
-(void)turnToRepository
{
    [self performSegueWithIdentifier:@"repository" sender:nil];
}
#pragma mark 加载数据
-(void)addData
{
  [HallCellModel getCellModelArrayWithlimit:10 skip:count block:^(id request) {
      for (OrderFormModel *s in request)
      {
           [self.modelArray addObject:s];
      }
      [self.tableView.footer endRefreshing];
      [self.tableView reloadData];
  }];
    count=count+10;
}
#pragma mark 添加headerView
-(void)addHeaderView
{
    HallHeaderView *hallhv=[[NSBundle mainBundle] loadNibNamed:@"HallHeaderView" owner:nil options:nil].lastObject;
    hallhv.delegate=self;
    self.tableView.tableHeaderView=hallhv;
    [BannerImage getUrlModelArray:^(id returnUrlArray) {
        hallhv.imageUrlArray=returnUrlArray;
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderFormModel *model=[self.modelArray objectAtIndex:indexPath.row];
    static NSString *identifier=@"HallCell";
    OrderFormTableViewCell *cell=[OrderFormTableViewCell getCellWith:tableView identifier:identifier];
    [cell setUIWith:model];
    cell.delegate=self;
//    cell.backgroundColor=[UIColor clearColor];
    [cell.statePhoto setImage:[UIImage imageNamed:@"抢"]];
    return cell;
}
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}
- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;//取消cell选中高亮状态
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
-(void)rushOdersWith:(OrderFormModel *)model
{
    if ([model.userPhone isEqualToString:[[NSUserDefaults standardUserDefaults ]objectForKey:@"phone"]])
    {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"不可以抢答自己发布的悬赏哦" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
         [self performSegueWithIdentifier:@"rushOrderForm" sender:model];
    }
}
#pragma mark 跳转到回答界面
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"rushOrderForm"])
    {
        OrderFormModel *model=(OrderFormModel*)sender;
        RushOrdersViewController *rushVc=segue.destinationViewController;
        rushVc.orderFormObject=model;
    }
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
