//
//  NotificationDetailVoiceView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/30.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationDetailVoiceView.h"
#import "ChatVoiceButton.h"
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
        [_topLine setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin];
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
    [_voiceViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_voiceViewArray removeAllObjects];
    if(_voiceArray.count == 0){
        [self setHeight:0];
    }
    else{
        CGFloat maxWidth = self.width - 10 * 2;
        CGFloat spaceXStart = 10;
        CGFloat spaceYStart = 10;
        for (NSInteger i = 0; i < _voiceArray.count; i++) {
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

}

@end
