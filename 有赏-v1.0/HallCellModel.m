//
//  HallCellModel.m
//  有赏-v1.0
//
//  Created by xfy on 15/12/31.
//  Copyright © 2015年 xfy. All rights reserved.
//

#import "HallCellModel.h"
#import "OrderFormModel.h"
@implementation HallCellModel
+(void)getCellModelArrayWithlimit:(int)limit skip:(int)skip block:(returnResult)returnresult
{
    BmobQuery  *bquery= [BmobQuery queryWithClassName:ORDERFORM];
    bquery.maxCacheAge = 10;//缓存有限时间
    bquery.cachePolicy = kBmobCachePolicyCacheElseNetwork;//先从缓存读取数据，如果没有再从网络获取。
    bquery.limit = limit;//一页查询条数
    bquery.skip = skip;//跳过多少条查询，实现换页
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        NSMutableArray *tempArray=[[NSMutableArray alloc]init];
        for (BmobObject *obj in array)
        {
            OrderFormModel *model=[[OrderFormModel alloc]initWith:obj];
            [tempArray addObject:model];
        }
        returnresult(tempArray);
    }];
}
@end
