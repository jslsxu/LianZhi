//
//  TNBaseWebViewController.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/18.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface TNBaseWebViewController : TNBaseViewController
/**
 *  origin url
 */
@property (nonatomic, strong)NSURL* url;

/**
 *  embed webView
 */
@property (nonatomic, strong)UIWebView* webView;

/**
 *  tint color of progress view
 */
@property (nonatomic, strong)UIColor* progressViewColor;

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
