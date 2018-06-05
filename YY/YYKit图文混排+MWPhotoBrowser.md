# DayOneDay

##1.MWPhotoBrowser 使用
 [参考](https://blog.csdn.net/qq_22157341/article/details/67636905)

		MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];

        // Set options
        browser.displayActionButton = NO;//是否展示分享按钮
        browser.displayNavArrows = NO;//
        browser.displaySelectionButtons = YES;//是否展示选中按钮
        browser.zoomPhotosToFill = YES;//
        browser.alwaysShowControls = NO;
        browser.enableGrid = YES;//是否展示缩略图
        browser.startOnGrid = NO;
        
        [browser setCurrentPhotoIndex:i];//当前图片

>      		如果只需要使用图片浏览 也可以直接使用 - (id)initWithPhotos:(NSArray *)photosArray; 不必遵守代理   
        
####代理方法
	#pragma mark - MWPhotosBrowserDelegate

- - -
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
- - -
	//** 展示缩略图 与 browser.enableGrid = YES;配合使用
	-(id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index{
   		 return [self.items objectAtIndex:index];
	}

	-(void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser{
    
   	 [self dismissViewControllerAnimated:YES completion:nil];
	}
	
- - -
	//** 是否被选中
	-(BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {
    	return [[self.selectArr objectAtIndex:index] boolValue];
	}
	-(void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
   		 [self.selectArr replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:selected]];
	}
	
	
#2.图文混排
	
	1.YYLabel 基本使用
***
	
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
    
***
	2. 添加文本		
> > 	[contentText appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"这是第一张图片"]];

	
***
	3. 添加图片

	YYAnimatedImageView *imageview = [[YYAnimatedImageView alloc] initWithImage:image];
	imageview.frame = CGRectMake(0, 0, self.view.frame.size.width-10, 200);
	NSMutableAttributedString *attachText = [NSMutableAttributedString attachmentStringWithContent:imageview contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageview.frame.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
	//设置点击事件 信息
	YYTextHighlight *texthighlight = [YYTextHighlight new];
	texthighlight.userInfo = @{@"thumpview":imageview,@"largeUrl":@"http://img.zcool.cn/community/0142135541fe180000019ae9b8cf86.jpg@1280w_1l_2o_100sh.png"};[attachText setTextHighlight:texthighlight range:attachText.rangeOfAll];[contentText appendAttributedString:attachText];
***
	4.点击事件  
	 
	
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
        			
			



