//
//  webViewController.m
//  有赏-v1.0
//
//  Created by xfy on 16/1/25.
//  Copyright © 2016年 xfy. All rights reserved.
//

#import "webViewController.h"

@interface webViewController ()

@end

@implementation webViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *itemImage=[UIImage imageNamed:@"back"];
    UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [itemButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    itemButton.frame=CGRectMake(0, 0,itemImage.size.width,itemImage.size.height);
    [itemButton setImage:itemImage forState:UIControlStateNormal];
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithCustomView:itemButton];
    self.navigationItem.leftBarButtonItem=moreItem;
    NSURL *url=[NSURL URLWithString:_url];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    _webView.scalesPageToFit=YES;
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
