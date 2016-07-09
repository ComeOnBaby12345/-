//
//  PCheaderView.m
//  有赏-v1.0
//
//  Created by xfy on 15/12/29.
//  Copyright © 2015年 xfy. All rights reserved.
//

#import "PCheaderView.h"
#import "PCheaderModel.h"
#import <UIImageView+WebCache.h>
@implementation PCheaderView
-(void)setModel:(PCheaderModel *)model//通过将服务器端数据转换成PCheaderModer对象来设置UI
{
    _userName.text=model.userName;
    [_userPhoto sd_setImageWithURL:[NSURL URLWithString:model.photoUrl]];
}
-(void)setModelArray:(NSMutableArray *)modelArray//直接传服务器端数据来设置UI
{
    self.userPhoto.layer.cornerRadius=self.userPhoto.bounds.size.height/2;
    self.userPhoto.layer.masksToBounds=YES;
    NSDictionary *dic=[modelArray firstObject];
    if ([[dic objectForKey:@"photoUrl"] isEqualToString:@"0"])//说明用户未设置头像，启用默认头像
    {
        [self.userPhoto setImage:[UIImage imageNamed:@"默认头像"]];
    }
    else
    {
        //用户上传了头像，使用用户上传头像
        NSString *url=[dic objectForKey:@"photoUrl"];
        [self.userPhoto sd_setImageWithURL:[NSURL URLWithString:getUrl(url)]];
    }
    if ([[dic objectForKey:@"nickName"] isEqualToString:@"0"])//说明用户未设置昵称，使用手机号代替
    {
        self.userName.text=[dic objectForKey:@"username"];
    }
    else
    {
        //用户编辑了昵称，使用用户设置的昵称
        self.userName.text=[dic objectForKey:@"nickName"];
    }
    //设置称号
    NSString *imagename=[self getImageWith:[dic objectForKey:@"name"]];
    [self.nameImage setImage:[UIImage imageNamed:imagename]];
}
-(NSString*)getImageWith:(NSString*)name
{
    int value=[name intValue];
    NSString *imageName;
    if (value<=2)
    {
        imageName=@"游学者";
    }
    else if (value>2&&value<=7)
    {
        imageName=@"俊才";
    }
    else if (value>=8&&value<=13)
    {
        imageName=@"初师";
    }
    else if (value>=14&&value<=21)
    {
        imageName=@"智者";
    }
    else if (value>=22&&value<=31)
    {
        imageName=@"仁师";
    }
    else if (value>=32&&value<=43)
    {
        imageName=@"仁者";
    }
    else if (value>=44&&value<=57)
    {
        imageName=@"尊者";
    }
    else if (value>=58&&value<=100)
    {
        imageName=@"大智尊";
    }
    else if (value>100)
    {
        imageName=@"坛圣";
    }
    return imageName;
}
@end
