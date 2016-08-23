//
//  ChildrenSelectView.h
//  LianZhiParent
//
//  Created by jslsxu on 15/1/29.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ChildInfoBlk)(NSInteger idx);

@interface ChildInfoView : UIButton
{
    AvatarView*     _avatar;
    UILabel*        _tintLabel;
    UIImageView*    _redDot;
}
@property (nonatomic, assign)BOOL childSelected;
@property (nonatomic, readonly)UIImageView* redDot;
@property (nonatomic, strong)ChildInfo *childInfo;
@property (nonatomic, assign)NSInteger idx;
@property (nonatomic, copy)ChildInfoBlk childSelectBlk;
@end

@protocol ChildrenSelectDelegate <NSObject>
- (void)childrenSelectFinished:(ChildInfo *)childInfo;

@end

@interface ChildrenSelectView : UIView
{
    
    UIScrollView*   _scrollView;
    NSMutableArray* _childButtonArray;
}
@property (nonatomic, weak)id<ChildrenSelectDelegate> delegate;
@end
