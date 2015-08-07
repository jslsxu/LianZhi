//
//  PhotoOperationVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/1/19.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "PhotoPickerVC.h"

#define kPostUrlKey                     @"PostUrlKey"
#define kNormalParamsKey                @"NormalParamsKey"
#define kImageArrayKey                  @"ImageArrayKey"

@protocol PhotoOperationDelegate <NSObject>
- (void)photoOperationDidFinished:(NSDictionary *)itemParams;

@end

@interface PhotoOperationVC : TNBaseViewController<PhotoPickerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,  PhotoPickerVCDelegate>
{
    NSMutableArray*     _imageArray;
    UIScrollView*       _scrollView;
    PhotoPickerView*    _pickerView;
    UIImageView*        _imageBGImageView;
    NSMutableArray*     _imageItemViewArray;
    UIImageView*        _operationView;
    UTPlaceholderTextView*         _textView;
    UILabel*            _numLabel;
    UIButton*           _sendToClassAlbumBtn;
    UILabel*            _titleLabel;
}
@property (nonatomic, assign)BOOL sendToClass;
@property (nonatomic, strong)ClassInfo *classInfo;
@property (nonatomic, strong)NSArray *targetArray;
@property (nonatomic, weak)id<PhotoOperationDelegate> photoOperationDelegate;
@end
