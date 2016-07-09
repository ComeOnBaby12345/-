//
//  RepositoryModel.h
//  有赏-v1.0
//
//  Created by xfy on 16/1/7.
//  Copyright © 2016年 xfy. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^returnResult) (id request);
@interface RepositoryModel : NSObject
+(void)getCellModelArray:(NSString*)key value:(NSString*)value block:(returnResult)returnresult;
@end
