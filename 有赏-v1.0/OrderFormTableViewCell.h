//
//  OrderFormTableViewCell.h
//  有赏-v1.0
//
//  Created by xfy on 15/12/28.
//  Copyright © 2015年 xfy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderFormModel;
@protocol rushOrders<NSObject>
@optional
-(void)rushOdersWith:(OrderFormModel*)model;
@end
@interface OrderFormTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *messageTag;
@property (weak, nonatomic) IBOutlet UIImageView *nameImage;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
- (IBAction)leadUp:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *userPhoto;
@property (weak, nonatomic) IBOutlet UIImageView *statePhoto;
@property (weak, nonatomic) IBOutlet UILabel *orderFormMoney;
@property(nonatomic,weak)id<rushOrders> delegate;
@property(nonatomic,copy)OrderFormModel *model;
+(OrderFormTableViewCell*)getCellWith:(UITableView*)tableView identifier:(NSString*)identifier;
-(void)setUIWith:(OrderFormModel*)model;
@end
