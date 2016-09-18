//
//  NotificationDetailVoiceView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/30.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationDetailVoiceView.h"
#import "ChatVoiceButton.h"

@interface AudioContentView ()
@property (nonatomic, assign)CGFloat maxWidth;
@end

@implementation AudioContentView
- (instancetype)initWithMaxWidth:(CGFloat)maxWidth{
    self = [super initWithFrame:CGRectMake(0, 0, maxWidth, 32)];
    if(self){
        self.maxWidth = maxWidth;
        _voiceButton = [[ChatVoiceButton alloc] init];
        _voiceButton.type = MLPlayVoiceButtonTypeRight;
        [_voiceButton addTarget:self action:@selector(onVoiceClicked) forControlEvents:UIControlEventTouchUpInside];
        [_voiceButton setBackgroundImage:[[UIImage imageNamed:@"MessageSendedBG"] resizableImageWithCapInsets:UIEdgeInsetsMake(26, 20, 8, 20)] forState:UIControlStateNormal];
        [_voiceButton setBackgroundImage:[[UIImage imageNamed:@"MessageSendedBGHighlighted"] resizableImageWithCapInsets:UIEdgeInsetsMake(26, 20, 8, 20)] forState:UIControlStateHighlighted];
        
        [self addSubview:_voiceButton];
        
        _durationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_durationLabel setFont:[UIFont systemFontOfSize:14]];
        [_durationLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [self addSubview:_durationLabel];
        
        
        _removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_removeButton setSize:CGSizeMake(30, 32)];
        [_removeButton addTarget:self action:@selector(onRemoveClicked) forControlEvents:UIControlEventTouchUpInside];
        [_removeButton setImage:[UIImage imageNamed:@"delete_target"] forState:UIControlStateNormal];
        [_removeButton setHidden:YES];
        [self addSubview:_removeButton];
    }
    return self;
}

- (void)setDeleteCallback:(void (^)())deleteCallback{
    _deleteCallback = [deleteCallback copy];
    [_removeButton setHidden:NO];
}

- (void)setAudioItem:(AudioItem *)audioItem{
    _audioItem = audioItem;
    [_durationLabel setText:[Utility formatStringForTime:_audioItem.timeSpan]];
    [_durationLabel sizeToFit];
    CGFloat maxWidth = self.maxWidth - 30 - _durationLabel.width - 10;
    CGFloat audioWidth = [self audioButtonWidthWithDuration:_audioItem.timeSpan maxWidth:maxWidth];
    [_voiceButton setFrame:CGRectMake(0, 0, audioWidth, 32)];
    [_durationLabel setOrigin:CGPointMake(_voiceButton.right + 10, (self.height - _durationLabel.height) / 2)];
    [_removeButton setOrigin:CGPointMake(_durationLabel.right, 0)];
}

- (void)onVoiceClicked{
    if([self.audioItem.audioUrl hasPrefix:@"http:"]){
        [_voiceButton setVoiceWithURL:[NSURL URLWithString:self.audioItem.audioUrl] withAutoPlay:YES];
    }
    else{
        [_voiceButton setVoiceWithURL:[NSURL fileURLWithPath:self.audioItem.audioUrl] withAutoPlay:YES];
    }
}

- (void)onRemoveClicked{
    if(self.deleteCallback){
        self.deleteCallback();
    }
}

- (CGFloat)audioButtonWidthWithDuration:(NSInteger)duration maxWidth:(CGFloat)maxWidth{
    return (maxWidth - 60) * (duration - 2) / (120 - 2) + 60;
}

@end


@interface NotificationDetailVoiceView (){
    NSMutableArray*     _voiceViewArray;
    UIView*             _topLine;
    UIView*             _bottomLine;
}

@end

@implementation NotificationDetailVoiceView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setClipsToBounds:YES];
        _voiceViewArray = [NSMutableArray arrayWithCapacity:0];
        _topLine = [[UIView alloc] initWithFrame:CGRectMake(10, 0, self.width - 10 * 2, kLineHeight)];
        [_topLine setBackgroundColor:kSepLineColor];
        [self addSubview:_topLine];
        
        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(10, self.height - kLineHeight, self.width - 10 * 2, kLineHeight)];
        [_bottomLine setBackgroundColor:kSepLineColor];
        [_bottomLine setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
        [self addSubview:_bottomLine];
    }
    return self;
}

- (void)setVoiceArray:(NSArray *)voiceArray{
    _voiceArray = voiceArray;
    //    [_voiceViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //    [_voiceViewArray removeAllObjects];
    //    if(_voiceArray.count == 0){
    //        [self setHeight:0];
    //    }
    //    else{
    //        CGFloat maxWidth = self.width - 10 * 2;
    //        CGFloat spaceXStart = 10;
    //        CGFloat spaceYStart = 10;
    //        for (NSInteger i = 0; i < _voiceArray.count; i++) {
    //            AudioItem *item = _voiceArray[i];
    //            AudioContentView *voiceView = [[AudioContentView alloc] initWithMaxWidth:maxWidth];
    //            [voiceView setAudioItem:item];
    //            [voiceView setOrigin:CGPointMake(spaceXStart, spaceYStart)];
    //            [_voiceViewArray addObject:voiceView];
    //            [self addSubview:voiceView];
    //
    //            spaceYStart += 10 + voiceView.height;
    //        }
    //        [self setHeight:spaceYStart];
    //    }
    if(_voiceArray.count == 0){
        [_voiceViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_voiceViewArray removeAllObjects];
        [self setHeight:0];
    }
    else{
        CGFloat maxWidth = self.width - 10 * 2;
        CGFloat spaceXStart = 10;
        CGFloat spaceYStart = 10;
        if([_voiceArray count] > [_voiceViewArray count]){
            AudioContentView *lastVoiceView = [_voiceViewArray lastObject];
            spaceYStart = lastVoiceView.bottom + 10;
            for (NSInteger i = [_voiceViewArray count]; i < _voiceArray.count; i++) {
                AudioItem *item = _voiceArray[i];
                AudioContentView *voiceView = [[AudioContentView alloc] initWithMaxWidth:maxWidth];
                [voiceView setAudioItem:item];
                [voiceView setOrigin:CGPointMake(spaceXStart, spaceYStart)];
                [_voiceViewArray addObject:voiceView];
                [self addSubview:voiceView];
                
                spaceYStart += 10 + voiceView.height;
            }
            [self setHeight:spaceYStart];
        }
        else{
            while ([_voiceViewArray count] > [_voiceArray count]) {
                AudioContentView *voiceItemView = [_voiceViewArray lastObject];
                [voiceItemView removeFromSuperview];
                [_voiceViewArray removeObject:voiceItemView];
            }
            for (NSInteger i = 0; i < _voiceArray.count; i++) {
                AudioItem *item = _voiceArray[i];
                AudioContentView *voiceItemView = _voiceViewArray[i];
                [voiceItemView setAudioItem:item];
                [voiceItemView setOrigin:CGPointMake(spaceXStart, spaceYStart)];
                spaceYStart += 10 + voiceItemView.height;
            }
            [self setHeight:spaceYStart];
        }
    }
}

@end
