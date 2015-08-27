//
//  MessageVoiceButton.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/1/23.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "MessageVoiceButton.h"

@implementation MessageVoiceButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.type = MLPlayVoiceButtonTypeRight;
        [self setBackgroundImage:[[UIImage imageWithColor:[UIColor colorWithHexString:@"f0f0f0"] size:CGSizeMake(20, 20) cornerRadius:10] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
        
        _spanLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 100, frame.size.height)];
        [_spanLabel setBackgroundColor:[UIColor clearColor]];
        [_spanLabel setFont:[UIFont systemFontOfSize:15]];
        [_spanLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:_spanLabel];
    }
    return self;
}

- (void)setAudioItem:(AudioItem *)audioItem
{
    _audioItem = audioItem;
    [_spanLabel setText:[Utility formatStringForTime:_audioItem.timeSpan]];
}

@end
