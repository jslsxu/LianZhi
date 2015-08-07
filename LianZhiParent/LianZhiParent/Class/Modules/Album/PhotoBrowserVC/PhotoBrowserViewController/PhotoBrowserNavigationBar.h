//
//  TGMMddPhotoBrowserNavigationBar.h
//  TravelGuideMdd
//
//  Created by CHANG LIU on 14/10/20.
//  Copyright (c) 2014年 mafengwo.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, PhotoBrowserType) {
    PhotoBrowserTypeNormal = 0,         //正常浏览
    PhotoBrowserTypeZone,               //班空间相册
    PhotoBrowserTypeTreeHouse,          //树屋相册
};
@protocol PhotoBrowserNavigationBarDelegate<NSObject>

@optional
- (void)didClickBackButton;
- (void)didClickDeleteButton:(PhotoItem *)photoItem;
- (void)didClickDownloadButton:(PhotoItem *)photoItem;
@end

@interface PhotoBrowserNavigationBar : UIView
@property (nonatomic, assign)PhotoBrowserType browserType;
@property (nonatomic, strong)PhotoItem *photo;
@property (nonatomic, assign) id<PhotoBrowserNavigationBarDelegate> delegate;

@end