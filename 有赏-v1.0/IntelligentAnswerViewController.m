//
//  IntelligentAnswerViewController.m
//  有赏-v1.0
//
//  Created by xfy on 16/1/23.
//  Copyright © 2016年 xfy. All rights reserved.
//

#import "IntelligentAnswerViewController.h"
#import "webViewController.h"
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
@interface IntelligentAnswerViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int requestCode;
}
@property (weak, nonatomic) IBOutlet UITextField *question;
- (IBAction)go:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *messageView;
@property(nonatomic,strong)NSArray *newsArray;
@property(nonatomic,strong)NSArray *menuArray;
@end

@implementation IntelligentAnswerViewController
-(NSArray*)newsArray
{
    if (_newsArray==nil) {
        _newsArray=[[NSArray alloc]init];
    }
    return _newsArray;
}
-(NSArray*)menuArray
{
    if (_menuArray==nil) {
        _menuArray=[[NSArray alloc]init];
    }
    return _menuArray;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
     [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    [self
     .navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"homeHeaderImage"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.view.backgroundColor=[UIColor colorWithRed:23/255.0 green:254/255.0 blue:255/255.0 alpha:1];
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

- (IBAction)go:(id)sender
{
    NSString *urlStr=@"http://www.tuling123.com/openapi/api";
    NSURL *url=[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:0 timeoutInterval:10];
    request.HTTPMethod=@"POST";
    NSString *bodyStr=[NSString stringWithFormat:@"key=%@&info=%@",IntelligentAnswerKy,self.question.text];
    NSLog(@"%@",self.question.text);
    request.HTTPBody=[bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        id request=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self resolveWithRequest:request];
        }];
    }];
    [dataTask resume];
}
-(void)resolveWithRequest:(id)request
{
    NSString *code=[request objectForKey:@"code"];
    switch ([code intValue])
    {
        case 100000://文字类
        {
            NSString *message=[request objectForKey:@"text"];
            [self setUiWithText:message];
        }
            break;
        case 200000://连接类、列车、航班
        {
            NSString *message=[request objectForKey:@"text"];
            NSString *url=[request objectForKey:@"url"];
            [self setUiWithText:message url:url];
            requestCode=200000;
        }
            break;
        case 302000://新闻
        {
            NSString *message=[request objectForKey:@"text"];
            NSArray *tempArray=[request objectForKey:@"list"];
            [self setUiWithText:message array:tempArray];
            self.newsArray=tempArray;
            requestCode=302000;
        }
            break;
        case 308000://菜谱
        {
            NSString *message=[request objectForKey:@"text"];
            NSArray *tempArray=[request objectForKey:@"list"];
            [self setUiWithText:message array:tempArray];
            self.menuArray=tempArray;
            requestCode=308000;
        }
            break;
        default://服务器升级中
            
            break;
    }
}
-(void)setUiWithText:(NSString*)message
{
    UITextView *textView=[[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.messageView.bounds.size.width, self.messageView.bounds.size.height)];
    textView.text=message;
    textView.editable=NO;
    [self.messageView addSubview:textView];
}
-(void)setUiWithText:(NSString*)message url:(NSString*)url
{
    UITextView *textView=[[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.messageView.bounds.size.width, self.messageView.bounds.size.height/2)];
    textView.text=[NSString stringWithFormat:@"%@/n%@",message,url];
    textView.editable=NO;
    [self.messageView addSubview:textView];
}
-(void)setUiWithText:(NSString*)message array:(NSArray*)tempArray
{
        UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.messageView.bounds.size.width, self.messageView.bounds.size.height)];
        tableView.delegate=self;
        tableView.dataSource=self;
        [self.messageView addSubview:tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (requestCode==302000) {
        return self.newsArray.count;
    }
   else
       return self.menuArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    NSDictionary *dic;
    if (requestCode==302000) {
        dic=[self.newsArray objectAtIndex:indexPath.row];
           cell.textLabel.text=[NSString stringWithFormat:@"%@<%@>",[dic objectForKey:@"article"],[dic objectForKey:@"source"]];
        cell.textLabel.font=[UIFont systemFontOfSize:10];
        cell.detailTextLabel.text=[dic objectForKey:@"detailurl"];
        cell.detailTextLabel.font=[UIFont systemFontOfSize:10];
    }
    else
    {
        dic=[self.menuArray objectAtIndex:indexPath.row];
        cell.textLabel.text=[NSString stringWithFormat:@"%@:%@",[dic objectForKey:@"name"],[dic objectForKey:@"info"]];
        cell.detailTextLabel.text=[dic objectForKey:@"detailurl"];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"icon"]]];
        cell.textLabel.font=[UIFont systemFontOfSize:10];
        cell.detailTextLabel.font=[UIFont systemFontOfSize:10];
    }
    return cell;
}
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"web" sender:cell.detailTextLabel.text];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    webViewController *webVc=segue.destinationViewController;
    webVc.url=sender;
}
@end
