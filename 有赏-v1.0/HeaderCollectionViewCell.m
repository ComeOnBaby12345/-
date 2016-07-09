//
//  HeaderCollectionViewCell.m
//  有赏-v1.0
//
//  Created by xfy on 16/1/5.
//  Copyright © 2016年 xfy. All rights reserved.
//

#import "HeaderCollectionViewCell.h"

@implementation HeaderCollectionViewCell

- (void)awakeFromNib
{
    //设置nib
}
-(void)setUIWithImageName:(NSString*)imageName
{
    _message.text=imageName;
    [_headerViewCollectionImage setImage:[UIImage imageNamed:imageName]];
}
@end
