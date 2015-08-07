//
//  TreeHouseHeaderView.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/22.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TreeHouseHeaderView.h"

#define kTreeHouseHeaderHeight                  170
#define kExtraInfoHeight                        36

@implementation TreeHouseHeaderView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    {
        self.height = kTreeHouseHeaderHeight;
        _bannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height - kExtraInfoHeight)];
        [_bannerImageView setImage:[UIImage imageNamed:@"TreeHouseBanner.png"]];
        [_bannerImageView setClipsToBounds:YES];
        [_bannerImageView setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:_bannerImageView];
        
        _avatar = [[AvatarView alloc] initWithRadius:36];
        [_avatar setBorderWidth:3];
        [_avatar setBorderColor:[UIColor colorWithWhite:0 alpha:0.2]];
        [_avatar setCenter:CGPointMake(50, _bannerImageView.bottom)];
        [self addSubview:_avatar];
        
        NSString *title = @"相册";
        _albumButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_albumButton setTitle:title forState:UIControlStateNormal];
        [_albumButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        [_albumButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_albumButton setImage:[UIImage imageNamed:@"TreeHouseArrow.png"] forState:UIControlStateNormal];
        CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
        CGFloat buttonWidth = titleSize.width + 10 * 2 + 15;
        [_albumButton setImageEdgeInsets:UIEdgeInsetsMake(0, buttonWidth - 10 - 15, 0, 10 - titleSize.width)];
        CGFloat titleRightInset = buttonWidth - 10 - titleSize.width;
        if (titleRightInset < 10 + 15)
            titleRightInset = 10 + 15;

        [_albumButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10 - 15, 0, titleRightInset)];
        [_albumButton addTarget:self action:@selector(onAlbumClicked) forControlEvents:UIControlEventTouchUpInside];
        [_albumButton setFrame:CGRectMake(self.width - buttonWidth, self.height - 30, buttonWidth, 25)];
        [self addSubview:_albumButton];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatar.right + 5, _bannerImageView.bottom , _albumButton.left - 5 - (_avatar.right + 5), self.height - (_bannerImageView.bottom ))];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_titleLabel];
    
        [self setupHeaderView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onChildInfoChanged) name:kChildInfoChangedNotification object:nil];
    }
    return self;
}

- (void)setupHeaderView
{
    [_avatar setImageWithUrl:[NSURL URLWithString:[UserCenter sharedInstance].curChild.avatar]];
    NSString *nickName = [UserCenter sharedInstance].curChild.name;
    NSString *title = [NSString stringWithFormat:@"%@ 的成长旅记",nickName];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:title];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"666666"] range:NSMakeRange(0, nickName.length)];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"999999"] range:NSMakeRange(nickName.length, title.length - nickName.length)];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, nickName.length)];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(nickName.length, title.length - nickName.length)];
    [_titleLabel setAttributedText:attributedStr];
    
}

- (void)onAlbumClicked
{
    TreeHouseAlbumVC *flowVC = [[TreeHouseAlbumVC alloc] init];
    
    [CurrentROOTNavigationVC pushViewController:flowVC animated:YES];
}

- (void)onChildInfoChanged
{
    [_avatar setImageWithUrl:[NSURL URLWithString:[UserCenter sharedInstance].curChild.avatar]];
}
@end
