//
//  MessageGroupListModel.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/23.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "MessageGroupListModel.h"

#define kAlertSettingList           @"AlertSettingList"

@implementation MessageFromInfo
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.uid = [dataWrapper getStringForKey:@"id"];
    self.logoUrl = [dataWrapper getStringForKey:@"logo"];
    self.name = [dataWrapper getStringForKey:@"name"];
    self.type = [dataWrapper getIntegerForKey:@"type"];
    self.label = [dataWrapper getStringForKey:@"label"];
}
@end

@implementation MessageGroupItem
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    MessageFromInfo *fromInfo = [[MessageFromInfo alloc] init];
    TNDataWrapper *fromInfoWrapper = [dataWrapper getDataWrapperForKey:@"from"];
    [fromInfo parseData:fromInfoWrapper];
    [self setFromInfo:fromInfo];
    
    self.formatTime = [dataWrapper getStringForKey:@"time_str"];
    self.content = [dataWrapper getStringForKey:@"words"];
    self.msgNum = [dataWrapper getIntegerForKey:@"unread"];
    TNDataWrapper *voiceWrapper = [dataWrapper getDataWrapperForKey:@"voice"];
    if(voiceWrapper.count > 0)
    {
        AudioItem *audioItem = [[AudioItem alloc] init];
        [audioItem parseData:voiceWrapper];
        [self setAudioItem:audioItem];
        self.content = @"发来一条语音通知，点击收听";
    }
//    self.soundOn = ![[DataCenter sharedInstance] checkFromIDSilence:self.fromInfo.uid];
    NSString *sound = [dataWrapper getStringForKey:@"sound"];
    self.soundOn = ([sound isEqualToString:@"open"]);
    
}
@end

@implementation MessageGroupListModel

- (BOOL)hasMoreData
{
    return YES;
}

- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type
{
    BOOL parse = [super parseData:data type:type];
    
    if(type == REQUEST_REFRESH)
        [self.modelItemArray removeAllObjects];
    TNDataWrapper *listWrapper = [data getDataWrapperForKey:@"list"];
    if(listWrapper.count > 0)
    {
        BOOL hasNew = NO;//是否有新消息
        for (NSInteger i = 0; i < listWrapper.count; i++) {
            MessageGroupItem *item = [[MessageGroupItem alloc] init];
            TNDataWrapper *itemWrapper = [listWrapper getDataWrapperForIndex:i];
            [item parseData:itemWrapper];
            [self.modelItemArray addObject:item];
            
            if(item.msgNum > 0 && item.soundOn)
                hasNew = YES;
        }
//        if(hasNew)
//        {
//            //有新消息，播放声音
//            if([UserCenter sharedInstance].personalSetting.soundOn)
//                [ApplicationDelegate playSound];
//            if([UserCenter sharedInstance].personalSetting.shakeOn)
//                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//        }
    }
    
    return parse;
}
@end
