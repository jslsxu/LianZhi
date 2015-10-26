//
//  HomeWorkCell.m
//  LianZhiParent
//
//  Created by jslsxu on 15/10/26.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "HomeWorkCell.h"
#import "HomeWorkListModel.h"
@implementation HomeWorkCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_contentLabel setFont:[UIFont systemFontOfSize:14]];
        [_contentLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self addSubview:_contentLabel];
        
        _photoView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_photoView];
    }
    return self;
}

- (void)onReloadData:(TNModelItem *)modelItem
{
    HomeWorkItem *homeWorkItem = (HomeWorkItem *)modelItem;
    [_contentLabel setText:homeWorkItem.content];
    [_contentLabel sizeToFit];
    
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width
{
    return @(50);
}
@end
