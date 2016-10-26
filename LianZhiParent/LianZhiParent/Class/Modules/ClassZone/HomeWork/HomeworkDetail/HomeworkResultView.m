//
//  HomeworkResultView.m
//  LianZhiParent
//
//  Created by qingxu zhou on 16/10/14.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkResultView.h"
#import "HomeworkPhotoImageView.h"
@interface HomeworkResultView ()

@end

@implementation HomeworkResultView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setBackgroundColor:[UIColor whiteColor]];
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [_scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setAlwaysBounceVertical:YES];
        [self addSubview:_scrollView];
        
        [self setupSubviews];
    }
    return self;
}

- (void)setHomeworkItem:(HomeworkItem *)homeworkItem{
    _homeworkItem = homeworkItem;
    [self setupSubviews];
}

- (void)setupSubviews{
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSInteger margin = 10;
    AvatarView* avatarView = [[AvatarView alloc] initWithRadius:25];
    [avatarView sd_setImageWithURL:[NSURL URLWithString:[UserCenter sharedInstance].curChild.avatar]];
    [avatarView setOrigin:CGPointMake(margin, margin)];
    [_scrollView addSubview:avatarView];
    
    UILabel* nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [nameLabel setFont:[UIFont systemFontOfSize:14]];
    [nameLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
    [nameLabel setText:[UserCenter sharedInstance].curChild.name];
    [nameLabel sizeToFit];
    [nameLabel setOrigin:CGPointMake(avatarView.right + margin, avatarView.top)];
    [_scrollView addSubview:nameLabel];
    
    UILabel* rateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [rateLabel setFont:[UIFont systemFontOfSize:12]];
    [rateLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
    [rateLabel setText:@"正确率:"];
    [rateLabel sizeToFit];
    [rateLabel setOrigin:CGPointMake(avatarView.right + margin, (avatarView.height - rateLabel.height) / 2 + margin)];
    [_scrollView addSubview:rateLabel];
    
    UILabel* commitTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [commitTimeLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
    [commitTimeLabel setFont:[UIFont systemFontOfSize:12]];
    [commitTimeLabel setText:[NSString stringWithFormat:@"提交时间: %@",[self.homeworkItem.s_answer ctime]]];
    [commitTimeLabel sizeToFit];
    [commitTimeLabel setOrigin:CGPointMake(avatarView.right + margin, avatarView.bottom - commitTimeLabel.height)];
    [_scrollView addSubview:commitTimeLabel];
    
    UILabel* commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, avatarView.bottom + margin, _scrollView.width - margin * 2, 0)];
    [commentLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
    [commentLabel setFont:[UIFont systemFontOfSize:14]];
    [commentLabel setNumberOfLines:0];
    [commentLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [commentLabel setText:[NSString stringWithFormat:@"评语：%@", self.homeworkItem.s_answer.teacherMark.comment]];
    [commentLabel sizeToFit];
    [_scrollView addSubview:commentLabel];
    
     NSInteger spaceYStart = commitTimeLabel.bottom + margin;
    if([self.homeworkItem.s_answer.pics count] > 0){
        NSArray* marks = self.homeworkItem.s_answer.teacherMark.marks;
        for (NSInteger i = 0; i < [self.homeworkItem.s_answer.pics count]; i++) {
            PhotoItem *photoItem = self.homeworkItem.s_answer.pics[i];
            CGFloat width = _scrollView.width - margin * 2;
            CGFloat height = width * photoItem.height / photoItem.width;
            CGRect frame = CGRectMake(margin, spaceYStart, width, height);
            if([marks count] > 0){
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
                [imageView setBackgroundColor:[UIColor colorWithHexString:@"eeeeee"]];
                [imageView sd_setImageWithURL:[NSURL URLWithString:photoItem.big]];
                [imageView setContentMode:UIViewContentModeScaleAspectFill];
                [imageView setClipsToBounds:YES];
                [_scrollView addSubview:imageView];
                spaceYStart = imageView.bottom + margin;
            }
            else{
                HomeworkPhotoImageView *imageView = [[HomeworkPhotoImageView alloc] initWithFrame:frame];
                [imageView setMarkItem:marks[i]];
                [_scrollView addSubview:imageView];
                spaceYStart = imageView.bottom + margin;
            }
    
        }
    }
    [_scrollView setContentSize:CGSizeMake(_scrollView.width, spaceYStart)];
}
@end
