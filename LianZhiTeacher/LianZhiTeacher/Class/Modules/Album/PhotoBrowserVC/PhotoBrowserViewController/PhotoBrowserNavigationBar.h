//
//  TGMMddPhotoBrowserNavigationBar.h
//  TravelGuideMdd
//
//  Created by CHANG LIU on 14/10/20.
//  Copyright (c) 2014年 mafengwo.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol PhotoBrowserNavigationBarDelegate<NSObject>

@optional
- (void)didClickBackButton;
- (void)didClickDeleteButton:(PhotoItem *)photoItem;
- (void)didClickDownloadButton:(PhotoItem *)photoItem;
@end

@interface PhotoBrowserNavigationBar : UIView
@property (nonatomic, strong)PhotoItem *photo;
@property (nonatomic, assign) id<PhotoBrowserNavigationBarDelegate> delegate;

@end