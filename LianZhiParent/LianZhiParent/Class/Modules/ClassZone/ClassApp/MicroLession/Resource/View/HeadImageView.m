
//
//  HeadImageView.m
//  京师杏林
//
//  Created by sjt on 15/11/12.
//  Copyright © 2015年 MaNingbo. All rights reserved.
//

#import "HeadImageView.h"
#import "ResourceDefine.h"
@interface HeadImageView()


@end
@implementation HeadImageView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=[UIColor clearColor];
        
//        self.imageFirstView.layer.masksToBounds=YES;
//        self.imageFirstView.layer.cornerRadius= 37;
//        self.imageFirstView.layer.borderWidth = 2;
//        self.imageFirstView.layer.borderColor = JXColor(0x04,0xae,0x81,1).CGColor;
        
        self.nameFirstLbl.textAlignment=NSTextAlignmentCenter;
        self.nameFirstLbl.textColor=[UIColor whiteColor];
        self.nameFirstLbl.font=[UIFont boldSystemFontOfSize:16.0f];
        [self.nameFirstLbl sizeToFit];
        
        self.contentFirstLbl.textAlignment=NSTextAlignmentCenter;
        self.contentFirstLbl.textColor=JXColor(0xff,0xeb,0x40,1);
        self.contentFirstLbl.font=[UIFont systemFontOfSize:15.0f];
        self.contentFirstLbl.numberOfLines=0;

//        self.imageSecondView.layer.masksToBounds=YES;
//        self.imageSecondView.layer.cornerRadius= 30;
//        self.imageSecondView.layer.borderWidth = 2;
//        self.imageSecondView.layer.borderColor = JXColor(0x04,0xae,0x81,1).CGColor;
        
        self.nameSecondLbl.textAlignment=NSTextAlignmentCenter;
        self.nameSecondLbl.textColor=[UIColor whiteColor];
        self.nameSecondLbl.font=[UIFont boldSystemFontOfSize:16.0f];
        [self.nameSecondLbl sizeToFit];
        
        self.contentSecondLbl.textAlignment=NSTextAlignmentCenter;
        self.contentSecondLbl.textColor=JXColor(0xff,0xeb,0x40,1);
        self.contentSecondLbl.font=[UIFont systemFontOfSize:15.0f];
        self.contentSecondLbl.numberOfLines=0;

//        self.imageThirdView.layer.masksToBounds=YES;
//        self.imageThirdView.layer.cornerRadius= 30;
//        self.imageThirdView.layer.borderWidth = 2;
//        self.imageThirdView.layer.borderColor = JXColor(0x04,0xae,0x81,1).CGColor;
        
        

        self.nameThirdLbl.textAlignment=NSTextAlignmentCenter;
        self.nameThirdLbl.textColor=[UIColor whiteColor];
        self.nameThirdLbl.font=[UIFont boldSystemFontOfSize:16.0f];

        [self.nameThirdLbl sizeToFit];
        
        self.contentThirdLbl.textAlignment=NSTextAlignmentCenter;
        self.contentThirdLbl.textColor=JXColor(0xff,0xeb,0x40,1);
        self.contentThirdLbl.font=[UIFont systemFontOfSize:15.0f];
        self.contentThirdLbl.numberOfLines=0;

    }
    return self;
}

@end
