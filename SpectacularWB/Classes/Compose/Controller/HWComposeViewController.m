//
//  HWComposeViewController.m
//  SpectacularWB
//
//  Created by Figo Han on 2016-07-11.
//  Copyright © 2016 Figo Han. All rights reserved.
//

#import "HWComposeViewController.h"
#import "UIView+Extension.h"
#import "HWComposeViewController.h"
#import "HWComposeTextView.h"
#import "HWAccountTool.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "HWComposeToolBarView.h"
@interface HWComposeViewController()
@property(nonatomic, weak) UITextView*composetextView;
@property(nonatomic, weak) HWComposeToolBarView*composeToolBar;
@end
@implementation HWComposeViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self setUpNav];
    [self setupTextView];
    [self setupToolBar];
    
    
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self.composetextView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidAppear:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)setUpNav
{
    //    self.view.backgroundColor=[UIColor blackColor];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelButtonDidClick:)];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Tweet" style:UIBarButtonItemStyleDone target:self action:@selector(tweetButtonDidClick:)];
    self.navigationItem.rightBarButtonItem.enabled=NO;
    
    
    /**
     *     设置标题
     */
    //    NSMutableDictionary * attribute=[NSMutableDictionary dictionary];
    //    attribute[NSFontAttributeName]=[UIFont systemFontOfSize:15];
    
    NSString * name=[HWAccountTool account].name;
    NSString * prefix=@"Compose";
    if (name) {
        UILabel * titleLabel=[[UILabel alloc]init];
        titleLabel.width=200;
        titleLabel.height=100;
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.numberOfLines=0;
        titleLabel.y=50;
        
        NSString * str=[NSString stringWithFormat:@"%@\n%@",prefix,name];
        NSMutableAttributedString * mAttributedString=[[NSMutableAttributedString alloc]initWithString:str];
        
        
        [mAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:[str rangeOfString:prefix]];
        
        [mAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:[str rangeOfString:name]];
        
        titleLabel.attributedText=mAttributedString;
        
        
        self.navigationItem.titleView=titleLabel;
        
    }else
    {
        
        
        self.navigationItem.title=prefix;
        
    }
    
    
    
    
}



-(void)setupTextView
{
    HWComposeTextView * composeTextView=[[HWComposeTextView alloc]init];
    
    composeTextView.frame=self.view.bounds;
    
    composeTextView.placeholder=@"What's happening？";
    
    [self.view addSubview:composeTextView];
    
    self.composetextView=composeTextView;
    
    
}


-(void)setupToolBar
{
    
    HWComposeToolBarView *composeToolBarView=[[HWComposeToolBarView alloc]init];
    composeToolBarView.height=44;
    composeToolBarView.x=0;
    composeToolBarView.y=self.view.height-composeToolBarView.height;
    composeToolBarView.width=self.view.width;
    self.composeToolBar=composeToolBarView;
    [self.view addSubview:composeToolBarView];
    
    
    
    
}


#pragma mark - 监听取消按钮点击事件

-(void)cancelButtonDidClick:(UIBarButtonItem*)barButtonItem
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}


#pragma mark - 监听键盘出现事件
-(void)keyboardDidAppear:(NSNotification*)notification
{
    
    NSLog(@"%@",notification.userInfo);
    
    NSDictionary * dic=notification.userInfo;
    
    NSTimeInterval timeInterval=[dic[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame=[dic[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:timeInterval animations:^{
        self.composeToolBar.y=keyboardFrame.origin.y-self.composeToolBar.height;
    }];
    

    
    
}



-(void)tweetButtonDidClick:(UIBarButtonItem*)barButtonItem
{
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary * parameters=[NSMutableDictionary dictionary];
    parameters[@"access_token"]=[HWAccountTool account].access_token;
    parameters[@"status"]=self.composetextView.text;
    
    
    [manager POST:@"https://api.weibo.com/2/statuses/update.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD showSuccess:@"Compose sucessfully!"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showSuccess:@"Compose failed!"];
        
    }];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    
}

/**
 *  when user start composing Compose Button can be touched
 */
-(void)textDidChange
{
    
    
    self.navigationItem.rightBarButtonItem.enabled=YES;
    
    
}

@end
