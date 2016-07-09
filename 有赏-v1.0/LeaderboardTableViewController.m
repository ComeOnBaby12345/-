//
//  LeaderboardTableViewController.m
//  有赏-v1.0
//
//  Created by xfy on 16/1/6.
//  Copyright © 2016年 xfy. All rights reserved.
//

#import "LeaderboardTableViewController.h"
#import "PCRequest.h"
#import "LeaderboardTableViewCell.h"
@interface LeaderboardTableViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segMent;
@property(nonatomic,strong)NSMutableArray *greatGodStandings;//大神榜
@property(nonatomic,copy)NSMutableArray *tyrantList;//土豪榜
@end

@implementation LeaderboardTableViewController
-(NSMutableArray*)greatGodStandings
{
    if (_greatGodStandings==nil)
    {
        _greatGodStandings=[[NSMutableArray alloc]init];
    }
    return _greatGodStandings;
}
-(NSMutableArray*)tyrantList
{
    if (_tyrantList==nil)
    {
        _tyrantList=[[NSMutableArray alloc]init];
    }
    return _tyrantList;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self addData];
}
-(void)addData
{
    //云端默认按name值大小排序
    BmobQuery   *bquery = [BmobUser query];
    [bquery whereKey:@"privacy" notEqualTo:@"0"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        self.greatGodStandings=[array mutableCopy];
        [self.tableView reloadData];
    }];
    BmobQuery *bQuery = [BmobQuery queryWithClassName:LEADERBOARD];
    [bQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        self.tyrantList=[array mutableCopy];
        [self.tableView reloadData];
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [_segMent addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
     [_segMent setTintColor:[UIColor whiteColor]];
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
-(void)refresh
{
    [self addData];
    [self.tableView reloadData];
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
    if (_segMent.selectedSegmentIndex==0)//选择了大神榜
    {
       return  self.greatGodStandings.count;
    }
    else
        return self.tyrantList.count;;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeaderboardTableViewCell *cell=[LeaderboardTableViewCell getCell:tableView indexPath:indexPath];
    if (_segMent.selectedSegmentIndex==0)
    {
          [cell setUiWith:[self.greatGodStandings objectAtIndex:indexPath.row] withIndex:indexPath.row];
    }
    else
    {
        BmobObject *bombObject=[self.tyrantList objectAtIndex:indexPath.row] ;
        NSString *userPhone=[bombObject objectForKey:@"userPhone"];
       [PCRequest getArrayWithKey:@"username" equalTo:userPhone returnBlock:^(id request) {
             [cell setUiWith:request[0] withIndex:indexPath.row];
       }];
    }
      cell.backgroundColor=[UIColor clearColor];
    return cell;
}
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

@end
