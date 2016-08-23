//
//  DNImageFlowViewController.h
//  ImagePicker
//
//  Created by DingXiao on 15/2/11.
//  Copyright (c) 2015年 Dennis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface DNImageFlowViewController : UIViewController
@property (nonatomic, assign)NSInteger maxImageCount;
@property (nonatomic, assign)NSInteger maxVideoCount;
- (instancetype)initWithGroupURL:(NSURL *)assetsGroupURL;
@end
