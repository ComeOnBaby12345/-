//
//  EditViewController.h
//  有赏-v1.0
//
//  Created by xfy on 15/12/29.
//  Copyright © 2015年 xfy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *userPhoto;
- (IBAction)uploadPhoto:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *nickName;
- (IBAction)complete:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *securityCode;
- (IBAction)getSecurityCode:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *shareData;
@property (weak, nonatomic) IBOutlet UIButton *getSecurityCodeButton;
- (IBAction)shareData:(id)sender;

@end
