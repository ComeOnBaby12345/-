//
//  RepositoryTableViewController.m
//  有赏-v1.0
//
//  Created by xfy on 16/1/7.
//  Copyright © 2016年 xfy. All rights reserved.
//

#import "RepositoryTableViewController.h"
#import "RepositoryModel.h"
#import "OrderFormModel.h"
#import "OrderFormTableViewCell.h"
#import "RepositoryViewHeaderView.h"
#import "OrderFormMessageViewController.h"
@interface RepositoryTableViewController ()<UISearchBarDelegate,UITableViewDelegate,UIAccelerometerDelegate>
@property(nonatomic,strong)NSMutableArray *modelArray;
@end

@implementation RepositoryTableViewController
-(NSMutableArray*)modelArray
{
    if (_modelArray==nil)
    {
        _modelArray=[[NSMutableArray
                      alloc]init];
    }
    return _modelArray;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self addData];
}
-(void)addData
{
    [RepositoryModel getCellModelArray:nil value:nil block:^(id request) {
        self.modelArray=request;
        [self.tableView reloadData];
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addHeaderView];
    UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
    accelerometer.delegate = self;
    accelerometer.updateInterval = 1.0f / 60.0f;
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
-(void)addHeaderView
{
    RepositoryViewHeaderView *headerView=[RepositoryViewHeaderView getRepositoryViewHeaderView];
    [headerView.search setShowsCancelButton:YES animated:YES];
    headerView.search.delegate=self;
    self.tableView.tableHeaderView=headerView;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text=@"";
    [searchBar resignFirstResponder];
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
    static NSString *identifier=@"cellMark";
    OrderFormTableViewCell *cell=[OrderFormTableViewCell getCellWith:tableView identifier:identifier];
    [cell setUIWith:model];
    [cell.statePhoto setImage:[UIImage imageNamed:@"不可抢状态下按钮"]];
      cell.backgroundColor=[UIColor clearColor];
    return cell;
}
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderFormModel *model=[self.modelArray objectAtIndex:indexPath.row];
    UIStoryboard *stroyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OrderFormMessageViewController *orderFormMessage=[stroyboard instantiateViewControllerWithIdentifier:@"orderFormMeesage"];
    orderFormMessage.myModel=model;
    [self.navigationController pushViewController:orderFormMessage animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [RepositoryModel getCellModelArray:@"tag" value:searchBar.text block:^(id request)
    {
        self.modelArray=request;
        [self.tableView reloadData];
    }];
    [self.view endEditing:YES];
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
