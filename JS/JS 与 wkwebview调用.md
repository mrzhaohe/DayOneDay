JS 与 wkwebview 调用



<!--   引入 jquery   -->
	<script src="https://cdn.bootcss.com/jquery/1.12.2/jquery.min.js"></script>

jq 取 a 标签

	var btn1 = $(".first");
	btn1.hide();



js 调 OC 


1.wkwebview 注册js 消息通知


	[config.userContentController addScriptMessageHandler:self name:@"fireApp"];
    [config.userContentController addScriptMessageHandler:self name:@"screenshotReadyOver"];

2.js 发送消息
	
	//window.webkit.messageHandlers.<name>.postMessage(<messageBody>) 
	
	window.webkit.messageHandlers.fireApp.postMessage(dict);
	  
3.接收到消息

	-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
		if ([messagename isEqualToString:@"fireApp"]){
		//TO-DO
		}
	}  
	  
	
OC 调 js 

	[self.webview evaluateJavaScript:@"screenshotEnd()" completionHandler:^(id _Nullable value, NSError * _Nullable error) {
    	NSLog(@"显示悬浮框");
    }];  




