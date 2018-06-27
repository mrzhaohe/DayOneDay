//
//  ViewController.m
//  11
//
//  Created by 赵贺 on 2018/6/20.
//  Copyright © 2018年 赵贺. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "Person.h"
#import "UIView+Extension.h"
@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    /*
    属性列表
     class_copyPropertyList
     class_copyIvarList
     
    */
    
    
    u_int count = 0;
//
    
    //属性列表
    
    objc_property_t *propertyList = class_copyPropertyList([UIView class], &count);
//    Ivar *propertyList = class_copyIvarList([UIView class], &count);
    for (int i =0; i<count; i++) {

        const char *name = property_getName(propertyList[i]);
        NSString *propertyName = [NSString stringWithUTF8String:name];

        NSLog(@"%@",propertyName);


    }
//    成员变量
//    unsigned int count = 0;
//    Ivar *ivarList = class_copyIvarList([UIView class], &count);
//
//    for (int i = 0; i<count; i++) {
//
//        NSString *name = [NSString stringWithCString:ivar_getName(ivarList[i]) encoding:NSUTF8StringEncoding];
//        NSLog(@"name:%@",name);
//
//
//    }
//

    UIView *backview = [[UIView alloc] initWithFrame:self.view.bounds];

    backview.pame = @"100";
    [self.view addSubview:backview];

    NSLog(@"name:%@",backview.pame);

}



@end
