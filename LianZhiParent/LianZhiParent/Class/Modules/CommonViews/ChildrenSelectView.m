//
//  ChildrenSelectView.m
//  LianZhiParent
//
//  Created by jslsxu on 15/1/29.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ChildrenSelectView.h"

#define kChildButtonBaseTag             1000

@implementation ChildInfoView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _avatar = [[AvatarView alloc] initWithFrame:self.bounds];
        [_avatar setUserInteractionEnabled:NO];
        [_avatar.layer setCornerRadius:_avatar.width / 2];
        [_avatar.layer setMasksToBounds:YES];
        [self addSubview:_avatar];
        
//        _tintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height - 13, self.width, 13)];
//        [_tintLabel setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.7]];
//        [_tintLabel setTextAlignment:NSTextAlignmentCenter];
//        [_tintLabel setFont:[UIFont systemFontOfSize:9]];
//        [_tintLabel setTextColor:[UIColor whiteColor]];
//        [_tintLabel setText:@"当前"];
//        [_avatar addSubview:_tintLabel];
        
        _redDot = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        [_redDot setImage:[UIImage imageNamed:@"RedDot.png"]];
        [_redDot setOrigin:CGPointMake(_avatar.right - 8, _avatar.y)];
        [self addSubview:_redDot];
        [_redDot setHidden:YES];
    }
    return self;
}

- (void)setChildInfo:(ChildInfo *)childInfo
{
    _childInfo = childInfo;
    _redDot.hidden = !childInfo.hasNew;
    [_avatar sd_setImageWithURL:[NSURL URLWithString:childInfo.avatar] placeholderImage:nil];
}

- (void)setChildSelected:(BOOL)childSelected
{
    _childSelected = childSelected;
    [_tintLabel setHidden:!_childSelected];
}

@end

@implementation ChildrenSelectView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onStatusChanged) name:kStatusChangedNotification object:nil];
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [_scrollView setScrollsToTop:NO];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [self addSubview:_scrollView];
        
        _childButtonArray = [[NSMutableArray alloc] initWithCapacity:0];
        [self setupSubviews];
    }
    return self;
}

- (void)onStatusChanged
{
    for (ChildInfoView *itemView in _childButtonArray) {
        ChildInfo *childInfo = itemView.childInfo;
        BOOL hasNew = NO;
        for (NoticeItem *notice in [UserCenter sharedInstance].statusManager.notice)
        {
            if([notice.childID isEqualToString:childInfo.uid] && notice.num > 0)
            {
                hasNew = YES;
            }
        }
        childInfo.hasNew = hasNew;
        [itemView.redDot setHidden:!hasNew];
    }

}

- (void)setupSubviews
{
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_childButtonArray removeAllObjects];
    CGFloat length = 36;
    NSInteger innerMargin = 5;
    NSArray *children = [UserCenter sharedInstance].children;
    CGFloat spaceXStart = 0;
    for (NSInteger i = 0; i < children.count; i++) {
        ChildInfo *childInfo = children[i];
        ChildInfoView *childInfoView = [[ChildInfoView alloc] initWithFrame:CGRectMake(spaceXStart, (self.height - length) / 2, length, length)];
        spaceXStart += (length + innerMargin);
        [childInfoView addTarget:self action:@selector(onChildItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [childInfoView setChildInfo:childInfo];
        BOOL isCur = [[UserCenter sharedInstance].curChild.uid isEqualToString:childInfo.uid];
        [childInfoView setChildSelected:isCur];
        [childInfoView setAlpha:isCur ? 1 : 0.7];
        [_scrollView addSubview:childInfoView];
        [_childButtonArray addObject:childInfoView];
    }
    [_scrollView setContentSize:CGSizeMake((length + innerMargin) * children.count, _scrollView.height)];
}

- (void)onChildItemClicked:(ChildInfoView *)infoView
{
    ChildInfo *childInfo = infoView.childInfo;
    [[UserCenter sharedInstance] setCurChild:childInfo];
    [self setupSubviews];
    if([self.delegate respondsToSelector:@selector(childrenSelectFinished:)])
        [self.delegate childrenSelectFinished:childInfo];
}
@end
