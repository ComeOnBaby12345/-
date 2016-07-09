//
//  LeaderboardTableViewCell.h
//  有赏-v1.0
//
//  Created by xfy on 16/1/6.
//  Copyright © 2016年 xfy. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface LeaderboardTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *places;
@property (weak, nonatomic) IBOutlet UIImageView *userPhoto;
@property (weak, nonatomic) IBOutlet UILabel *userNickName;
@property (weak, nonatomic) IBOutlet UIImageView *userName;
+(LeaderboardTableViewCell*)getCell:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath;
-(void)setUiWith:(BmobUser*)user withIndex:(NSInteger)row;
@end
