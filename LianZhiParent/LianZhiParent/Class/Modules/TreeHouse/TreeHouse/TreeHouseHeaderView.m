//
//  TreeHouseHeaderView.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/22.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TreeHouseHeaderView.h"
#import "NewMessageVC.h"
#define kTreeHouseHeaderHeight                  130
#define kExtraInfoHeight                        36

@implementation NewMessageIndicator
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setBackgroundColor:[UIColor colorWithHexString:@"3e3e3e"]];
        [self.layer setCornerRadius:3];
        [self.layer setMasksToBounds:YES];
        
        
        _avatarView = [[AvatarView alloc] initWithFrame:CGRectMake(5, (self.height - 20) / 2, 20, 20)];
        [_avatarView sd_setImageWithURL:[NSURL URLWithString:[UserCenter sharedInstance].userInfo.avatar]];
        [self addSubview:_avatarView];
        
        _indicatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarView.right + 15, 0, self.width - 10 - (_avatarView.right + 5), self.height)];
        [_indicatorLabel setTextColor:[UIColor whiteColor]];
        [_indicatorLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_indicatorLabel];
        
        _coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_coverButton addTarget:self action:@selector(onNewMessageClicked) forControlEvents:UIControlEventTouchUpInside];
        [_coverButton setFrame:self.bounds];
        [self addSubview:_coverButton];
    }
    return self;
}

- (void)setCommentItem:(TimelineCommentItem *)commentItem
{
    _commentItem = commentItem;
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:_commentItem.alertInfo.avatar]];
    [_indicatorLabel setText:[NSString stringWithFormat:@"%ld条新消息",(long)_commentItem.alertInfo.num]];
}

- (void)onNewMessageClicked
{
    if(self.clickAction)
        self.clickAction();
}

@end

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
        _bannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, 100)];
        [_bannerImageView setImage:[UIImage imageNamed:@"TreeHouseBanner"]];
        [_bannerImageView setClipsToBounds:YES];
        [_bannerImageView setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:_bannerImageView];
        
        UIView* nameView = [[UIView alloc] initWithFrame:CGRectMake(0, _bannerImageView.bottom - 24, _bannerImageView.width, 24)];
        [nameView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.2]];
        [self addSubview:nameView];
        
        _avatar = [[AvatarView alloc] initWithRadius:36];
        [_avatar.layer setBorderWidth:3];
        [_avatar.layer setBorderColor:[UIColor whiteColor].CGColor];
        [_avatar.layer setMasksToBounds:YES];
        [_avatar setCenter:CGPointMake(50, _bannerImageView.bottom - 30)];
        [self addSubview:_avatar];
        
        NSString *title = @"相册";
        _albumButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_albumButton setTitle:title forState:UIControlStateNormal];
        [_albumButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_albumButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_albumButton setBackgroundImage:[[UIImage imageNamed:@"TreeHouseAlbum"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 15, 10, 15)] forState:UIControlStateNormal];
        [_albumButton addTarget:self action:@selector(onAlbumClicked) forControlEvents:UIControlEventTouchUpInside];
        [_albumButton setFrame:CGRectMake(nameView.width - 45 - 15, (nameView.height - 20) / 2, 45, 20)];
        [nameView addSubview:_albumButton];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 0 , _albumButton.x - 10 - 90, nameView.height)];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [nameView addSubview:_titleLabel];
    
        [self setupHeaderView];
        
        __weak typeof(self) wself = self;
        _msgIndicator = [[NewMessageIndicator alloc] initWithFrame:CGRectMake((self.width - 140) / 2, nameView.bottom + 12, 140, 30)];
        [_msgIndicator setClickAction:^{
            [wself onNewMessageClicked];
        }];
        [self addSubview:_msgIndicator];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onChildInfoChanged) name:kChildInfoChangedNotification object:nil];
    }
    return self;
}

- (void)setCommentItem:(TimelineCommentItem *)commentItem
{
    _commentItem = commentItem;
    BOOL hide = _commentItem == nil || _commentItem.alertInfo.num == 0;
    [_msgIndicator setHidden:hide];
    if(!hide)
    {
        [self setHeight:100 + 54];
    }
    else
    {
        [self setHeight:100 + 30];
    }
    if(!hide)
        [_msgIndicator setCommentItem:_commentItem];
}

- (void)setupHeaderView
{
    [_avatar sd_setImageWithURL:[NSURL URLWithString:[UserCenter sharedInstance].curChild.avatar]];
    NSString *nickName = [UserCenter sharedInstance].curChild.name;
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:nickName attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18]}];
    [title appendAttributedString:[[NSAttributedString alloc] initWithString:@"的成长秀" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]}]];
    [_titleLabel setAttributedText:title];
}

- (void)onNewMessageClicked
{

    NewMessageVC *newMessageVC = [[NewMessageVC alloc] init];
    [newMessageVC setTypes:NewMessageTypeTreeHouse];
    [newMessageVC setObjid:[UserCenter sharedInstance].curChild.uid];
    [CurrentROOTNavigationVC pushViewController:newMessageVC animated:YES];
}

- (void)onAlbumClicked
{
    TreeHouseAlbumVC *flowVC = [[TreeHouseAlbumVC alloc] init];
    
    [CurrentROOTNavigationVC pushViewController:flowVC animated:YES];
}

- (void)onChildInfoChanged
{
    [_avatar sd_setImageWithURL:[NSURL URLWithString:[UserCenter sharedInstance].curChild.avatar]];
}
@end
