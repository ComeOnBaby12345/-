//
//  OrderFormModel.h
//  有赏-v1.0
//
//  Created by xfy on 15/12/28.
//  Copyright © 2015年 xfy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderFormModel : NSObject
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *tag;
@property(nonatomic,copy)NSString *money;
@property(nonatomic,copy)NSString *userPhone;
@property(nonatomic,copy)NSString *orderFormMessage;
@property(nonatomic,copy)NSString *objectId;
@property(nonatomic,copy)NSString *ordersPersonPhone;
@property(nonatomic,copy)NSString *answer;
-(id)initWith:(BmobObject*)object;
@end
