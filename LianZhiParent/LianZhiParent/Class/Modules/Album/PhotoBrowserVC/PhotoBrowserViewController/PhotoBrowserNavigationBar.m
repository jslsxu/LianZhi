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
    UIButton *saveButton;
}
@end

@implementation PhotoBrowserNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setFrame:CGRectMake(10,20, 44, 44)];
        [backButton setImage:[UIImage imageNamed:@"PhotoBrowserBack.png"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backButton];
        
        saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [saveButton setFrame:CGRectMake(self.width - 56, 20, 46, 44)];
        [saveButton setImage:[UIImage imageNamed:MJRefreshSrcName(@"PhotoDownload.png")] forState:UIControlStateNormal];
        [saveButton addTarget:self action:@selector(clickSavePhoto) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:saveButton];
        
        deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteButton setFrame:CGRectMake(saveButton.left - 44 - 10,20, 44, 44)];
        [deleteButton setImage:[UIImage imageNamed:MJRefreshSrcName(@"Trash.png")] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(clickDeletePhoto) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteButton];
    }
    return self;
}

- (void)setBrowserType:(PhotoBrowserType)browserType
{
    _browserType = browserType;
    if(_browserType == PhotoBrowserTypeZone)//下载到树屋
    {
        [saveButton setImage:[UIImage imageNamed:MJRefreshSrcName(@"PhotoDownload.png")] forState:UIControlStateNormal];
    }
    else //bendi 
    {
        [saveButton setImage:[UIImage imageNamed:MJRefreshSrcName(@"DownloadToAlbum.png")] forState:UIControlStateNormal];
    }
}

- (void)setPhoto:(PhotoItem *)photo
{
    _photo = photo;
    [deleteButton setHidden:!self.photo.canDelete];
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
