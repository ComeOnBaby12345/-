//
//  BannerImage.m
//  有赏-v1.0
//
//  Created by xfy on 16/1/9.
//  Copyright © 2016年 xfy. All rights reserved.
//

#import "BannerImage.h"

@implementation BannerImage
+(void)getUrlModelArray:(returnBlock)returnUrlArray
{
    BmobQuery   *bquery = [BmobQuery queryWithClassName:BANNERIMAGE];
    bquery.maxCacheAge = 100;//缓存有限时间
    bquery.cachePolicy = kBmobCachePolicyCacheElseNetwork;//先从缓存读取数据，如果没有再从网络获取。
    //查找GameScore表的数据
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        NSMutableArray *tempArray=[[NSMutableArray alloc]init];
        for (BmobObject *obj in array) {
            BmobFile *file=[obj objectForKey:@"image"];
            [tempArray addObject:file.url];
        }
        returnUrlArray(tempArray);
    }];
}
@end
