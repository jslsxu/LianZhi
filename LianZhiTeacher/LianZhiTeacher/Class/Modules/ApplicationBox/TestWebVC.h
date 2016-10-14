//
//  TestWebVC.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/11.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface TestWebVC : TNBaseViewController
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

@end
