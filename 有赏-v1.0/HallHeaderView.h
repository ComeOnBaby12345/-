//
//  HallHeaderView.h
//  有赏-v1.0
//
//  Created by xfy on 15/12/31.
//  Copyright © 2015年 xfy. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol orderFormGroup<NSObject>
@optional
-(void)turnToOrderFormGroup;
-(void)turnToLeaderboard;
-(void)turnToRepository;
@end
@interface HallHeaderView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>
{
    NSArray *modelArray;
    NSTimer *timer;
}
@property (weak, nonatomic) IBOutlet UIScrollView *headerScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *headerPageControl;
@property (weak, nonatomic) IBOutlet UICollectionView *headerCollectionView;
@property(nonatomic,weak)id<orderFormGroup> delegate;
@property(nonatomic,strong)NSMutableArray *imageUrlArray;
@end
