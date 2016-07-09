//
//  OfficialWebsiteViewController.m
//  有赏-v1.0
//
//  Created by xfy on 16/1/22.
//  Copyright © 2016年 xfy. All rights reserved.
//

#import "OfficialWebsiteViewController.h"

@interface OfficialWebsiteViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation OfficialWebsiteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url=[NSURL URLWithString:OfficialWebsite];
    NSURLRequest *request=[[NSURLRequest alloc]initWithURL:url];
    _webView.delegate=self;
    _webView.scalesPageToFit=YES;
    [_webView loadRequest:request];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    NSLog(@"%@",error);
}

@end
