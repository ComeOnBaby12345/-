//
//  PCheaderModel.m
//  有赏-v1.0
//
//  Created by xfy on 15/12/29.
//  Copyright © 2015年 xfy. All rights reserved.
//

#import "PCheaderModel.h"

@implementation PCheaderModel
-(id)initWith:(NSString*)photoUrl userName:(NSString*)userName name:(NSString*)name
{
    if (self=[super  init])
    {
        _photoUrl=photoUrl;
        _userName=userName;
        _name=name;
    }
    return self;
}
@end
