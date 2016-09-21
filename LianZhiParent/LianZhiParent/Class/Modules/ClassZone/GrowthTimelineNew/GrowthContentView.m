//
//  GrowthContentView.m
//  LianZhiParent
//
//  Created by qingxu zhou on 16/9/21.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "GrowthContentView.h"

@implementation GrowthContentView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.layer setCornerRadius:15];
        [self.layer setMasksToBounds:YES];
        
        _avatarView = [[AvatarView alloc] initWithRadius:20];
        [self addSubview:_avatarView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_nameLabel];
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_dateLabel setFont:[UIFont systemFontOfSize:12]];
        [_dateLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [self addSubview:_dateLabel];
        
        _statusViewArray = [NSMutableArray arrayWithCapacity:0];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectZero];
        [_sepLine setBackgroundColor:[UIColor colorWithHexString:@"eeeef4"]];
        [self addSubview:_sepLine];
        
        _commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_commentLabel setFont:[UIFont systemFontOfSize:14]];
        [_commentLabel setNumberOfLines:0];
        [_commentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self addSubview:_commentLabel];
    }
    return self;
}

- (void)setupSubviews{
    
}

- (void)setGrowthTimelineItem:(GrowthTimelineItem *)growthTimelineItem{
    _growthTimelineItem = growthTimelineItem;
    [self setupSubviews];
}
@end

