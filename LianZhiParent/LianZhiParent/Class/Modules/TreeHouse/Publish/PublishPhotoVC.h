//
//  PublishPhotoVC.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/19.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "PublishBaseVC.h"
#import "PhotoPickerVC.h"

@interface PublishPhotoVC : PublishBaseVC<PhotoPickerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,  PhotoPickerVCDelegate, UITextViewDelegate>
{
    NSMutableArray*     _imageArray;
    UIScrollView*       _scrollView;
    PhotoPickerView*    _pickerView;
    UIImageView*        _imageBGImageView;
    NSMutableArray*     _imageItemViewArray;
    PoiInfoView*        _poiInfoView;
    UIImageView*        _operationView;
    UILabel*            _titleLabel;
    UTPlaceholderTextView*         _textView;
    UILabel*            _numLabel;
}
@end
