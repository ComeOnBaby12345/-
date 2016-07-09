//
//  PCheaderModel.h
//  有赏-v1.0
//
//  Created by xfy on 15/12/29.
//  Copyright © 2015年 xfy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCheaderModel : NSObject
@property(nonatomic,copy)NSString *photoUrl;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *name;
-(id)initWith:(NSString*)photoUrl userName:(NSString*)userName name:(NSString*)name;
@end
