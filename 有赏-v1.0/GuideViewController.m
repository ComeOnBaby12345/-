//
//  GuideViewController.m
//  有赏-v1.0
//
//  Created by xfy on 16/1/27.
//  Copyright © 2016年 xfy. All rights reserved.
//

#import "GuideViewController.h"
#import "GuideCollectionViewCell.h"
@interface GuideViewController ()
{
    UIPageControl *pageControl;
}
@end

@implementation GuideViewController
static NSString * const reuseIdentifier = @"Cell";

- (instancetype)init{
    
    //定义布局方式
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//设置滚动方向
    layout.itemSize = [UIScreen mainScreen].bounds.size;//设置item的大小
    layout.minimumLineSpacing = 0;
    
    return [self initWithCollectionViewLayout:layout];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     *  设置collectonView 的属性
     */
    self.collectionView.pagingEnabled = YES; //分页效果
    self.collectionView.bounces = NO;//禁用弹簧效果
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[GuideCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    
    //创建pageControl
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(100, self.view.frame.size.height-40, self.view.frame.size.width-200, 30)];
    pageControl.numberOfPages = 3;
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:89/255.0 green:179/255.0 blue:243/255.0 alpha:1.0];
    [self.view addSubview:pageControl];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger currentPage = scrollView.contentOffset.x/self.view.frame.size.width;
    [pageControl setCurrentPage:currentPage];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 3;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GuideCollectionViewCell *cell = (GuideCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.imageName = [NSString stringWithFormat:@"引导页-%li",(long)indexPath.row];
    cell.currentIndex = (int)indexPath.row;
    return cell;
}
@end
