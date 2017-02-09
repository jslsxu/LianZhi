//
//  RecordReplyVoiceView.m
//  LianZhiParent
//
//  Created by jslsxu on 17/2/9.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import "RecordReplyVoiceView.h"

#define kVoiceMargin            10

@interface RecordReplyVoiceView (){
    UILabel*            _titleLabel;
    NSMutableArray*     _voiceViewArray;
    UIView*             _sepLine;
}

@end

@implementation RecordReplyVoiceView

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
