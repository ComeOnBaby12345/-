//
//  AboutUsViewController.m
//  有赏-v1.0
//
//  Created by xfy on 16/1/22.
//  Copyright © 2016年 xfy. All rights reserved.
//

#import "AboutUsViewController.h"
#import <UIImageView+WebCache.h>
@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *itemImage=[UIImage imageNamed:@"back"];
    UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [itemButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    itemButton.frame=CGRectMake(0, 0,itemImage.size.width,itemImage.size.height);
    [itemButton setImage:itemImage forState:UIControlStateNormal];
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithCustomView:itemButton];
    self.navigationItem.leftBarButtonItem=moreItem;
    BmobQuery  *bquery= [BmobQuery queryWithClassName:ABOUTUS];
    bquery.maxCacheAge = 100;//缓存有限时间
    bquery.cachePolicy = kBmobCachePolicyCacheElseNetwork;//先从缓存读取数据，如果没有再从网络获取。
    //查找GameScore表的数据
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count!=0) {
            BmobObject *obj=array[0];
            BmobFile *file=[obj objectForKey:@"aboutUs"];
            [_aboutUsImage sd_setImageWithURL:[NSURL URLWithString:file.url]];
        }
        else
        {
            return ;
        }
    }];
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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

@end
