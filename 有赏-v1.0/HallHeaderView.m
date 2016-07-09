//
//  HallHeaderView.m
//  有赏-v1.0
//
//  Created by xfy on 15/12/31.
//  Copyright © 2015年 xfy. All rights reserved.
//
#import "HallHeaderView.h"
#import "HeaderCollectionViewCell.h"
#import <UIImageView+WebCache.h>
#define margin 5
@implementation HallHeaderView
-(void)setImageUrlArray:(NSMutableArray *)imageUrlArray
{
    for (int i=0; i<imageUrlArray.count; i++)
    {
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(i*view_width,0,view_width, _headerScrollView.bounds.size.height)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[imageUrlArray objectAtIndex:i]]];
        [_headerScrollView addSubview:imageView];
    }
    _headerScrollView.contentSize=CGSizeMake(imageUrlArray.count*_headerScrollView.bounds.size.width, 0);
    _headerScrollView.pagingEnabled=YES;
    _headerPageControl.numberOfPages=imageUrlArray.count;
    _headerPageControl.currentPage=0;
    [self scrollImageWith:imageUrlArray.count];
}
-(void)scrollImageWith:(NSInteger)count
{
    timer=[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(scrollingImageWith:) userInfo:[NSString stringWithFormat:@"%ld",(long)count] repeats:YES];
}
-(void)scrollingImageWith:(NSTimer*)Timer
{
    if (_headerScrollView.contentOffset.x>=([Timer.userInfo intValue]-1)*_headerScrollView.bounds.size.width)
    {
        _headerScrollView.contentOffset=CGPointMake(0, 0);
        _headerPageControl.currentPage=0;
    }
    else
    {
        _headerScrollView.contentOffset=CGPointMake(_headerScrollView.contentOffset.x+_headerScrollView.bounds.size.width, 0);
        _headerPageControl.currentPage=_headerScrollView.contentOffset.x/_headerScrollView.bounds.size.width;

    }
}
-(void)awakeFromNib
{
    _headerScrollView.backgroundColor=[UIColor clearColor];
    _headerCollectionView.backgroundColor=[UIColor clearColor];
    modelArray=@[@{@"name":@"查询"},@{@"name":@"排行榜"},@{@"name":@"资源"}];
    self.headerCollectionView.delegate=self;
    self.headerCollectionView.dataSource=self;
    [self.headerCollectionView registerNib:[UINib nibWithNibName:@"HeaderCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"headerCollectionViewcell"];
}
#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HeaderCollectionViewCell  *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"headerCollectionViewcell" forIndexPath:indexPath];
    NSDictionary *modelDic=[modelArray objectAtIndex:indexPath.row];
    [cell setUIWithImageName:[modelDic objectForKey:@"name"]];
    return cell;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((view_width-4*margin)/3,(view_width-4*margin)/3);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(margin,margin,margin,margin);
}
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return margin;
//}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return margin;
}
#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)//进入分类查
    {
        if ([self.delegate respondsToSelector:@selector(turnToOrderFormGroup)])
        {
            [self.delegate turnToOrderFormGroup];
        }
    }
    else if(indexPath.row==1)//进入排行榜
    {
        if ([self.delegate respondsToSelector:@selector(turnToLeaderboard)])
        {
            [self.delegate turnToLeaderboard];
        }
    }
    else//进入资源库
    {
        if ([self.delegate respondsToSelector:@selector(turnToRepository)])
        {
            [self.delegate turnToRepository];
        }
    }
}
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//     [timer invalidate];
//}
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//     timer=[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(scrollingImageWith:) userInfo:[NSString stringWithFormat:@"%lu",_imageUrlArray.count] repeats:YES];
//}
@end
