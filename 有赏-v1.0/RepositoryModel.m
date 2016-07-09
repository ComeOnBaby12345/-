//
//  RepositoryModel.m
//  有赏-v1.0
//
//  Created by xfy on 16/1/7.
//  Copyright © 2016年 xfy. All rights reserved.
//

#import "RepositoryModel.h"
#import "OrderFormModel.h"
@implementation RepositoryModel
+(void)getCellModelArray:(NSString*)key value:(NSString*)value block:(returnResult)returnresult
{
    //    bquery.limit = 3;//一页查询条数
    //    bquery.skip = 3;//跳过多少条查询，实现换页
    BmobQuery   *bquery = [BmobQuery queryWithClassName:ORDERFORM3];
    if (key!=nil) {
         [bquery whereKey:key equalTo:value];
    }
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
