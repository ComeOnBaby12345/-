//
//  SubClassTableViewController.m
//  有赏-v1.0
//
//  Created by xfy on 16/1/5.
//  Copyright © 2016年 xfy. All rights reserved.
//

#import "SubClassTableViewController.h"
#import "PCRequest.h"
#import "OrderFormModel.h"
#import "OrderFormTableViewCell.h"
#import "RushOrdersViewController.h"
@interface SubClassTableViewController ()<rushOrders>
@property(nonatomic,strong)NSMutableArray *modelArray;
@end

@implementation SubClassTableViewController
-(NSMutableArray*)modelArray
{
    if (_modelArray==nil)
    {
        _modelArray=[[NSMutableArray alloc] init];
    }
    return _modelArray;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self addData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
    UIImage *itemImage=[UIImage imageNamed:@"back"];
    UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [itemButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    itemButton.frame=CGRectMake(0, 0,itemImage.size.width,itemImage.size.height);
    [itemButton setImage:itemImage forState:UIControlStateNormal];
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithCustomView:itemButton];
    self.navigationItem.leftBarButtonItem=moreItem;
    self.tableView.tableFooterView=[UIView new];
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)addData
{
    NSString *tag=[self getTagWith:_index];
    [PCRequest getBmobObiectArrayWithClassName:ORDERFORM Key:@"tag" equalTo:tag returnBlock:^(id request) {
        NSMutableArray *tempArray=[[NSMutableArray alloc]init];
        for (BmobObject *obj in request)
            {
                OrderFormModel *model=[[OrderFormModel alloc]initWith:obj];
                [tempArray addObject:model];
            }
        self.modelArray=tempArray;
        [self.tableView reloadData];
    }];
}
-(NSString*)getTagWith:(NSString*)index
{
    NSString *tag;
    switch ([index intValue]) {
        case 1000:
            tag=@"求安慰";
            break;
        case 1001:
            tag=@"求资源";
            break;
        case 1002:
            tag=@"求主意";
            break;
        case 1003:
            tag=@"其它";
            break;
        case 1004:
            tag=@"求打赏";
            break;
        default:
            break;
    }
    return tag;
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
    cell.delegate=self;
//    if (indexPath.row%3==0)
//    {
//        cell.backgroundColor=cellColorOne;
//    }
//    else if (indexPath.row%3==1)
//    {
//        cell.backgroundColor=cellColorTwo;
//    }
//    else
//    {
//        cell.backgroundColor=cellColorThree;
//    }
      cell.backgroundColor=[UIColor clearColor];
    [cell.statePhoto setImage:[UIImage imageNamed:@"抢"]];
    return cell;
}
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}
#pragma mark rushOrders
-(void)rushOdersWith:(OrderFormModel*)model
{
    [self performSegueWithIdentifier:@"rushOrderFormToo" sender:model];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"rushOrderFormToo"])
    {
        RushOrdersViewController *rushVc=segue.destinationViewController;
        rushVc.orderFormObject=(OrderFormModel*)sender;
    }
}
@end
