//
//  PublishPhotoVC.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/19.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "PublishBaseVC.h"
#import "PhotoPickerVC.h"

@interface PublishPhotoVC : PublishBaseVC<PhotoPickerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,  PhotoPickerVCDelegate>
{
    NSMutableArray*     _imageArray;
    UIScrollView*       _scrollView;
    PhotoPickerView*    _pickerView;
    UIView*             _bgView;
    NSMutableArray*     _imageItemViewArray;
    UTPlaceholderTextView*        _textView;
}
@property (nonatomic, strong)NSArray *originalImageArray;
@end
