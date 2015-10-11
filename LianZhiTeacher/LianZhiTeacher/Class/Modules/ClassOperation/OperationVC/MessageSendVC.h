//
//  MessageSendVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/9/10.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface MessageSendVC : TNBaseViewController
@property (nonatomic, copy)NSString *words;
- (NSDictionary *)params;
- (NSArray *)imageArray;
- (NSData *)audioData;
@end
