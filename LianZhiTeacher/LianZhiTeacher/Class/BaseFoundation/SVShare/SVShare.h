//
//  SVShare.h
//  SViPad
//
//  Created by jslsxu on 14-7-3.
//  Copyright (c) 2014年 sohu-inc. All rights reserved.
//

#import <ShareSDK/ShareSDK.h>
#import "SVShareDef.h"
#import "SVShareManager.h"
@interface SVShare : NSObject<ISVShareManager>

+(SVShare*)sharedInstance;

- (void)initialize;

@end
