//
//  NotificationSendTargetView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/6/30.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationSendTargetView.h"

#define kItemHeight             20
#define kItemHMargin            8
#define kItemVMargin            10
#define kTargetViewMaxHeight    160

@implementation TargetItemView
- (instancetype)initWithUserInfo:(UserInfo *)userInfo{
    self = [super initWithFrame:CGRectZero];
    if(self){
        self.userInfo = userInfo;
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_nameLabel.layer setCornerRadius:10];
        [_nameLabel.layer setMasksToBounds:YES];
        [_nameLabel setBackgroundColor:kCommonTeacherTintColor];
        [_nameLabel setTextColor:[UIColor whiteColor]];
        [_nameLabel setFont:[UIFont systemFontOfSize:12]];
        [_nameLabel setTextAlignment:NSTextAlignmentCenter];
        [_nameLabel setText:self.userInfo.name];
        [_nameLabel sizeToFit];
        [_nameLabel setFrame:CGRectMake(8, 0, _nameLabel.width + 18, kItemHeight)];
        [self setSize:CGSizeMake(_nameLabel.width + 8, _nameLabel.height)];
        [self addSubview:_nameLabel];
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setImage:[UIImage imageNamed:@"delete_target"] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(onCancelClicked) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton setFrame:CGRectMake(0, 0, 15, 15)];
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
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [self addSubview:_scrollView];
        _memberArray = [NSMutableArray array];
        
    }
    return self;
}

- (void)setSendArray:(NSArray *)sendArray{
    _sendArray = sendArray;
    for(TargetItemView *itemView in _memberArray)
    {
        [itemView removeFromSuperview];
    }
    [_memberArray removeAllObjects];
    
    NSInteger spaceXStart = 0;
    NSInteger spaceYStart = 0;
    NSInteger totalHeight = 0;
    for (UserInfo *userInfo in _sendArray) {
        TargetItemView *itemView = [[TargetItemView alloc] initWithUserInfo:userInfo];
        if(itemView.width + spaceXStart + kItemHMargin > _scrollView.width){
            spaceXStart = 0;
            spaceYStart += kItemHeight + kItemVMargin;
        }
        [itemView setOrigin:CGPointMake(spaceXStart, spaceYStart)];
        spaceXStart += kItemHMargin + itemView.width;
        [_memberArray addObject:itemView];
        [_scrollView addSubview:itemView];
        totalHeight = itemView.bottom;
    }
    [_scrollView setContentSize:CGSizeMake(_scrollView.width, totalHeight)];
    [self setHeight:MIN(kTargetViewMaxHeight, totalHeight)];
    [_scrollView setHeight:self.height];
}

@end
