//
//  BGTableViewCell.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/23.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "BGTableViewCell.h"

@implementation BGTableViewCell
+(TableViewCellType)cellTypeForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    NSInteger rowNum = [tableView numberOfRowsInSection:section];
    if(rowNum == 1)
        return TableViewCellTypeSingle;
    else
    {
        if(row == 0)
            return TableViewCellTypeFirst;
        else if(row == rowNum - 1)
            return TableViewCellTypeLast;
        else
            return TableViewCellTypeMiddle;
    }
    
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)setCellType:(TableViewCellType)cellType
{
    _cellType = cellType;
    [self addBackgroundImage];
    [self addSelectedBackgroundImage];
}

- (UIImage *)BGImageForCellType:(TableViewCellType)cellType
{
    NSString *imageStr = nil;
    if(cellType == TableViewCellTypeFirst)
        imageStr = (@"CellBGFirst.png");
    else if(cellType == TableViewCellTypeMiddle)
        imageStr = (@"CellBGMiddle.png");
    else if(cellType == TableViewCellTypeLast)
        imageStr = (@"CellBGLast.png");
    else
        imageStr = (@"WhiteBG.png");
    return [[UIImage imageNamed:imageStr] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
}

- (UIImage *)highlightedBGImageForCellType:(TableViewCellType)cellType
{
    NSString *imageStr = nil;
    if(cellType == TableViewCellTypeFirst)
        imageStr = (@"GreenBG.png");
    else if(cellType == TableViewCellTypeMiddle)
        imageStr = @"Middle_Selected.png";
    else if(cellType == TableViewCellTypeLast)
        imageStr = @"Last_Selected.png";
    else
        imageStr = (@"GreenBG.png");
    return [[UIImage imageNamed:imageStr] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
}

- (void)addBackgroundImage
{
    CGFloat margin = 10;
    UIView *bgView = [[UIView alloc] initWithFrame:self.contentView.bounds];
    [bgView setBackgroundColor:[UIColor clearColor]];
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(margin, 0, bgView.width - margin * 2, bgView.height)];
    [bgImageView setImage:[self BGImageForCellType:self.cellType]];
    [bgView addSubview:bgImageView];
    self.backgroundView = bgView;
}

- (void)addSelectedBackgroundImage
{
    CGFloat margin = 10;
    UIView *bgView = [[UIView alloc] initWithFrame:self.contentView.bounds];
    [bgView setBackgroundColor:[UIColor clearColor]];
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(margin, 0, bgView.width - margin * 2, bgView.height)];
    [bgImageView setImage:[self highlightedBGImageForCellType:self.cellType]];
    [bgView addSubview:bgImageView];
    self.selectedBackgroundView = bgView;
}


@end
