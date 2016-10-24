//
//  HomeworkDetailView.m
//  LianZhiParent
//
//  Created by qingxu zhou on 16/10/13.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkDetailView.h"
#import "NotificationDetailVoiceView.h"
#import "HomeworkItemAnswerView.h"
@interface HomeworkDetailView ()
//@property (nonatomic, strong)AvatarView*    avatarView;
//@property (nonatomic, strong)UILabel*       nameLabel;
//@property (nonatomic, strong)UILabel*       courseLabel;
//@property (nonatomic, strong)UILabel*       publishTimeLabel;
//@property (nonatomic, strong)UILabel*       endTimeLabel;
//@property (nonatomic, strong)UILabel*       contentLabel;
@property (nonatomic, strong)HomeworkItemAnswerView*   explainView;
@end

@implementation HomeworkDetailView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setBackgroundColor:[UIColor whiteColor]];
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [_scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setAlwaysBounceVertical:YES];
        [self addSubview:_scrollView];
    }
    return self;
}

- (void)setHomeworkItem:(HomeworkItem *)homeworkItem{
    _homeworkItem = homeworkItem;
    [self setupScrollView];
}

- (void)setupScrollView{
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if(self.homeworkItem){
        NSInteger margin = 10;
        NSInteger spaceYStart = 0;
        AvatarView* avatarView = [[AvatarView alloc] initWithRadius:20];
        [avatarView setOrigin:CGPointMake(margin, margin)];
        [avatarView sd_setImageWithURL:[NSURL URLWithString:self.homeworkItem.user.avatar] placeholderImage:nil];
        [_scrollView addSubview:avatarView];
        
        UILabel*    nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [nameLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
        [nameLabel setFont:[UIFont systemFontOfSize:14]];
        [nameLabel setText:self.homeworkItem.user.name];
        [nameLabel sizeToFit];
        [nameLabel setOrigin:CGPointMake(avatarView.right + margin, avatarView.top)];
        [_scrollView addSubview:nameLabel];
        
        UILabel*    courseLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [courseLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [courseLabel setFont:[UIFont systemFontOfSize:13]];
        [courseLabel setText:self.homeworkItem.course];
        [courseLabel sizeToFit];
        [courseLabel setOrigin:CGPointMake(avatarView.right + margin, avatarView.bottom - courseLabel.height)];
        [_scrollView addSubview:courseLabel];
        
        UILabel*    publishTimelabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [publishTimelabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [publishTimelabel setFont:[UIFont systemFontOfSize:13]];
        [publishTimelabel setText:[NSString stringWithFormat:@"发布时间:%@",self.homeworkItem.create_time]];
        [publishTimelabel sizeToFit];
        [publishTimelabel setOrigin:CGPointMake(_scrollView.width - margin - publishTimelabel.width, avatarView.top + 2)];
        [_scrollView addSubview:publishTimelabel];
        
        
        if(self.homeworkItem.end_time.length > 0){
            UILabel*    endTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [endTimeLabel setTextColor:kCommonParentTintColor];
            [endTimeLabel setFont:[UIFont systemFontOfSize:13]];
            [endTimeLabel setText:[NSString stringWithFormat:@"截止时间:%@",self.homeworkItem.end_time]];
            [endTimeLabel sizeToFit];
            [endTimeLabel setOrigin:CGPointMake(_scrollView.width - margin - endTimeLabel.width, avatarView.bottom - endTimeLabel.height - 2)];
            [_scrollView addSubview:endTimeLabel];
        }
        
        spaceYStart = avatarView.bottom + margin;
        
        if([self.homeworkItem hasAudio]){
            AudioContentView*   audioContentView = [[AudioContentView alloc] initWithMaxWidth:_scrollView.width - margin * 2];
            [audioContentView setAudioItem:self.homeworkItem.voice];
            [audioContentView setOrigin:CGPointMake(margin, spaceYStart)];
            [_scrollView addSubview:audioContentView];
            
            spaceYStart = audioContentView.bottom + margin;
        }
        
        if([self.homeworkItem hasPhoto]){
            for (NSInteger i = 0; i < [self.homeworkItem.pictures count]; i++) {
                NSInteger itemWidth = _scrollView.width - margin * 2;
                PhotoItem *photoItem = [self.homeworkItem.pictures objectAtIndex:i];
                NSInteger itemHeight = itemWidth;
                if(photoItem.width != 0 && photoItem.height != 0){
                    itemHeight = itemWidth * photoItem.height / photoItem.width;
                }
                UIImageView*    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(margin, spaceYStart, itemWidth, itemHeight)];
                [imageView setBackgroundColor:[UIColor colorWithHexString:@"eeeeee"]];
                [imageView setContentMode:UIViewContentModeScaleAspectFill];
                [imageView setClipsToBounds:YES];
                [imageView sd_setImageWithURL:[NSURL URLWithString:photoItem.big] placeholderImage:nil];
                [_scrollView addSubview:imageView];
                
                spaceYStart = imageView.bottom;
            }
        }
        
        if(self.homeworkItem.answer){
            self.explainView = [[HomeworkItemAnswerView alloc] initWithFrame:CGRectMake(0, spaceYStart, _scrollView.width, 0)];
            [_scrollView addSubview:self.explainView];
            spaceYStart = self.explainView.bottom ;
        }
        
        [_scrollView setContentSize:CGSizeMake(self.width, spaceYStart)];
    }
}

@end
