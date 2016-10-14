//
//  HomeworkResultView.m
//  LianZhiParent
//
//  Created by qingxu zhou on 16/10/14.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkResultView.h"

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

- (void)setupSubviews{
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSInteger margin = 10;
    AvatarView* avatarView = [[AvatarView alloc] initWithRadius:25];
    [avatarView sd_setImageWithURL:[NSURL URLWithString:@"http://img4.imgtn.bdimg.com/it/u=1215299968,4212700726&fm=21&gp=0.jpg"]];
    [avatarView setOrigin:CGPointMake(margin, margin)];
    [_scrollView addSubview:avatarView];
    
    UILabel* nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [nameLabel setFont:[UIFont systemFontOfSize:14]];
    [nameLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
    [nameLabel setText:@"撑起"];
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
    [commitTimeLabel setText:@"提交时间"];
    [commitTimeLabel sizeToFit];
    [commitTimeLabel setOrigin:CGPointMake(avatarView.right + margin, avatarView.bottom - commitTimeLabel.height)];
    [_scrollView addSubview:commitTimeLabel];
    
    UILabel* commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, avatarView.bottom + margin, _scrollView.width - margin * 2, 0)];
    [commentLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
    [commentLabel setFont:[UIFont systemFontOfSize:14]];
    [commentLabel setNumberOfLines:0];
    [commentLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [commentLabel setText:@"评语：作业完成一般，望继续努力，加强巩固所学知识"];
    [commentLabel sizeToFit];
    [_scrollView addSubview:commentLabel];
    
    NSInteger spaceYStart = commitTimeLabel.bottom + margin;
    for (NSInteger i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(margin, spaceYStart, _scrollView.width - margin * 2, 300)];
        [imageView setBackgroundColor:[UIColor colorWithHexString:@"eeeeee"]];
        [imageView sd_setImageWithURL:[NSURL URLWithString:@"http://d.hiphotos.baidu.com/image/h%3D200/sign=9ce0501e0246f21fd6345953c6256b31/00e93901213fb80e30c67f323ed12f2eb938943b.jpg"]];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [imageView setClipsToBounds:YES];
        [_scrollView addSubview:imageView];
        spaceYStart = imageView.bottom + margin;
    }
    [_scrollView setContentSize:CGSizeMake(_scrollView.width, spaceYStart)];
}
@end
