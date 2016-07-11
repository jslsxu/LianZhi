//
//  NotificationSendTargetView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/6/30.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationSendTargetView.h"

#define kItemHeight             30
#define kItemHMargin            20
#define kItemVMargin            10
#define kTargetViewMaxHeight    160

@implementation TargetItemView
- (instancetype)initWithUserInfo:(UserInfo *)userInfo{
    self = [super initWithFrame:CGRectZero];
    if(self){
        self.userInfo = userInfo;
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_nameLabel setBackgroundColor:kCommonTeacherTintColor];
        [_nameLabel setTextColor:[UIColor whiteColor]];
        [_nameLabel setFont:[UIFont systemFontOfSize:12]];
        [_nameLabel setTextAlignment:NSTextAlignmentCenter];
        [_nameLabel setText:self.userInfo.name];
        [_nameLabel sizeToFit];
        [_nameLabel setSize:CGSizeMake(_nameLabel.width + 20, kItemHeight)];
        [self setSize:_nameLabel.size];
        [self addSubview:_nameLabel];
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton addTarget:self action:@selector(onCancelClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelButton];
    }
    return self;
}

- (void)onCancelClicked{
    if(self.removeBlk){
        self.removeBlk();
    }
}

@end

@implementation NotificationSendTargetView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [_scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [self addSubview:_scrollView];
        _memberArray = [NSMutableArray array];
        
    }
    return self;
}

- (void)setSendArray:(NSArray *)sendArray{
    _sendArray = sendArray;
    for(TargetItemView *itemView in self.subviews)
    {
        [itemView removeFromSuperview];
    }
    [_memberArray removeAllObjects];
    
    NSInteger spaceXStart = kItemHMargin;
    NSInteger spaceYStart = kItemVMargin;
    NSInteger totalHeight = 0;
    for (UserInfo *userInfo in _sendArray) {
        TargetItemView *itemView = [[TargetItemView alloc] initWithUserInfo:userInfo];
        if(itemView.width + spaceXStart + kItemHMargin + kItemHMargin > _scrollView.width){
            spaceXStart = kItemHMargin;
            spaceYStart += kItemHeight + kItemVMargin;
        }
        [itemView setOrigin:CGPointMake(spaceXStart, spaceYStart)];
        [_scrollView addSubview:itemView];
        totalHeight = itemView.bottom + kItemVMargin;
    }
    [self setHeight:MIN(kTargetViewMaxHeight, totalHeight)];
}

@end
