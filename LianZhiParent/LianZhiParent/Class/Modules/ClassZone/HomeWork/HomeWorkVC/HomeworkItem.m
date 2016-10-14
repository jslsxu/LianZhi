//
//  HomeworkItem.m
//  LianZhiParent
//
//  Created by qingxu zhou on 16/10/10.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkItem.h"

@implementation HomeworkExplain


@end

@implementation HomeworkItem
- (instancetype)init{
    self = [super init];
    if(self){
        self.user = [UserCenter sharedInstance].userInfo;
        self.words = @"此处“...”，因为目前三个点里面的内容只有删除，所以这篇作业达到删除条件，才有三个点，里面的菜单只有删除。并且删除需要提醒用户“是否删除该作业”，选项为删除（红字）和取消。注意：删除后，对应的作业练习和作业通知也要删除。";
        self.create_time = @"10-14 12:23";
        self.end_time = @"10-15 12:00";
        self.course = @"语文";
        
        PhotoItem *photoItem = [[PhotoItem alloc] init];
        [photoItem setBig:@"http://img4.imgtn.bdimg.com/it/u=1215299968,4212700726&fm=21&gp=0.jpg"];
        [photoItem setWidth:244];
        [photoItem setHeight:220];
        self.pictures = @[photoItem];
        
        AudioItem *audioItem = [[AudioItem alloc] init];
        [audioItem setAudioUrl:@"http://img4.imgtn.bdimg.com/it/u=1215299968,4212700726&fm=21&gp=0.jpg"];
        [audioItem setTimeSpan:23];
        self.voice = audioItem;
        
        HomeworkExplain *explain = [[HomeworkExplain alloc] init];
        self.explain = explain;
    }
    return self;
}
- (BOOL)hasAudio{
    return self.voice.audioUrl.length > 0;
}

- (BOOL)hasPhoto{
    return self.pictures.count > 0;
}

- (BOOL)hasVideo{
    return self.video.videoUrl.length > 0;
}
@end
