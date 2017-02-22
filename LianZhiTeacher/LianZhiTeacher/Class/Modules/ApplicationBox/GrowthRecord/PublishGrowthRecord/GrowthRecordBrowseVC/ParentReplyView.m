//
//  ParentReplyView.m
//  LianZhiTeacher
//
//  Created by jslsxu on 17/2/21.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import "ParentReplyView.h"

@interface ParentReplyView ()
@property (nonatomic, strong)NotificationDetailVoiceView*   voiceView;
@property (nonatomic, strong)NotificationDetailPhotoView*   photoView;
@end

@implementation ParentReplyView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        CGFloat spaceYStart = 0;
        UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, spaceYStart, self.width, 35)];
        [headerView setBackgroundColor:[UIColor colorWithHexString:@"cccccc"]];
        
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [titleLabel setText:@"家长回复"];
        [titleLabel setFont:[UIFont systemFontOfSize:14]];
        [titleLabel setTextColor:kColor_66];
        [titleLabel sizeToFit];
        [titleLabel setOrigin:CGPointMake(10, (headerView.height - titleLabel.height) / 2)];
        [headerView addSubview:titleLabel];
        
        UIButton* contactButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [contactButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [contactButton setTitle:@"与家长沟通" forState:UIControlStateNormal];
        [contactButton setTitleColor:kColor_66 forState:UIControlStateNormal];
        [contactButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        [contactButton addTarget:self action:@selector(contactParent) forControlEvents:UIControlEventTouchUpInside];
        [contactButton sizeToFit];
        [contactButton setOrigin:CGPointMake(headerView.width - contactButton.width - 10, (headerView.height - contactButton.height) / 2)];
        [headerView addSubview:contactButton];
        
        [self addSubview:headerView];
        
        spaceYStart = headerView.bottom;
        
        [self addSubview:[self voiceView]];
        [self.voiceView setY:spaceYStart];
        spaceYStart = self.voiceView.bottom;
        
        [self addSubview:[self photoView]];
        [self.photoView setY:spaceYStart];
        spaceYStart = self.photoView.bottom;
        
        [self setHeight:spaceYStart + 10];
    }
    return self;
}

- (NotificationDetailPhotoView *)photoView{
    if(nil == _photoView){
        _photoView = [[NotificationDetailPhotoView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0)];
        PhotoItem *photoItem = [[PhotoItem alloc] init];
        [_photoView setPhotoArray:@[photoItem]];
    }
    return _photoView;
}

- (NotificationDetailVoiceView *)voiceView{
    if(nil == _voiceView){
        _voiceView = [[NotificationDetailVoiceView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0)];
        AudioItem *audioItem = [[AudioItem alloc] init];
        [audioItem setTimeSpan:10];
        [_voiceView setVoiceArray:@[audioItem]];
    }
    return _voiceView;
}

- (void)contactParent{
    
}

@end
