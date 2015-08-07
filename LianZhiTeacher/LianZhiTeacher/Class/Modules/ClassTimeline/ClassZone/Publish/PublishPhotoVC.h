//
//  PublishPhotoVC.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/19.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "PublishBaseVC.h"
#import "PhotoPickerVC.h"

@interface PublishPhotoVC : PublishBaseVC<PhotoPickerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, PhotoPickerVCDelegate>
{
    NSMutableArray*     _imageArray;
    UIScrollView*       _scrollView;
    PhotoPickerView*    _pickerView;
    UIImageView*        _imageBGImageView;
    NSMutableArray*     _imageItemViewArray;
    UIImageView*        _operationView;
    UTPlaceholderTextView*         _textView;
    UILabel*            _numLabel;
    UILabel*            _titleLabel;
}
@end
