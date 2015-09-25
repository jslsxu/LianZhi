//
//  PoiInfoView.m
//  LianZhiParent
//
//  Created by jslsxu on 15/5/28.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "PoiInfoView.h"

@implementation PoiInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        
        UIImageView*    locationImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LocationIcon"]];
        [locationImage setCenter:CGPointMake(self.height / 2, self.height / 2)];
        [self addSubview:locationImage];
        
        if(_locationLabel == nil)
        {
            _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(locationImage.right + 10, 0, self.width - locationImage.right - 10 * 2, self.height)];
            [_locationLabel setTextColor:[UIColor darkGrayColor]];
            [_locationLabel setFont:[UIFont systemFontOfSize:15]];
            [_locationLabel setText:@"地点"];
            [self addSubview:_locationLabel];
        }
        
        UIButton *coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [coverButton addTarget:self action:@selector(onCoverButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [coverButton setFrame:self.bounds];
        [self addSubview:coverButton];
    }
    return self;
}

- (void)setPoiItem:(POIItem *)poiItem
{
    _poiItem = poiItem;
    _locationLabel.text = _poiItem.poiInfo.name;
}

- (void)onCoverButtonClicked
{
    POISelectVC *poiSelectVC = [[POISelectVC alloc] init];
    [poiSelectVC setDelegate:self];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:poiSelectVC];
    [self.parentVC presentViewController:nav animated:YES completion:nil];
}


#pragma mark - POISelectDelegate
- (void)poiSelectVCDidCancel:(POISelectVC *)poiSelectVC
{
    [poiSelectVC dismissViewControllerAnimated:YES completion:nil];
}

- (void)poiSelectVC:(POISelectVC *)poiSelectVC didFinished:(POIItem *)poiItem
{
    [poiSelectVC dismissViewControllerAnimated:YES completion:nil];
    [self setPoiItem:poiItem];
}

- (void)poiSelectVCDidClear:(POISelectVC *)poiSelectVC
{
    [poiSelectVC dismissViewControllerAnimated:YES completion:nil];
}
@end
