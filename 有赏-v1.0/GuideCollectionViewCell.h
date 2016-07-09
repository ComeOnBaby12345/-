//
//  GuideCollectionViewCell.h
//  有赏-v1.0
//
//  Created by xfy on 16/1/27.
//  Copyright © 2016年 xfy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuideCollectionViewCell : UICollectionViewCell
/**
 *  接收图片名称
 */
@property (nonatomic, strong) NSString *imageName;

/**
 *  告知当前cell是第几张图片
 */
@property (nonatomic, assign) int currentIndex;
@end
