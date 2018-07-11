//
//  ViewController.m
//  Shadow
//
//  Created by 赵贺 on 2018/7/11.
//  Copyright © 2018年 赵贺. All rights reserved.
//
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)(((rgbValue) & 0xFF0000) >> 16))/255.0 green:((float)(((rgbValue) & 0xFF00) >> 8))/255.0 blue:((float)((rgbValue) & 0xFF))/255.0 alpha:1.0]

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    view1.backgroundColor = [UIColor whiteColor];//一定要设置 不设置则子视图添加阴影
    [self.view addSubview:view1];
    
    
    //渐变色 一定加在前面
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view1.bounds;
    [view1.layer addSublayer:gradientLayer];
    //设置渐变区域的起始和终止位置（范围为0-1）
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    //设置颜色数组
    gradientLayer.colors = @[(__bridge id)UIColorFromRGB(0xFFFFFF).CGColor,
                             (__bridge id)UIColorFromRGB(0xFFF7F7).CGColor];
    //设置颜色分割点（范围：0-1）
    gradientLayer.locations = @[@(0.5),@(1)];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:13];
    label.frame = CGRectMake(10, 10, 100, 20);
    label.text = @"label1111";
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [view1 addSubview:label];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.font = [UIFont systemFontOfSize:13];
    label1.frame = CGRectMake(10, 40, 100, 20);
    label1.text = @"label2221";
    label1.textColor = [UIColor blackColor];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.backgroundColor = [UIColor clearColor];
    [view1 addSubview:label1];
    
    view1.layer.cornerRadius = 5;
    view1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view1.layer.borderWidth = 0.5;
    
    //阴影
    view1.layer.shadowOpacity = 1;//一定要设置
    view1.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    view1.layer.cornerRadius = 3;
    view1.layer.shadowOffset = CGSizeMake(0, 0);//四周阴影
//    view1.layer.shadowOffset = CGSizeMake(-3, 3);//设置其他则为其他方向偏(0,0为基准)

    
}


@end
