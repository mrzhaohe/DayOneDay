//
//  UIView+Extension.m
//  11
//
//  Created by 赵贺 on 2018/6/26.
//  Copyright © 2018年 赵贺. All rights reserved.
//

#import "UIView+Extension.h"
#import <objc/runtime.h>
@implementation UIView (Extension)

-(void)setPame:(NSString *)pame{
    objc_setAssociatedObject(self.class, @"pame", pame, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSString *)pame{
    return objc_getAssociatedObject(self.class, @"pame");
}

@end
