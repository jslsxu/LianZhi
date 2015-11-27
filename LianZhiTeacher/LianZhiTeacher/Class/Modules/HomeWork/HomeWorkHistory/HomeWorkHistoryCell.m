//
//  HomeWorkHistoryCell.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/31.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "HomeWorkHistoryCell.h"

@implementation HomeWorkHistoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_shareButton setTitle:@"转发" forState:UIControlStateNormal];
        [_shareButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_shareButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"5ed015"] size:CGSizeMake(20, 20) cornerRadius:10] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(onShareButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_shareButton];
    }
    return self;
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width
{
    HomeWorkItem *homeWorkItem = (HomeWorkItem *)modelItem;
    NSInteger height = 15;
    if(homeWorkItem.content.length > 0)
    {
        CGSize contentSize = [homeWorkItem.content boundingRectWithSize:CGSizeMake(width - 16 * 2, CGFLOAT_MAX) andFont:[UIFont systemFontOfSize:12]];
        height += contentSize.height + 10;
    }
    
    if(homeWorkItem.photos.count > 0)
        height += 100 + 10;
    else if(homeWorkItem.audioItem)
        height += 34 + 10;
    height += 5;
    return @(height);
}

- (void)onReloadData:(TNModelItem *)modelItem
{
    HomeWorkItem *homeWorkItem = (HomeWorkItem *)modelItem;
}

- (void)onShareButtonClicked
{
    if([self.delegate respondsToSelector:@selector(homeWorkCellDidShare:)])
        [self.delegate homeWorkCellDidShare:self];
}


@end
