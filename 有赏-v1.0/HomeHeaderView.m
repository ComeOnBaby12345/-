//
//  HomeHeaderView.m
//  有赏-v1.0
//
//  Created by xfy on 15/12/28.
//  Copyright © 2015年 xfy. All rights reserved.
//

#import "HomeHeaderView.h"

@implementation HomeHeaderView
- (IBAction)pramulgateNewOrderform:(id)sender {
    UIButton *button=(UIButton*)sender;
    NSLog(@"%@",NSStringFromCGRect(button.frame));
    if ([self.delegate respondsToSelector:@selector(turnToNext)])
    {
        [self.delegate turnToNext];
    }
}

@end
