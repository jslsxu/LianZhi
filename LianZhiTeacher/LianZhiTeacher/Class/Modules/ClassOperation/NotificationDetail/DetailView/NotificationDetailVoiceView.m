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
    UIView*             _sepLine;
}

@end

@implementation NotificationDetailVoiceView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _voiceViewArray = [NSMutableArray arrayWithCapacity:0];
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(10, self.height - kLineHeight, self.width - 10 * 2, kLineHeight)];
        [_sepLine setBackgroundColor:kSepLineColor];
        [_sepLine setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
        [self addSubview:_sepLine];
    }
    return self;
}

- (void)setSendEntity:(NotificationSendEntity *)sendEntity{
    _sendEntity = sendEntity;
    [_voiceViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_voiceViewArray removeAllObjects];
    if(_sendEntity.voiceArray.count == 0){
        [self setHeight:0];
    }
    else{
        CGFloat maxWidth = self.width - 10 * 2;
        CGFloat spaceXStart = 10;
        CGFloat spaceYStart = 10;
        for (NSInteger i = 0; i < _sendEntity.voiceArray.count; i++) {
            AudioItem *item = _sendEntity.voiceArray[i];
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
