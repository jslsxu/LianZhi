//
//  PhotoPickerView.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/1/22.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoPickerView;
@protocol PhotoPickerDelegate <NSObject>
@optional
- (void)photoPickerDidSelectCamera:(PhotoPickerView *)picker;
- (void)photoPickerDidSelectAlbum:(PhotoPickerView *)picker;
@end

@interface PhotoPickerView : UIView
{
    UILabel*    _hintLabel;
    UIButton*   _cameraBtn;
    UIButton*   _albumBtn;
}

@property (nonatomic, weak)id<PhotoPickerDelegate> delegate;

@end
