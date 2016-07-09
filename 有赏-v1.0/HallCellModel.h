//
//  HallCellModel.h
//  有赏-v1.0
//
//  Created by xfy on 15/12/31.
//  Copyright © 2015年 xfy. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^returnResult) (id request);
@interface HallCellModel : NSObject
+(void)getCellModelArrayWithlimit:(int)limit skip:(int)skip block:(returnResult)returnresult;
@end
