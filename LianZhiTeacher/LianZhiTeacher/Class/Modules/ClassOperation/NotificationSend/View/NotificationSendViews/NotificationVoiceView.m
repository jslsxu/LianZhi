//
//  NotificationVoiceView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/29.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationVoiceView.h"

@implementation AudioItemView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _bgImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"MessageSendedBG"] resizableImageWithCapInsets:UIEdgeInsetsMake(26, 20, 8, 20)]];
        [self addSubview:_bgImageView];
        
        _animateImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        NSMutableArray* animateImages = [NSMutableArray array];
        for (NSInteger i = 0; i < 3; i++) {
            [animateImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"notificaiton_voice_%zd",i + 1]]];
        }
        [_animateImageView setAnimationImages:animateImages];
        [self addSubview:_animateImageView];
        
//        _loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//        [self addSubview:_loadingIndicator];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)setAudioItem:(AudioItem *)audioItem{
    _audioItem = audioItem;
    
}

- (void)onTap{
    
}

@end

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
    [super layoutSubviews];
    [_sepLine setFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
}

- (void)setVoiceArray:(NSArray *)voiceArray{
    _voiceArray = voiceArray;
//    [_voiceViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    [_voiceViewArray removeAllObjects];
//    if(_voiceArray.count == 0){
//        [self setHeight:0];
//    }
//    else{
//        CGFloat maxWidth = self.width - kVoiceMargin - _titleLabel.right - kVoiceMargin;
//        CGFloat spaceXStart = _titleLabel.right + kVoiceMargin;
//        CGFloat spaceYStart = kVoiceMargin;
//        for (NSInteger i = 0; i < _voiceArray.count; i++) {
//            AudioItem *item = _voiceArray[i];
//            AudioContentView *voiceView = [[AudioContentView alloc] initWithMaxWidth:maxWidth];
//            [voiceView setAudioItem:item];
//            [voiceView setOrigin:CGPointMake(spaceXStart, spaceYStart)];
//            @weakify(self)
//            [voiceView setDeleteCallback:^{
//                @strongify(self)
//                [self deleteVoice:item];
//            }];
//            [_voiceViewArray addObject:voiceView];
//            [self addSubview:voiceView];
//            
//            spaceYStart += kVoiceMargin + voiceView.height;
//        }
//        [self setHeight:spaceYStart];
//    }
    
    if(_voiceArray.count == 0){
        [_voiceViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_voiceViewArray removeAllObjects];
        [self setHeight:0];
    }
    else{
        CGFloat maxWidth = self.width - kVoiceMargin - _titleLabel.right - kVoiceMargin;
        CGFloat spaceXStart = _titleLabel.right + kVoiceMargin;
        CGFloat spaceYStart = kVoiceMargin;
        if([_voiceArray count] > [_voiceViewArray count]){
            AudioContentView *lastVoiceView = [_voiceViewArray lastObject];
            spaceYStart = lastVoiceView.bottom + kVoiceMargin;
            for (NSInteger i = [_voiceViewArray count]; i < _voiceArray.count; i++) {
                AudioItem *item = _voiceArray[i];
                AudioContentView *voiceView = [[AudioContentView alloc] initWithMaxWidth:maxWidth];
                [voiceView setAudioItem:item];
                [voiceView setOrigin:CGPointMake(spaceXStart, spaceYStart)];
                if(!self.editDisable){
                    @weakify(self)
                    [voiceView setDeleteCallback:^{
                        @strongify(self)
                        [self deleteVoice:item];
                    }];
                }
                [_voiceViewArray addObject:voiceView];
                [self addSubview:voiceView];
                
                spaceYStart += kVoiceMargin + voiceView.height;
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
                if(!self.editDisable){
                    @weakify(self)
                    [voiceItemView setDeleteCallback:^{
                        @strongify(self)
                        [self deleteVoice:item];
                    }];
                }
                spaceYStart += kVoiceMargin + voiceItemView.height;
            }
            [self setHeight:spaceYStart];
        }
    }
}

- (void)deleteVoice:(AudioItem *)audioItem{
    __weak typeof(self) wself = self;
    LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"提示" message:@"确定要删除语音吗" style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除"];
    [alertView setDestructiveButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
    [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
    [alertView setDestructiveHandler:^(LGAlertView *alertView) {
        if(wself.deleteDataCallback){
            wself.deleteDataCallback(audioItem);
        }
    }];
    [alertView showAnimated:YES completionHandler:nil];
}

@end
