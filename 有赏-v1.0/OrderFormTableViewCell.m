//
//  OrderFormTableViewCell.m
//  有赏-v1.0
//
//  Created by xfy on 15/12/28.
//  Copyright © 2015年 xfy. All rights reserved.
//

#import "OrderFormTableViewCell.h"
#import "OrderFormModel.h"
#import "PCRequest.h"
#import <UIImageView+WebCache.h>
@implementation OrderFormTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (IBAction)leadUp:(id)sender
{
    //当悬赏状态为可抢时，点击抢单
    if ([self.delegate respondsToSelector:@selector(rushOdersWith:)])
    {
        [self.delegate rushOdersWith:_model];
    }
}
+(OrderFormTableViewCell*)getCellWith:(UITableView*)tableView identifier:(NSString*)identifier
{
    OrderFormTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil)
    {
        cell=[[NSBundle mainBundle]loadNibNamed:@"OrderFormTableViewCell" owner:nil options:nil].lastObject;
    }
    return cell;
}
-(void)setUIWith:(OrderFormModel*)model
{
    _model=model;
    _title.text=model.title;
    [_messageTag setImage:[UIImage imageNamed:model.tag]];;
    _userPhoto.layer.cornerRadius=_userPhoto.bounds.size.width/2;
    _userPhoto.layer.masksToBounds=YES;
    [PCRequest getArrayWithKey:@"username" equalTo:model.userPhone returnBlock:^(id request) {
        BmobUser *user=request[0];
        NSString *name=[user objectForKey:@"name"];
        [_nameImage setImage:[UIImage imageNamed:[self getImageWith:name]]];
        _nickName.text=[user objectForKey:@"nickName"];
        _orderFormMoney.text=[NSString stringWithFormat:@"%@🌕",model.money];
        NSString *userPhoto=[user objectForKey:@"photoUrl"];
        if ([userPhoto isEqualToString:@"0"])//当用户未设置头像时使用默认头像
        {
            [_userPhoto sd_setImageWithURL:[NSURL URLWithString:@"http://img5.duitang.com/uploads/item/201410/03/20141003213449_vExEj.jpeg"]];
        }
        else
        {
            //先判断本地有无缓存，没有则请求网络并存入本地，有则使用本地图片
            
            [_userPhoto sd_setImageWithURL:[NSURL URLWithString:getUrl(userPhoto)]];
        }
        //设置状态图片，暂时没素材不设置 此图片保存在本地根据状态设置
        //    [_statePhoto sd_setImageWithURL:[NSURL URLWithString:model.leadupImage]];
    }];
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
