//
//  PCfootView.m
//  有赏-v1.0
//
//  Created by xfy on 15/12/29.
//  Copyright © 2015年 xfy. All rights reserved.
//

#import "PCfootView.h"

@implementation PCfootView
- (IBAction)exit:(id)sender {
    if ([self.delegate respondsToSelector:@selector(backToLogin)])
    {
        [self.delegate backToLogin];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
