//
//  SVGetMoreCell.m
//  SViPad
//
//  Created by jslsxu on 14-3-26.
//  Copyright (c) 2014年 sohu-inc. All rights reserved.
//

#import "TNGetMoreCell.h"

@implementation TNGetMoreCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_indicatorView setCenter:CGPointMake(60, 25)];
        [_indicatorView setHidesWhenStopped:YES];
        [self addSubview:_indicatorView];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,44)];
		[_textLabel setBackgroundColor:[UIColor clearColor]];
		[_textLabel setTextColor:[UIColor colorWithRed:0xC0 / 255.0 green:0xC0 / 255.0 blue:0xC0 / 255.0 alpha:1.f]];
        _textLabel.font = [UIFont systemFontOfSize:14];
        [_textLabel setText:@"上拉加载更多"];
		[self addSubview:_textLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = [self bounds];
    [_textLabel sizeToFit];
    
    [_textLabel setFrame:CGRectMake((frame.size.width - _textLabel.width) / 2, 0,_textLabel.width, 44)];
}


- (void)startLoading
{
    [_indicatorView startAnimating];
    _textLabel.text = @"正在加载数据";
}

- (void)stopLoading
{
    [_indicatorView stopAnimating];
    _textLabel.text = @"上拉加载更多";
    
    [_textLabel sizeToFit];
    CGFloat spaceXStart = (self.frame.size.width - _textLabel.width)/ 2;
    
    [_textLabel setFrame:CGRectMake(spaceXStart, 0, _textLabel.width, 44)];
}

- (BOOL)isLoading
{
    return [_indicatorView isAnimating];
}



@end
