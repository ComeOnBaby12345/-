//
//  RushOrdersViewController.h
//  有赏-v1.0
//
//  Created by xfy on 16/1/5.
//  Copyright © 2016年 xfy. All rights reserved.
//
#import <UIKit/UIKit.h>
@class OrderFormModel;
@interface RushOrdersViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *orderFormState;
- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *orderFormTitle;
@property (weak, nonatomic) IBOutlet UITextView *myAnswer;

@property (weak, nonatomic) IBOutlet UITextView *orderFormMessage;
@property(nonatomic,strong)OrderFormModel *orderFormObject;
- (IBAction)referToCloud:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *referButton;
@end
