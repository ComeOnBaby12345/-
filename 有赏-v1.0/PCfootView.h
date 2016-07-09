//
//  PCfootView.h
//  有赏-v1.0
//
//  Created by xfy on 15/12/29.
//  Copyright © 2015年 xfy. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BackToLogin<NSObject>
-(void)backToLogin;
@end
@interface PCfootView : UIView
@property (weak, nonatomic) IBOutlet UIButton *back;
@property(nonatomic,weak)id<BackToLogin> delegate;
@end
