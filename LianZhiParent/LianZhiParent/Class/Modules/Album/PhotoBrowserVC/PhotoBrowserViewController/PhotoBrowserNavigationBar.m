//
//  TGMMddPhotoBrowserNavigationBar.m
//  TravelGuideMdd
//
//  Created by CHANG LIU on 14/10/20.
//  Copyright (c) 2014年 mafengwo.com. All rights reserved.
//

#import "PhotoBrowserNavigationBar.h"
#import "MBProgressHUD+Add.h"

#import <AssetsLibrary/AssetsLibrary.h>

@interface PhotoBrowserNavigationBar()
{
    UIButton *backButton;
    UIButton *deleteButton;
    UILabel* _timeLabel;
    UIButton *saveButton;
}
@end

@implementation PhotoBrowserNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setFrame:CGRectMake(0,0, 44, 44)];
        [backButton setImage:[UIImage imageNamed:@"PhotoBrowserBack"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backButton];
        
        saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [saveButton setFrame:CGRectMake(self.width - 44 - 10, 0, 44, 44)];
        [saveButton setImage:[UIImage imageNamed:@"DownloadToAlbum"] forState:UIControlStateNormal];
        [saveButton addTarget:self action:@selector(clickSavePhoto) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:saveButton];
        
        UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(45, 10, kLineHeight, self.height - 10 * 2)];
        [sepLine setBackgroundColor:[UIColor blackColor]];
        [self addSubview:sepLine];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(sepLine.right + 10, 0, saveButton.x - 10 - (sepLine.right + 10), self.height)];
        [_timeLabel setTextColor:[UIColor whiteColor]];
        [_timeLabel setFont:[UIFont systemFontOfSize:16]];
        [self addSubview:_timeLabel];
    
        
//        deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [deleteButton setFrame:CGRectMake(saveButton.left - 44 - 10,20, 44, 44)];
//        [deleteButton setImage:[UIImage imageNamed:@"Trash.png"] forState:UIControlStateNormal];
//        [deleteButton addTarget:self action:@selector(clickDeletePhoto) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:deleteButton];
    }
    return self;
}

//- (void)setBrowserType:(PhotoBrowserType)browserType
//{
//    _browserType = browserType;
//    if(_browserType == PhotoBrowserTypeZone)//下载到树屋
//    {
//        [saveButton setImage:[UIImage imageNamed:@"DownloadToAlbum"] forState:UIControlStateNormal];
//    }
//    else //bendi 
//    {
//        [saveButton setImage:[UIImage imageNamed:@"DownloadToAlbum"] forState:UIControlStateNormal];
//    }
//}

- (void)setPhoto:(PhotoItem *)photo
{
    _photo = photo;
    [deleteButton setHidden:!self.photo.can_edit];
    [_timeLabel setText:_photo.time_str];
}


- (void)clickBack
{
    if ([_delegate respondsToSelector:@selector(didClickBackButton)]) {
        [_delegate didClickBackButton];
    }
}

- (void)clickDeletePhoto
{
    
    if([self.delegate respondsToSelector:@selector(didClickDeleteButton:)])
        [self.delegate didClickDeleteButton:self.photo];
}


- (void)clickSavePhoto
{
    
    if([self.delegate respondsToSelector:@selector(didClickDownloadButton:)])
        [self.delegate didClickDownloadButton:self.photo];
}



@end
