//
//  TNBaseWebViewController.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/18.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import <WebKit/WebKit.h>
@interface TNBaseWebViewController : TNBaseViewController
/**
 *  origin url
 */
@property (nonatomic, strong)NSURL* url;

/**
 *  embed webView
 */
@property (nonatomic, strong)WKWebView* webView;

/**
 *  get instance with url
 *
 *  @param url url
 *
 *  @return instance
 */
-(instancetype)initWithUrl:(NSURL*)url;


-(void)reloadWebView;
@end
