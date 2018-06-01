//
//  ViewController.m
//  YY
//
//  Created by 赵贺 on 2018/5/30.
//  Copyright © 2018年 赵贺. All rights reserved.
//

#import "ViewController.h"
#import <YYKit/YYKit.h>
#import <MWPhotoBrowser.h>
@interface ViewController ()<MWPhotoBrowserDelegate>
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSMutableArray *largeItems;
@property (nonatomic, strong) NSMutableArray *selectArr;
@end

@implementation ViewController
-(NSMutableArray *)selectArr{
    if (!_selectArr) {
        _selectArr = @[].mutableCopy;
    }
    return _selectArr;
}
-(NSMutableArray *)items{
    if (!_items) {
        _items = @[].mutableCopy;
    }
    return _items;
}
-(NSMutableArray *)largeItems{
    if (!_largeItems) {
        _largeItems = @[].mutableCopy;
    }
    return _largeItems;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    YYLabel *contentLabel = [YYLabel new];
    contentLabel.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);

    [self.view addSubview:contentLabel];
    
    //下面两个一定要设置
    contentLabel.preferredMaxLayoutWidth = self.view.frame.size.width;
    contentLabel.numberOfLines = 0;
    
    NSMutableAttributedString *contentText = [NSMutableAttributedString new];
    contentText.lineBreakMode = NSLineBreakByWordWrapping;
    contentText.lineSpacing = 7;
    UIFont *font  = [UIFont systemFontOfSize:16];
    contentText.font = font;
    
    YYImage *image = [YYImage imageNamed:@"image.jpeg"];
    
    image.preloadAllAnimatedImageFrames = YES;
    YYImage *image2 = [YYImage imageNamed:@"image2.jpg"];
    
    image2.preloadAllAnimatedImageFrames = YES;
    
    
    //文字
    [contentText appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"这是第一张图片"]];
     
    {
        //第一张图片
        YYAnimatedImageView *imageview = [[YYAnimatedImageView alloc] initWithImage:image];
        
        imageview.frame = CGRectMake(0, 0, self.view.frame.size.width-10, 200);
        
        NSMutableAttributedString *attachText = [NSMutableAttributedString attachmentStringWithContent:imageview contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageview.frame.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
        
        //设置点击事件 信息

        YYTextHighlight *texthighlight = [YYTextHighlight new];
        texthighlight.userInfo = @{@"thumpview":imageview,@"largeUrl":@"http://img.zcool.cn/community/0142135541fe180000019ae9b8cf86.jpg@1280w_1l_2o_100sh.png"};
        [attachText setTextHighlight:texthighlight range:attachText.rangeOfAll];
        
        [contentText appendAttributedString:attachText];
        
    }
    //文字
    [contentText appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"这是第二张图片"]];
    
    
    {
        //第二张图片
        YYAnimatedImageView *imageview2 = [[YYAnimatedImageView alloc] initWithImage:image2];
        
        imageview2.frame = CGRectMake(0, 0, self.view.frame.size.width-10, 200);
        NSMutableAttributedString *attachText2 = [NSMutableAttributedString attachmentStringWithContent:imageview2 contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageview2.frame.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
        
        //设置点击事件 信息
        YYTextHighlight *texthighlight2 = [YYTextHighlight new];
        
        //thumpview 缩略图 largeUrl 大图 URL
        texthighlight2.userInfo = @{@"thumpview":imageview2,@"largeUrl":@"http://www.taopic.com/uploads/allimg/140702/240495-140F216321759.jpg"};
        [attachText2 setTextHighlight:texthighlight2 range:attachText2.rangeOfAll];
        
        [contentText appendAttributedString:attachText2];
        
    }
    
    contentLabel.attributedText = contentText;
    
    //修改 attachment 内边距
    for (YYTextAttachment *attach in contentLabel.textLayout.attachments) {
        attach.contentInsets = UIEdgeInsetsMake(10, 0, 10, 0);

        YYAnimatedImageView *imageview =attach.content;
        YYImage *image = (YYImage *)imageview.image;
        NSLog(@"image:%@",image);

    }
    
    //遍历 attachment range
    for (NSValue *range in contentLabel.textLayout.attachmentRanges) {

        NSRange r = [range rangeValue];
        NSLog(@"资源所在位置%ld 长度：%ld",r.location,r.length);
    }
    
    __weak YYLabel *weakContentLabel = contentLabel;
    
    __weak typeof(self) weakSelf = self;
    //点击事件 处理
    contentLabel.highlightTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
      
        NSArray *attachmentRanges = weakContentLabel.textLayout.attachmentRanges;

        [weakSelf.items removeAllObjects];
        [weakSelf.largeItems removeAllObjects];
        
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        
        // Set options
        browser.displayActionButton = NO;
        browser.displayNavArrows = NO;
        browser.displaySelectionButtons = YES;
        browser.zoomPhotosToFill = YES;
        browser.alwaysShowControls = NO;
        browser.enableGrid = YES;//是否展示缩略图
        browser.startOnGrid = NO;
        
    
        for (int i =0; i<attachmentRanges.count; i++) {
         
            NSRange eachRange = [attachmentRanges[i] rangeValue];
            YYTextHighlight *eachTexthight = [text attribute:YYTextHighlightAttributeName atIndex:eachRange.location];
            
            // YYTextHighlight userinfo 属性内可以设置 缩略图以及大图信息
            YYAnimatedImageView *eachThumbImg = eachTexthight.userInfo[@"thumpview"];
            NSString *eachAttachLargeUrl = eachTexthight.userInfo[@"largeUrl"];
            
            MWPhoto *thumbPhoto = [MWPhoto photoWithImage:eachThumbImg.image];
            MWPhoto *largePhoto = [MWPhoto photoWithURL:[NSURL URLWithString:eachAttachLargeUrl]];
            [weakSelf.items addObject:thumbPhoto];

            [weakSelf.largeItems addObject:largePhoto];
            if (eachRange.location == range.location && range.length == eachRange.length) {
                NSLog(@"--%d",i);
                [browser setCurrentPhotoIndex:i];
            }
            
        }
        
        for (int i = 0; i < weakSelf.largeItems.count; i++) {
            [weakSelf.selectArr addObject:[NSNumber numberWithBool:NO]];
        }
        
        UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:browser];
        navC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [weakSelf.navigationController presentViewController:navC animated:YES completion:nil];
    };
}
#pragma mark - MWPhotosBrowserDelegate
//必须实现的方法
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    return  self.largeItems.count;
}
- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    
    if (index < self.largeItems.count) {
        return [self.largeItems objectAtIndex:index];
    }
    return nil;
}
//** 展示缩略图
-(id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index{
    return [self.items objectAtIndex:index];
}

-(void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//** 是否被选中
- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {

    return [[self.selectArr objectAtIndex:index] boolValue];
}
- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
    [self.selectArr replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:selected]];
}


@end
