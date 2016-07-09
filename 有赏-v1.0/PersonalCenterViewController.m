//
//  PersonalCenterViewController.m
//  有赏-v1.0
//
//  Created by xfy on 15/12/29.
//  Copyright © 2015年 xfy. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "PCheaderView.h"
#import "PCfootView.h"
#import "PCheaderModel.h"
#import "PCRequest.h"
#import "AppDelegate.h"
@interface PersonalCenterViewController ()<BackToLogin>
{
    NSString *cacheSize;
}
@property(nonatomic,strong)NSArray *cellTitleArray;
@end

@implementation PersonalCenterViewController
-(NSArray*)cellTitleArray
{
    if (_cellTitleArray==nil) {
        _cellTitleArray=@[@"账号",@"修改资料",@"清除缓存",@"关于我们",@"版本信息",@"在线商城",@"我的财富",@"官网"];
    }
    return _cellTitleArray;
}
-(void)viewDidAppear:(BOOL)animated
{
    [self addHeaderAndFootView];
    [self getCacheSize];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//   self.view.backgroundColor=mainColor;
    [self
     .navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"homeHeaderImage"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}
-(void)getCacheSize
{
    cacheSize=[NSString stringWithFormat:@"%.2fM",[self folderSizeAtPath:CACHEPATH]];//获取文件夹大小
}
#pragma mark 根据查询数据库得到信息并刷新页面
-(void)addHeaderAndFootView
{
    PCheaderView *headerView=[[NSBundle mainBundle]loadNibNamed:@"PCheaderView" owner:nil options:nil].lastObject;
    headerView.backgroundColor=[UIColor clearColor];
    self.tableView.tableHeaderView=headerView;
    PCfootView *footView=[[NSBundle mainBundle]loadNibNamed:@"PCfootView" owner:nil options:nil].lastObject;
    footView.back.layer.cornerRadius=10;
    footView.back.layer.masksToBounds=YES;
    footView.delegate=self;
    self.tableView.tableFooterView=footView;
    [PCRequest getArrayWithKey:@"username" equalTo:[[NSUserDefaults standardUserDefaults]objectForKey:@"phone"] returnBlock:^(id request) {
        headerView.modelArray=request;
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
    return self.cellTitleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static  NSString *identifier=@"cellMark";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text=[self.cellTitleArray objectAtIndex:indexPath.row];
    if (indexPath.row==0)
    {
        //rightCellTitle显示手机号
        cell.detailTextLabel.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
    }
    else if (indexPath.row==2)
    {
        cell.detailTextLabel.text=cacheSize;
    }
    else if (indexPath.row==4)
    {
        cell.detailTextLabel.text=version;
    }
    else if (indexPath.row==6)
    {
        BmobUser *user=[BmobUser getCurrentUser];
        NSString *money=[user objectForKey:@"treasury"];
        cell.detailTextLabel.text=[NSString  stringWithFormat:@"%@枚",money];
    }
    else
    {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//        [cell.cellRightImage setImage:[UIImage imageNamed:@"cellRightImage"]];
    }
    [cell.imageView setImage:[UIImage imageNamed:[self.cellTitleArray objectAtIndex:indexPath.row]]];
    cell.imageView.layer.shadowOffset=CGSizeMake(0, 0);
//    cell.backgroundColor=[UIColor clearColor];
    cell.selectedBackgroundView=[UIView new];
    return cell;
}
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==1)//当点击了修改资料
    {
        [self performSegueWithIdentifier:@"PCedit" sender:nil];//跳转到修改资料界面
    }
    if (indexPath.row==2)//清除缓存
    {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"确定清除缓存?" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self cleanCaches];//清除缓存
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@" 取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //取消清除操作
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    if (indexPath.row==5) {
        [self performSegueWithIdentifier:@"changePhone" sender:nil];//跳转到修改绑定手机号界面
    }
    if (indexPath.row==7)
    {
        [self performSegueWithIdentifier:@"OfficialWebsite" sender:nil];//跳转到官网
    }
    if(indexPath.row==3)
    {
        [self performSegueWithIdentifier:@"aboutUs" sender:nil];//跳转到关于我们
    }
}
-(void)cleanCaches//清除缓存
{
    NSError *error;
    NSFileManager *manager=[NSFileManager defaultManager];
    if ([manager fileExistsAtPath:CACHEPATH]) {
        [manager removeItemAtPath:CACHEPATH error:&error];
    }
    else
    {
        [self.view makeToast:@"已清空" duration:1 position:CSToastPositionCenter];
    }
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}
//遍历文件夹获得文件夹大小，返回多少M
- (float )folderSizeAtPath:(NSString*) folderPath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath])
        return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject])!= nil)
    {
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}
//单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
-(void)backToLogin
{
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *loginNv=[main instantiateViewControllerWithIdentifier:@"loginNv"];
    AppDelegate *appdelegate=[UIApplication sharedApplication].delegate;
    appdelegate.window.rootViewController=loginNv;
    
}
@end
