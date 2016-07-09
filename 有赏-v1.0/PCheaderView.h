//
//  PCheaderView.h
//  有赏-v1.0
//
//  Created by xfy on 15/12/29.
//  Copyright © 2015年 xfy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PCheaderModel;
@interface PCheaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *userPhoto;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *nameImage;
@property(nonatomic,strong)PCheaderModel *model;
@property(nonatomic,strong)NSMutableArray *modelArray;
@end
