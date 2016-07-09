//
//  GuideCollectionViewCell.m
//  有赏-v1.0
//
//  Created by xfy on 16/1/27.
//  Copyright © 2016年 xfy. All rights reserved.
//

#import "GuideCollectionViewCell.h"
#import "GuideViewController.h"
#import "MyViewController.h"
@interface GuideCollectionViewCell()
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UIButton *useButton;

@end
@implementation GuideCollectionViewCell
- (UIImageView *)imageView{
    if (_imageView==nil) {
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView = imageV;
        
        //
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}


- (UIButton *)useButton{
    
    if (_useButton==nil) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(75, self.frame.size.height-130, self.frame.size.width-150, 100)];
        //button的事件放在controller中处理
        //传递方式：1.target:self 通过代理传递事件 2:target:controller action写在controller中
        [button addTarget:self action:@selector(goToMainView) forControlEvents:UIControlEventTouchUpInside];
        
        _useButton = button;
        
        
        [self addSubview:_useButton];
    }
    
    return _useButton;
}

- (void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    [self.imageView setImage:[UIImage imageNamed:imageName]];
}


/**
 *  判断当前的cell是最后一张引导页
 */
- (void)setCurrentIndex:(int)currentIndex{
    _currentIndex = currentIndex;
    //如果是最后一张图片
    if (_currentIndex==2) {
        //添加进入按钮
        [self useButton];
    }else{
        if (_useButton) {
            [_useButton removeFromSuperview];
        }
    }
}


- (void)goToMainView
{
    //更改根视图控制器
    //1.(window->App(UIApplication)Delegate)
    //    AppDelegate *app = [UIApplication sharedApplication].delegate;
    //2.[UIApplication sharedApplication].keyWindow
    UIStoryboard *board=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *loginNv=[board instantiateViewControllerWithIdentifier:@"loginNv"];
    [UIApplication sharedApplication].keyWindow.rootViewController=loginNv;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@"1" forKey:@"FirstLoad"];
    [defaults synchronize];
}
@end
