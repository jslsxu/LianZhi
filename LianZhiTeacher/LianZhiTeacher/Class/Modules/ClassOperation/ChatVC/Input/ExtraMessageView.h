//
//  ExtraMessageView.h
//  LianZhiParent
//
//  Created by jslsxu on 15/9/2.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ExtraMessageViewDelegate <NSObject>
- (void)extraMessageViewOnSelectPhoto;
- (void)extraMessageViewOnSelectCamera;
- (void)extraMessageViewOnSelectGift;

@end

@interface ExtraMessageView : UIView
@property (nonatomic, weak)id<ExtraMessageViewDelegate> delegate;
@end
