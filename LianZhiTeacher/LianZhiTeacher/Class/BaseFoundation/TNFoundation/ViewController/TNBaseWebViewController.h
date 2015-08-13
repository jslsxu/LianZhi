//
//  TNBaseWebViewController.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/18.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface TNBaseWebViewController : TNBaseViewController<UIWebViewDelegate>
{
    UIWebView*                  _webView;
    UIActivityIndicatorView*    _indicator;
}
@property (nonatomic, copy)NSString *url;
@end
