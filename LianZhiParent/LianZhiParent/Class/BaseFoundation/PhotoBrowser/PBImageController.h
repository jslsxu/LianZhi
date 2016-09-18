//
//  PBImageController.h
//  LianZhiParent
//
//  Created by qingxu zhou on 16/9/16.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"
@interface PBImageController : NSObject
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(PBImageController)
- (void)showForView:(UIView *)targetView placeHolder:(UIImage *)image url:(NSString *)imageUrl;
@end
