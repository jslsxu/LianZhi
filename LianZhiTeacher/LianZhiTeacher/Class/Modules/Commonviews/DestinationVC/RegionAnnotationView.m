//
//  RegionAnnotationView.m
//  AnjukeBroker_New
//
//  Created by shan xu on 14-3-19.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "RegionAnnotationView.h"
@implementation BasicMapAnnotation

@end

@implementation RegionAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _regionDetailView = [[UIView alloc] init];
        [_regionDetailView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_regionDetailView];
        
        _bgImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"AnnotationBG"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)]];
        [_regionDetailView addSubview:_bgImageView];
        
    }
    return self;
}
@end

