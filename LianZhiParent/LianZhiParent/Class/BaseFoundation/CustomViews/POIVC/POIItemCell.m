//
//  POIItemCell.m
//  LianZhiParent
//
//  Created by jslsxu on 15/5/27.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "POIItemCell.h"

@implementation POIItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.width - 10 * 2 - 30, 20)];
        [_nameLabel setTextColor:[UIColor darkGrayColor]];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_nameLabel];
        
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _nameLabel.bottom, self.width - 10 * 2 - 30, 20)];
        [_detailLabel setTextColor:[UIColor lightGrayColor]];
        [_detailLabel setFont:[UIFont systemFontOfSize:13]];
        [self addSubview:_detailLabel];
        
        UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 55 - 0.5, self.width, 0.5)];
        [sepLine setBackgroundColor:[UIColor colorWithHexString:@"D8D8D8"]];
        [self addSubview:sepLine];
    }
    return self;
}


- (void)setPoiItem:(POIItem *)poiItem
{
    _poiItem = poiItem;
    NSString *name = _poiItem.poiInfo.name;
    NSString *address = _poiItem.poiInfo.address;
    [_nameLabel setText:name];
    [_detailLabel setText:address];
    if(name.length > 0 && address.length > 0)
    {
        [_nameLabel setFrame:CGRectMake(10, 10, self.width - 10 * 2 - 30, 20)];
        [_detailLabel setFrame:CGRectMake(10, _nameLabel.bottom, self.width - 10 * 2 - 30, 20)];
    }
    else if(address.length == 0)
    {
        [_nameLabel setFrame:CGRectMake(10, 10, self.width - 10 * 2 - 30, 30)];
        if(name.length == 0 && _poiItem.clearLocation)
            [_nameLabel setText:@"不显示位置"];
    }
    if(_poiItem.selected)
        [self setAccessoryType:UITableViewCellAccessoryCheckmark];
    else
        [self setAccessoryType:UITableViewCellAccessoryNone];
}

@end
