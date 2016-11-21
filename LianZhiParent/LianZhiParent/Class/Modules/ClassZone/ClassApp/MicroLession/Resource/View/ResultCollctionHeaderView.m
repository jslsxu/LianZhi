//
//  ResultCollctionHeaderView.m
//  LianZhiParent
//
//  Created by Chen Qi on 2016/10/11.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "ResultCollctionHeaderView.h"
#import "ResourceDefine.h"

@implementation ResultCollctionHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{

    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=[UIColor clearColor];
        
        CGFloat padding = 2;
        CGFloat widthOfLabel = 40;
        CGFloat widthOfImg = 16;
        
        UILabel *correctImgLabel=[[UILabel alloc]initWithFrame:CGRectMake( WIDTH - 3 *widthOfLabel - 3*padding - 3*widthOfImg , 8, widthOfImg , widthOfImg)];
        correctImgLabel.backgroundColor = GreenResultInstructionColor ;
        [self addSubview:correctImgLabel];
        
        UILabel *correctLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        correctLabel.frame= CGRectMake(WIDTH - 3 *widthOfLabel - 3*padding - 2*widthOfImg , 0, widthOfLabel , 30);
        [correctLabel setBackgroundColor:[UIColor clearColor]];
        [correctLabel setTextAlignment:NSTextAlignmentCenter];
        [correctLabel setFont:[UIFont systemFontOfSize:15]];
        [correctLabel setTextColor:LightGrayLblColor];
        [correctLabel setText:@"正确"];
        [self addSubview:correctLabel];
        
        UILabel *wrongImgLabel=[[UILabel alloc]initWithFrame:CGRectMake( WIDTH - 2 *widthOfLabel - 2*padding - 2*widthOfImg , 8, widthOfImg , widthOfImg)];
        wrongImgLabel.backgroundColor = RedResultInstructionColor ;
        [self addSubview:wrongImgLabel];
        
        UILabel *wrongLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        wrongLabel.frame= CGRectMake(WIDTH - 2 *widthOfLabel - 2*padding - widthOfImg , 0, widthOfLabel , 30);
        [wrongLabel setBackgroundColor:[UIColor clearColor]];
        [wrongLabel setTextAlignment:NSTextAlignmentCenter];
        [wrongLabel setFont:[UIFont systemFontOfSize:15]];
        [wrongLabel setTextColor:LightGrayLblColor];
        [wrongLabel setText:@"错误"];
        [self addSubview:wrongLabel];
        
        UILabel *noAnswerImgLabel=[[UILabel alloc]initWithFrame:CGRectMake( WIDTH - widthOfLabel - padding - widthOfImg , 8, widthOfImg , widthOfImg)];
        noAnswerImgLabel.backgroundColor = WhiteColor ;
        [noAnswerImgLabel.layer setMasksToBounds:YES];
        noAnswerImgLabel.layer.borderWidth = 1;
        noAnswerImgLabel.layer.borderColor = GreenLblColor.CGColor;
        
        [self addSubview:noAnswerImgLabel];
        
        UILabel *noAnswerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        noAnswerLabel.frame= CGRectMake( WIDTH - widthOfLabel - padding , 0, widthOfLabel , 30);
        [noAnswerLabel setBackgroundColor:[UIColor clearColor]];
        [noAnswerLabel setTextAlignment:NSTextAlignmentCenter];
        [noAnswerLabel setFont:[UIFont systemFontOfSize:15]];
        [noAnswerLabel setTextColor:LightGrayLblColor];
        [noAnswerLabel setText:@"未答"];
        [self addSubview:noAnswerLabel];
 
    }
    return self;
}

@end
