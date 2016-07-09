//
//  OrderFormModel.m
//  有赏-v1.0
//
//  Created by xfy on 15/12/28.
//  Copyright © 2015年 xfy. All rights reserved.
//

#import "OrderFormModel.h"
@implementation OrderFormModel
-(id)initWith:(BmobObject*)object
{
    if (self=[super init])
    {
        _title=[object objectForKey:@"title"];
        _tag=[object objectForKey:@"tag"];
        _money=[object objectForKey:@"money"];
        _userPhone=[object objectForKey:@"userPhone"];
        _orderFormMessage=[object objectForKey:@"orderFormMessage"];
        _objectId=[object objectForKey:@"objectId"];
        _ordersPersonPhone=[object objectForKey:@"ordersPersonPhone"];
        _answer=[object objectForKey:@"answer"];
    }
    return self;
}
@end
