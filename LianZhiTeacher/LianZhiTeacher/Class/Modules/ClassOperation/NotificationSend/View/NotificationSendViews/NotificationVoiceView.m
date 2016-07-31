//
//  NotificationVoiceView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/29.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationVoiceView.h"

@interface AudioContentView ()
@property (nonatomic, strong)AudioItem *audioItem;
@end

@implementation AudioContentView
- (instancetype)initWithAudioItem:(AudioItem *)audioItem{
    self = [super initWithFrame:CGRectZero];
    if(self){
        self.audioItem = audioItem;
        NSInteger second = audioItem.timeSpan;
        NSInteger maxWidth = kScreenWidth - 50 * 2 - 60 - 40;
        NSInteger width = maxWidth * second / 120 + 40;
        _voiceButton = [[ChatVoiceButton alloc] init];
        [_voiceButton setFrame:CGRectMake(0, 0, width, 32)];
        _voiceButton.type = MLPlayVoiceButtonTypeRight;
        [_voiceButton addTarget:self action:@selector(onVoiceClicked) forControlEvents:UIControlEventTouchUpInside];
        [_voiceButton setBackgroundImage:[[UIImage imageNamed:@"MessageSendedBG"] resizableImageWithCapInsets:UIEdgeInsetsMake(26, 20, 8, 20)] forState:UIControlStateNormal];
        [_voiceButton setBackgroundImage:[[UIImage imageNamed:@"MessageSendedBGHighlighted"] resizableImageWithCapInsets:UIEdgeInsetsMake(26, 20, 8, 20)] forState:UIControlStateHighlighted];

        [self addSubview:_voiceButton];
        
        _removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_removeButton setSize:CGSizeMake(20, 20)];
        [_removeButton setOrigin:CGPointMake(width + 10, (32 - 20) / 2)];
        [_removeButton addTarget:self action:@selector(onRemoveClicked) forControlEvents:UIControlEventTouchUpInside];
        [_removeButton setImage:[UIImage imageNamed:@"delete_target"] forState:UIControlStateNormal];
        [self addSubview:_removeButton];
        
        [self setSize:CGSizeMake(width + 20 + 10, 32)];
    }
    return self;
}

- (void)setAudioItem:(AudioItem *)audioItem{
    _audioItem = audioItem;
    
}

- (void)onVoiceClicked{
    
}

- (void)onRemoveClicked{
    
}

@end

@interface NotificationVoiceView (){
    UILabel*            _titleLabel;
    NSMutableArray*     _voiceViewArray;
    UIView*             _sepLine;
}

@end

#define kVoiceMargin            10

@implementation NotificationVoiceView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setClipsToBounds:YES];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_titleLabel setText:@"语音:"];
        [_titleLabel sizeToFit];
        [_titleLabel setOrigin:CGPointMake(kVoiceMargin, kVoiceMargin)];
        [self addSubview:_titleLabel];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [_sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:_sepLine];
        _voiceViewArray = [NSMutableArray array];
    }
    return self;
}

- (void)layoutSubviews{
    [_sepLine setFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
}

- (void)setVoiceArray:(NSArray *)voiceArray{
    _voiceArray = voiceArray;
    [_voiceViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_voiceViewArray removeAllObjects];
    if(_voiceArray.count == 0){
        [self setHeight:0];
    }
    else{
        CGFloat spaceXStart = _titleLabel.right + kVoiceMargin;
        CGFloat spaceYStart = kVoiceMargin;
        for (NSInteger i = 0; i < _voiceArray.count; i++) {
            AudioItem *item = _voiceArray[i];
            AudioContentView *voiceView = [[AudioContentView alloc] initWithAudioItem:item];
            [voiceView setOrigin:CGPointMake(spaceXStart, spaceYStart)];
            [_voiceViewArray addObject:voiceView];
            [self addSubview:voiceView];
            
            spaceYStart += kVoiceMargin + voiceView.height;
        }
        [self setHeight:spaceYStart];
    }
}

@end
