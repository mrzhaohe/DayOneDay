https://blog.csdn.net/chy555chy/article/details/51628079
###IDFA 唯一设备号

	[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]
	
	
`但是有几种情况下，会重新生成广告标示符。如果用户完全重置系统（(设置程序 -> 通用 -> 还原 -> 还原位置与隐私) ，这个广告标示符会重新生成。另外如果用户明确的还原广告(设置程序-> 通用 -> 关于本机 -> 广告 -> 还原广告标示符) ，那么广告标示符也会重新生成。`

###IDFV 同一个 bundleId 前缀下的都一样
	[UIDevice currentDevice].identifierForVendor.UUIDString



###UUID 
	NSString *uuid = [[NSUUID UUID] UUIDString];
	跟CFUUID一样，这个值系统也不会存储，每次调用的时候都会获得一个新的唯一标示符


