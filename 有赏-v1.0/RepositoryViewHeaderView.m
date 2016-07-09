//
//  RepositoryViewHeaderView.m
//  有赏-v1.0
//
//  Created by xfy on 16/1/12.
//  Copyright © 2016年 xfy. All rights reserved.
//

#import "RepositoryViewHeaderView.h"

@implementation RepositoryViewHeaderView
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(RepositoryViewHeaderView*)getRepositoryViewHeaderView
{
    RepositoryViewHeaderView *view=[[NSBundle mainBundle]loadNibNamed:@"RepositoryView" owner:nil options:nil].lastObject;
    return view;
}
@end
