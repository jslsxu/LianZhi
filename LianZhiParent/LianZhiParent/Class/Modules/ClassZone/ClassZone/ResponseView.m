//
//  ResponseView.m
//  LianZhiParent
//
//  Created by jslsxu on 15/8/22.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ResponseView.h"

@implementation CommentCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        
    }
    return self;
}

@end

@implementation ResponseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setBackgroundColor:[UIColor colorWithHexString:@"DDDDDD"]];
        [self.layer setCornerRadius:10];
        [self.layer setMasksToBounds:YES];
        
        _praiseImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        [self addSubview:_praiseImageView];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, kLineHeight)];
        [_sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:_sepLine];
        
    }
    return self;
}
@end
