//
//  BannerImage.h
//  有赏-v1.0
//
//  Created by xfy on 16/1/9.
//  Copyright © 2016年 xfy. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^returnBlock) (id returnUrlArray);
@interface BannerImage : NSObject
+(void)getUrlModelArray:(returnBlock)returnUrlArray;
@end
