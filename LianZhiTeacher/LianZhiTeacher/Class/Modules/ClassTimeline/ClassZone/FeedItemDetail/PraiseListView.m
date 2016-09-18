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
        
        _extraLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_extraLabel setFont:[UIFont systemFontOfSize:13]];
        [_extraLabel setTextAlignment:NSTextAlignmentCenter];
        [_extraLabel setTextColor:[UIColor colorWithHexString:@"0fabc1"]];
        [_extraLabel setText:@"点了赞"];
        [_extraLabel sizeToFit];
        [_extraLabel setSize:CGSizeMake(_extraLabel.width + 10, 22)];
        [_extraLabel setHidden:YES];
        [self addSubview:_extraLabel];
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
//    NSInteger maxRowNum = (count + maxColumnNum - 1) / maxColumnNum;
    NSInteger row = 0;
    NSInteger column = 0;
    for (NSInteger i = 0; i < count; i++)
    {
        UserInfo *userInfo = _praiseArray[i];
        row = i / maxColumnNum;
        column = i % maxColumnNum;
        AvatarView *avatarView = [[AvatarView alloc] initWithFrame:CGRectMake(spaceXStart + (itemWidth + innerMargin) * column, spaceYStart + (itemWidth + innerMargin) * row, 22, 22)];
        [avatarView sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar]];
        [self addSubview:avatarView];
        [_avatarArray addObject:avatarView];
    }
    if(count > 0)
    {
        _extraLabel.hidden = NO;
        AvatarView *lastView = [_avatarArray lastObject];
        if(lastView.right + _extraLabel.width <= self.width - spaceXStart)
        {
            [_extraLabel setOrigin:CGPointMake(lastView.right, lastView.y)];
        }
        else
        {
            [_extraLabel setOrigin:CGPointMake(spaceXStart, lastView.bottom + innerMargin)];
        }
    }
    else
        _extraLabel.hidden = YES;
    
    if(count > 0)
    {
        [self setHeight:spaceYStart + _extraLabel.bottom];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 0, self.height - 10);
        CGPathAddLineToPoint(path, NULL, 0, 10);
        CGPathAddArcToPoint(path, NULL, 0, 0, 10, 0, 10);
        CGPathAddLineToPoint(path, NULL, self.width - 10, 0);
        CGPathAddArcToPoint(path, NULL, self.width, 0, self.width, 10, 10);
        if(self.isSingle)
        {
            CGPathAddLineToPoint(path, NULL, self.width, self.height - 10);
            CGPathAddArcToPoint(path, NULL, self.width, self.height, self.width - 10, self.height, 10);
            CGPathAddLineToPoint(path, NULL, 10, self.height);
            CGPathAddArcToPoint(path, NULL, 0, self.height, 0, self.height - 10, 10);
        }
        else
        {
            CGPathAddLineToPoint(path, NULL, self.width, self.height);
            CGPathAddLineToPoint(path, NULL, 0, self.height);
            CGPathAddLineToPoint(path, NULL, 0, self.height - 10);
        }
        CGPathCloseSubpath(path);
        [shapeLayer setPath:path];
        CFRelease(path);
        self.layer.mask = shapeLayer;
        [self.layer setMasksToBounds:YES];
    }
    else
        [self setHeight:0];
}

@end

