//
//  HomeHeaderView.h
//  有赏-v1.0
//
//  Created by xfy on 15/12/28.
//  Copyright © 2015年 xfy. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol turnToPromulgateNewOrderFormVCViewController<NSObject>
-(void)turnToNext;
@end
@interface HomeHeaderView : UIView
@property(nonatomic,weak)id<turnToPromulgateNewOrderFormVCViewController> delegate;
@end
