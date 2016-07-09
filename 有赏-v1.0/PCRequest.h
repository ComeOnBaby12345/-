//
//  PCRequest.h
//  有赏-v1.0
//
//  Created by xfy on 15/12/29.
//  Copyright © 2015年 xfy. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^returnBlock)(id request);
@interface PCRequest : NSObject
+(void)getArrayWithKey:(NSString*)key equalTo:(NSString*)value returnBlock:(returnBlock)returnblock;//查询BmobUser对象
+(void)getBmobObiectArrayWithClassName:(NSString*)className Key:(NSString*)key equalTo:(NSString*)value returnBlock:(returnBlock)returnblock;//查询BmobObject对象
+(void)AnalyzingTableExistsWithClassName:(NSString*)className returnBlock:(returnBlock)returnblock;//判断表是否存在
@end
