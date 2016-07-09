//
//  OrderFormMessageViewController.m
//  有赏-v1.0
//
//  Created by xfy on 16/1/20.
//  Copyright © 2016年 xfy. All rights reserved.
//

#import "OrderFormMessageViewController.h"
#import "OrderFormModel.h"
@interface OrderFormMessageViewController ()
- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *orderFormTitle;
@property (weak, nonatomic) IBOutlet UITextView *orderFormMessage;

@property (weak, nonatomic) IBOutlet UITextView *orderFormAnswer;

@end

@implementation OrderFormMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI
{
    self.orderFormTitle.text=_myModel.title;
    self.orderFormMessage.text=_myModel.orderFormMessage;
    self.orderFormAnswer.text=_myModel.answer;
    self.orderFormAnswer.editable=NO;
    self.view.backgroundColor=mainColor;
    self.orderFormMessage.layer.cornerRadius=5;
    self.orderFormMessage.editable=NO;
    self.orderFormAnswer.layer.cornerRadius=5;
    self.orderFormAnswer.layer.masksToBounds=YES;
    self.orderFormMessage.layer.masksToBounds=YES;
    UIImage *itemImage=[UIImage imageNamed:@"back"];
    UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [itemButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    itemButton.frame=CGRectMake(0, 0,itemImage.size.width,itemImage.size.height);
    [itemButton setImage:itemImage forState:UIControlStateNormal];
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithCustomView:itemButton];
    self.navigationItem.leftBarButtonItem=moreItem;
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
