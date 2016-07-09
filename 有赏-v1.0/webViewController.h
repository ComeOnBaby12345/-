//
//  webViewController.h
//  有赏-v1.0
//
//  Created by xfy on 16/1/25.
//  Copyright © 2016年 xfy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface webViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property(nonatomic,strong)NSString *url;
@end
