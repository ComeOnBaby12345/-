//
//  HeaderCollectionViewCell.h
//  有赏-v1.0
//
//  Created by xfy on 16/1/5.
//  Copyright © 2016年 xfy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerViewCollectionImage;
@property (weak, nonatomic) IBOutlet UILabel *message;
-(void)setUIWithImageName:(NSString*)imageName;
@end
