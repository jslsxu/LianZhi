//
//  ResultHeaderView.m
//  LianZhiParent
//
//  Created by Chen Qi on 2016/10/10.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "ResultHeaderView.h"

@implementation ResultHeaderView


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=[UIColor clearColor];
        
        
        self.bgView=[[UIImageView alloc]initWithFrame:self.bounds];
        [self.bgView setImage:[UIImage imageNamed:@"TopView1"]]; //rankingTitle
        [self addSubview:self.bgView];
    }
    return self;
}

-(void)setStar:(NSUInteger)star
{
    if(star == 1)
         [self.bgView setImage:[UIImage imageNamed:@"TopView1"]];
    else if(star == 2)
         [self.bgView setImage:[UIImage imageNamed:@"TopView2"]];
    else if(star == 3)
         [self.bgView setImage:[UIImage imageNamed:@"TopView3"]];
    else
         [self.bgView setImage:[UIImage imageNamed:@"TopView0"]];
}
@end
