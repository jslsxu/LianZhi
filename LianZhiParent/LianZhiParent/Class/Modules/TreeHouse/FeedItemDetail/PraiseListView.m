//
//  PraiseListView.m
//  LianZhiParent
//
//  Created by jslsxu on 15/10/2.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "PraiseListView.h"
@implementation PraiseListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setBackgroundColor:[UIColor colorWithHexString:@"F0F0F0"]];
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DetailPraiseIcon"]];
        [_imageView setOrigin:CGPointMake(6, 10)];
        [self addSubview:_imageView];
        
        _avatarArray = [NSMutableArray array];
    }
    return self;
}

- (void)setPraiseArray:(NSArray *)praiseArray
{
    _praiseArray = praiseArray;
    [_avatarArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_avatarArray removeAllObjects];
    NSInteger count = _praiseArray.count;
    NSInteger spaceXStart = 30;
    NSInteger spaceYStart = 6;
    NSInteger itemWidth = 22;
    NSInteger innerMargin = 4;
    NSInteger maxColumnNum = (self.width - spaceXStart ) / (itemWidth + innerMargin);
    NSInteger maxRowNum = (count + maxColumnNum - 1) / maxColumnNum;
    for (NSInteger i = 0; i < count; i++)
    {
        UserInfo *userInfo = _praiseArray[i];
        NSInteger row = i / maxColumnNum;
        NSInteger column = i % maxColumnNum;
        AvatarView *avatarView = [[AvatarView alloc] initWithFrame:CGRectMake(spaceXStart + (itemWidth + innerMargin) * column, spaceYStart + (itemWidth + innerMargin) * row, 22, 22)];
        [avatarView setImageWithUrl:[NSURL URLWithString:userInfo.avatar]];
        [self addSubview:avatarView];
        [_avatarArray addObject:avatarView];
    }
    if(count > 0)
        [self setHeight:spaceYStart * 2 + itemWidth * maxRowNum + innerMargin * (maxRowNum - 1)];
    else
        [self setHeight:0];
}

@end
