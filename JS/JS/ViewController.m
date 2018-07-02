//
//  ViewController.m
//  JS
//
//  Created by 赵贺 on 2018/7/2.
//  Copyright © 2018年 赵贺. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

@interface ViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>
@property (nonatomic, strong) WKWebView *webview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    config.userContentController = [WKUserContentController new];
    
    WKWebView *webview = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    webview.UIDelegate = self;
    webview.navigationDelegate = self;
    self.webview = webview;
    self.view = webview;
    
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"share" withExtension:@"html"];
    
    [webview loadRequest:[NSURLRequest requestWithURL:url]];
    
    
    [config.userContentController addScriptMessageHandler:self name:@"fireApp"];
    [config.userContentController addScriptMessageHandler:self name:@"screenshotReadyOver"];

    
    
}


-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    
    NSString *messagename = message.name;
    NSDictionary *messagebody = message.body[@"data"];
    NSString *trigger = message.body[@"trigger"];
    NSLog(@"msgname:%@",messagename);
    NSLog(@"body:%@",messagebody);
    
    if ([messagename isEqualToString:@"fireApp"]) {//分享
       
        if ([trigger isEqualToString:@"sns"] && [messagebody[@"sns_type"] intValue] == 3) {
            [self.webview evaluateJavaScript:@"screenshotReady()" completionHandler:^(id _Nullable value, NSError * _Nullable error) {
                NSLog(@"隐藏悬浮框");
            }];
        }
        
    }else if ([messagename isEqualToString:@"screenshotReadyOver"]){
        
        //截屏
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"开始截屏");
            [self.webview evaluateJavaScript:@"screenshotEnd()" completionHandler:^(id _Nullable value, NSError * _Nullable error) {
                NSLog(@"显示悬浮框");
            }];
            
        });   
    }
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.webview.configuration.userContentController removeAllUserScripts];
    
}











@end
