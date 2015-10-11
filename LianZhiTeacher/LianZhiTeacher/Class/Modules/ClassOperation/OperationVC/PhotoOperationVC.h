//
//  PhotoOperationVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/1/19.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "MessageSendVC.h"
#import "PhotoPickerVC.h"

#define kPostUrlKey                     @"PostUrlKey"
#define kNormalParamsKey                @"NormalParamsKey"
#define kImageArrayKey                  @"ImageArrayKey"

@protocol PhotoOperationDelegate <NSObject>
- (void)photoOperationDidFinished:(NSDictionary *)itemParams;

@end

@interface PhotoOperationVC : MessageSendVC<PhotoPickerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,  PhotoPickerVCDelegate>
{
    NSMutableArray*     _imageArray;
    UIScrollView*       _scrollView;
    PhotoPickerView*    _pickerView;
    UIView*             _bgView;
    NSMutableArray*     _imageItemViewArray;
    UTPlaceholderTextView*        _textView;
}
@property (nonatomic, strong)NSArray *originalImageArray;
@property (nonatomic, assign)BOOL sendToClass;
@property (nonatomic, strong)ClassInfo *classInfo;
@property (nonatomic, strong)NSArray *targetArray;
@property (nonatomic, weak)id<PhotoOperationDelegate> photoOperationDelegate;
@end
