//
//  RegisterCheck.h
//  有赏-v1.0
//
//  Created by xfy on 15/12/27.
//  Copyright © 2015年 xfy. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^returnUser) (id request);
@protocol userIsExist<NSObject>
-(void)sign;
@end
@interface RegisterCheck : NSObject
@property(nonatomic,weak)id<userIsExist> delegate;
+ (BOOL)validateNickname:(NSString *)nickname;
+ (BOOL)checkTel:(NSString *)str;
+ (BOOL)validatePassword:(NSString *)passWord;
+(void)searchInCloud:(NSString*)phone withBlock:(returnUser)returnBlock;
+(void)returnPassword:(NSString*)phone;
+(void)turnToHomeView;
@end
