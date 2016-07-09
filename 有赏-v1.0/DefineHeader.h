//
//  DefineHeader.h
//  
//
//  Created by xfy on 15/12/28.
//
//
#ifndef DefineHeader_h
#define DefineHeader_h
#define view_width [UIScreen mainScreen].bounds.size.width
#define view_height [UIScreen mainScreen].bounds.size.height
#define OfficialWebsite @"http://m.tiantianyoushang.icoc.in"//app官网
#define IntelligentAnswerKy @"e00874ce61d76c0a7a4818d94eec7ff1"
#define orderFormPay @"orderFormPay"
#define  USER @"_User"//用户表名
#define ORDERFORM @"Orderform"//订单状态为0的表名
#define ORDERFORM1 @"OrderformWhenStateIs1"//订单状态为1的表名
#define ORDERFORM2 @"OrderformWhenStateIs2"//订单状态为2的表名
#define ORDERFORM3 @"OrderformWhenStateIs3"//订单状态为3的表名
#define LEADERBOARD @"Leaderboard"//统计发出悬赏总金额表名
#define BANNERIMAGE @"BannerImage"//banner图片
#define ABOUTUS @"AboutUs"//关于我们图片
#define version @"v1.0"//版本
#define  getUrl(a) [NSString stringWithFormat:@"%@?t=1&a=6c49f4748a30a22e48404022629bc2ee",a]//根据上传文件成功后服务器返回的url构建出实际可访问的url
#define CACHEPATH [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"Caches/DownloadFile"]//缓冲文件路径
#define mainColor [UIColor colorWithRed:23/255.0 green:254/255.0 blue:255/255.0 alpha:1]
#define  cellTextColor [UIColor colorWithRed:229/255.0 green:152/255.0 blue:82/255.0 alpha:1]
#define cellColorOne [UIColor colorWithRed:23/255.0 green:173/255.0 blue:230/255.0 alpha:1]
#define cellColorTwo [UIColor colorWithRed:91/255.0 green:217/255.0 blue:152/255.0 alpha:1]
#define cellColorThree [UIColor colorWithRed:117/255.0 green:88/255.0 blue:248/255.0 alpha:1]
#define backGroundColor [UIColor colorWithRed:232/255.0 green:245/255.0 blue:254/255.0 alpha:1]
#endif /* DefineHeader_h */
