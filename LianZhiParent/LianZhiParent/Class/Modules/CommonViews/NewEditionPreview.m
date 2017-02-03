//
//  NewEditionPreview.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/3/1.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "NewEditionPreview.h"

#define kMargin         18

@implementation NewEditionPreview

- (instancetype)initWithVersion:(NSString *)version notes:(NSString *)relaseNotes
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self)
    {
        _bgView = [[UIView alloc] initWithFrame:self.bounds];
        [_bgView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];
        [self addSubview:_bgView];
        
        UIImageView *mailImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ReleaseNoteBG"]];
        [mailImageView setCenter:CGPointMake(self.width / 2, self.height / 2)];
        [mailImageView setUserInteractionEnabled:YES];
        [self addSubview:mailImageView];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(30, 10, mailImageView.width - 30 * 2, 200)];
        [mailImageView addSubview:_scrollView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _scrollView.width, 25)];
        [titleLabel setFont:[UIFont systemFontOfSize:18]];
        [titleLabel setTextColor:[UIColor colorWithHexString:@"02c994"]];
        [titleLabel setText:[NSString stringWithFormat:@"连枝升级啦(v%@)",version]];
        [_scrollView addSubview:titleLabel];
        
        UILabel *notesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, titleLabel.bottom + 10, _scrollView.width, 0)];
        [notesLabel setNumberOfLines:0];
        [notesLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [notesLabel setFont:[UIFont systemFontOfSize:14]];
        [notesLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [notesLabel setText:relaseNotes];
        
        CGSize notesSize = [relaseNotes boundingRectWithSize:CGSizeMake(notesLabel.width, CGFLOAT_MAX) andFont:notesLabel.font];
        [notesLabel setHeight:notesSize.height];
        [_scrollView addSubview:notesLabel];
        
        UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, notesLabel.bottom + 30, _scrollView.width, 30)];
        [hintLabel setTextAlignment:NSTextAlignmentCenter];
        [hintLabel setText:@"建议在wifi下升级"];
        [hintLabel setFont:[UIFont systemFontOfSize:14]];
        [hintLabel setTextColor:[UIColor colorWithHexString:@"9a9a9a"]];
        [_scrollView addSubview:hintLabel];
        
        [_scrollView setContentSize:CGSizeMake(_scrollView.width, hintLabel.bottom + 20)];
        
        UIButton *updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [updateButton setFrame:CGRectMake((mailImageView.width - 50) / 2, 250 - 25, 50, 50)];
        [updateButton setImage:[UIImage imageNamed:@"UpdateButton"] forState:UIControlStateNormal];
        [updateButton addTarget:self action:@selector(onUpdateButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [mailImageView addSubview:updateButton];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setFrame:CGRectMake(100, 300, mailImageView.width - 100 * 2, 30)];
        [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [cancelButton setTitleColor:[UIColor colorWithHexString:@"2c2c2c"] forState:UIControlStateNormal];
        [cancelButton setTitle:@"以后再说" forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [mailImageView addSubview:cancelButton];
    }
    return self;
}

- (void)onUpdateButtonClicked
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kParentClientAppStoreUrl]];
}

- (void)show
{
    UIView *viewParent = [UIApplication sharedApplication].keyWindow;
    [viewParent addSubview:self];
    self.alpha = 0.f;
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.f;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
