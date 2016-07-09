//
//  PCRequest.m
//  有赏-v1.0
//
//  Created by xfy on 15/12/29.
//  Copyright © 2015年 xfy. All rights reserved.
//

#import "PCRequest.h"

@implementation PCRequest
+(void)getArrayWithKey:(NSString*)key equalTo:(NSString*)value returnBlock:(returnBlock)returnblock
{
    BmobQuery *bquery=[BmobUser query];
    [bquery whereKey:key equalTo:value];
    bquery.maxCacheAge = 100;//缓存有限时间
    bquery.cachePolicy = kBmobCachePolicyCacheElseNetwork;//先从缓存读取数据，如果没有再从网络获取。
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error)
    {
        returnblock(array);
    }];
}
+(void)getBmobObiectArrayWithClassName:(NSString*)className Key:(NSString*)key equalTo:(NSString*)value returnBlock:(returnBlock)returnblock
{
    BmobQuery *bquery = [BmobQuery queryWithClassName:className];
     [bquery whereKey:key equalTo:value];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        returnblock(array);
    }];
}
+(void)AnalyzingTableExistsWithClassName:(NSString*)className returnBlock:(returnBlock)returnblock
{
    BmobQuery *bquery = [BmobQuery queryWithClassName:className];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count==0)//表中无数据
        {
             returnblock(@"1");
        }
        else//表中有
        {
            returnblock(@"0");
        }
    }];

}
@end
