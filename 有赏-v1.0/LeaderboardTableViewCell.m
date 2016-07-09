//
//  LeaderboardTableViewCell.m
//  有赏-v1.0
//
//  Created by xfy on 16/1/6.
//  Copyright © 2016年 xfy. All rights reserved.
//

#import "LeaderboardTableViewCell.h"
#import <UIImageView+WebCache.h>
@implementation LeaderboardTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
+(LeaderboardTableViewCell*)getCell:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    LeaderboardTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"leaderboard"];
    if (cell==nil)
    {
        cell=[[NSBundle mainBundle] loadNibNamed:@"LeaderboardTableViewCell" owner:nil options:nil].lastObject;
    }
    
    return cell;
}
-(void)setUiWith:(BmobUser*)user withIndex:(NSInteger)row
{
    _places.text=[NSString stringWithFormat:@"第%li名",(long)row+1];
    _userNickName.text=[user objectForKey:@"nickName"];
    NSString *photoUrl=[user objectForKey:@"photoUrl"];
    _userPhoto.layer.cornerRadius=_userPhoto.bounds.size.width/2;
    _userPhoto.layer.masksToBounds=YES;
    if ([photoUrl isEqualToString:@"0"])
    {
        [_userPhoto sd_setImageWithURL:[NSURL URLWithString:@"http://img5.duitang.com/uploads/item/201410/03/20141003213449_vExEj.jpeg"]];
    }
    else
    {
         [_userPhoto sd_setImageWithURL:[NSURL URLWithString:getUrl([user objectForKey:@"photoUrl"])]];
    }
    [_userName setImage:[UIImage imageNamed:[self getImageWith:[user objectForKey:@"name"]]]];
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
