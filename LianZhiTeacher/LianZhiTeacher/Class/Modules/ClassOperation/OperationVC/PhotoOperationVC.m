//
//  PhotoOperationVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/1/19.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "PhotoOperationVC.h"

#define kBorderMargin                   16
#define kBaseTag                        1000

@interface PhotoOperationVC ()< UITextViewDelegate, UIScrollViewDelegate>

@end

@implementation PhotoOperationVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        _imageArray = [[NSMutableArray alloc] initWithCapacity:0];
        _imageItemViewArray = [[NSMutableArray alloc] initWithCapacity:0];
        [self setPhotoOperationDelegate:ApplicationDelegate.homeVC.classOperationVC];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:MJRefreshSrcName(@"WhiteLeftArrow.png")] style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    NSString *right = nil;
    if(self.classInfo && self.classInfo.classID.integerValue != -1)
    {
        right = [NSString stringWithFormat:@"%ld人",(long)self.targetArray.count];
    }
    else
    {
        NSInteger num = self.targetArray.count;
        right = [NSString stringWithFormat:@"%ld个班",(long)num];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:right style:UIBarButtonItemStylePlain target:nil action:nil];
    self.title = @"照片分享";
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [_scrollView setBounces:YES];
    [_scrollView setDelegate:self];
    [_scrollView setAlwaysBounceVertical:YES];
    [_scrollView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_scrollView];
    
    _pickerView = [[PhotoPickerView alloc] initWithFrame:CGRectMake(0, 0, 82, 82)];
    [_pickerView setDelegate:self];
}

#pragma mark KeyboardNotification
- (void)onKeyboardShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration animations:^{
        [_scrollView setContentInset:UIEdgeInsetsMake(0, 0, keyboardRect.size.height, 0)];
        [_scrollView setContentOffset:CGPointMake(0, keyboardRect.size.height - _scrollView.height + [_textView convertPoint:CGPointMake(0, _textView.bottom) toView:_scrollView].y)];
    }];
}

- (void)onKeyboardHide:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration animations:^{
        [_scrollView setContentInset:UIEdgeInsetsZero];
    }];
}

- (void)setupSubviews
{
    if(_imageBGImageView == nil)
    {
        _imageBGImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:MJRefreshSrcName(@"GrayBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
        [_imageBGImageView setFrame:CGRectMake(kBorderMargin, kBorderMargin, _scrollView.width - kBorderMargin * 2, 240)];
        [_imageBGImageView setUserInteractionEnabled:YES];
        [_scrollView addSubview:_imageBGImageView];
    }
    
    [self setupImageView];
    
    if(_operationView == nil)
    {
        _operationView = [[UIImageView alloc] initWithFrame:CGRectMake(kBorderMargin, _imageBGImageView.bottom + kBorderMargin, _scrollView.width - kBorderMargin * 2, 130)];
        [_operationView setImage:[[UIImage imageNamed:MJRefreshSrcName(@"GrayBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
        [_operationView setUserInteractionEnabled:YES];
        [_scrollView addSubview:_operationView];
    }
    [self setupOperationView:_operationView];
    [_operationView setY:_imageBGImageView.bottom + kBorderMargin];
    [_scrollView setContentSize:CGSizeMake(_scrollView.width, _operationView.bottom + kBorderMargin)];
}

- (void)setupImageView
{
    [_pickerView removeFromSuperview];
    [_imageItemViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_imageItemViewArray removeAllObjects];
    CGFloat width = (_imageBGImageView.width - kBorderMargin * 2 - 5 * 2) / 3;
    NSInteger num = 9;
    NSInteger row = MAX((num + 2) / 3, 1);
    CGFloat bgHeight = kBorderMargin * 2 + row * width + (row - 1) * 5;
    [_imageBGImageView setHeight:bgHeight];
    [_operationView setY:_imageBGImageView.bottom + kBorderMargin];
    for (NSInteger i = 0; i < num;i++)
    {
        NSInteger column = i % 3;
        row = i / 3;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kBorderMargin + column * (width + 5) , kBorderMargin + (width + 5) * row, width, width)];
        [imageView setTag:kBaseTag + i];
        [imageView setUserInteractionEnabled:YES];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [imageView setClipsToBounds:YES];
        [imageView setBackgroundColor:[UIColor colorWithHexString:@"a4a4a4"]];
        [_imageBGImageView addSubview:imageView];
        [_imageItemViewArray addObject:imageView];
        if(i < [_imageArray count])
        {
            PublishImageItem *imageItem = [_imageArray objectAtIndex:i];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageItem.thumbnailUrl] placeholderImage:imageItem.image];
            UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPressGesture:)];
            [longPressGesture setMinimumPressDuration:1];
            [imageView addGestureRecognizer:longPressGesture];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
            [imageView addGestureRecognizer:tapGesture];
        }
    }
    if(_imageArray.count < 9)
    {
        NSInteger num = _imageArray.count;
        row = num / 3;
        NSInteger column = num % 3;
        [_pickerView setFrame:CGRectMake(kBorderMargin + column * (width + 5), kBorderMargin + (width + 5) * row, width, width)];
        [_imageBGImageView addSubview:_pickerView];
    }
}


- (void)onLongPressGesture:(UILongPressGestureRecognizer *)longGesture
{
    [self.view endEditing:YES];
    if(longGesture.state == UIGestureRecognizerStateBegan)
    {
        UIImageView *targetView = (UIImageView *)longGesture.view;
        NSInteger index = targetView.tag - kBaseTag;
        TNButtonItem *cancelItem = [TNButtonItem itemWithTitle:@"取消" action:nil];
        TNButtonItem *confirmItem = [TNButtonItem itemWithTitle:@"确定" action:^{
            [_imageArray removeObjectAtIndex:index];
            [self setupImageView];
        }];
        
        TNActionSheet *actionSheet = [[TNActionSheet alloc] initWithTitle:@"确定要删除这张照片吗?" descriptionView:nil destructiveButton:confirmItem cancelItem:cancelItem otherItems:nil];
        [actionSheet show];
    }
}

- (void)onTap:(UITapGestureRecognizer *)tapGesture
{
    [self.view endEditing:YES];
    UIView *rootView = [UIApplication sharedApplication].keyWindow;
    UIImageView *targetView = (UIImageView *)tapGesture.view;
    SimpleImageScanView *scanView = [[SimpleImageScanView alloc] initWithSourceImage:targetView.image];
    [scanView showFromTargetFrame:[targetView convertRect:targetView.bounds toView:rootView]];
}

- (void)setupOperationView:(UIView *)viewParent
{
    if(_titleLabel == nil)
    {
        UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendButton setFrame:CGRectMake(viewParent.width - kBorderMargin - 95, viewParent.height - 56 - kBorderMargin, 95, 56)];
        [sendButton setBackgroundImage:[[UIImage imageNamed:MJRefreshSrcName(@"BlueBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
        [sendButton addTarget:self action:@selector(onSendButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [viewParent addSubview:sendButton];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectInset(sendButton.bounds, 5, 0)];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setNumberOfLines:0];
        [_titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [sendButton addSubview:_titleLabel];
    }
    
    NSMutableString *mutableStr = [[NSMutableString alloc] init];
    [mutableStr appendFormat:@"您已选择%li/9",(long)_imageArray.count];
    NSInteger firstLength = mutableStr.length;
    [mutableStr appendString:@"\n分享给家长"];
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:mutableStr];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, firstLength)];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(firstLength, mutableStr.length - firstLength)];
    [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, firstLength)];
    [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(firstLength, mutableStr.length - firstLength)];
    
    [_titleLabel setAttributedText:attributeStr];
    
    
    if(_textView == nil)
    {
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:MJRefreshSrcName(@"WhiteBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
        [bgImageView setUserInteractionEnabled:YES];
        [bgImageView setFrame:CGRectMake(kBorderMargin, kBorderMargin, viewParent.width - 95 - kBorderMargin - kBorderMargin - kBorderMargin, viewParent.height - kBorderMargin * 2)];
        [viewParent addSubview:bgImageView];
        
        _textView = [[UTPlaceholderTextView alloc] initWithFrame:CGRectMake(5, 5, bgImageView.width - 5 * 2, bgImageView.height - 5 - 20)];
        [_textView setBackgroundColor:[UIColor clearColor]];
        [_textView setFont:[UIFont systemFontOfSize:15]];
        [_textView setTextColor:[UIColor colorWithHexString:@"666666"]];
        [_textView setReturnKeyType:UIReturnKeyDone];
        [_textView setPlaceholder:@"配点文字"];
        [_textView setDelegate:self];
        
        [bgImageView addSubview:_textView];
        
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(_textView.left, _textView.bottom, _textView.width, 20)];
        [_numLabel setTextColor:[UIColor lightGrayColor]];
        [_numLabel setFont:[UIFont systemFontOfSize:14]];
        [_numLabel setTextAlignment:NSTextAlignmentRight];
        [_numLabel setText:kStringFromValue(kCommonMaxNum - _textView.text.length)];
        [bgImageView addSubview:_numLabel];
    }

    
    if(_sendToClassAlbumBtn == nil)
    {
        _sendToClassAlbumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendToClassAlbumBtn setImage:[UIImage imageNamed:@"SendToClass.png"] forState:UIControlStateNormal];
        [_sendToClassAlbumBtn setFrame:CGRectMake(viewParent.width - kBorderMargin - 95, kBorderMargin, 95, 30)];
        [_sendToClassAlbumBtn addTarget:self action:@selector(onSendSwitchClicked) forControlEvents:UIControlEventTouchUpInside];
        [viewParent addSubview:_sendToClassAlbumBtn];
    }
    self.sendToClass = YES;
}

- (void)onSendSwitchClicked
{
    self.sendToClass = !self.sendToClass;
    if(self.sendToClass)
        [_sendToClassAlbumBtn setImage:[UIImage imageNamed:@"SendToClass.png"] forState:UIControlStateNormal];
    else
        [_sendToClassAlbumBtn setImage:[UIImage imageNamed:@"NotSendToClass.png"] forState:UIControlStateNormal];
}

- (void)onSendButtonClicked
{
    [self.view endEditing:YES];
    
    if(_imageArray.count == 0)
    {
        [ProgressHUD showHintText:@"你还没有选择照片"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_textView.text forKey:@"words"];
    NSMutableString *picSeq = [[NSMutableString alloc] initWithCapacity:0];
    for (NSInteger i = 0; i < [_imageArray count]; i++)
    {
        PublishImageItem *imageItem = _imageArray[i];
        NSString *picName = nil;
        if(imageItem.image)
        {
            picName = [NSString stringWithFormat:@"picture_%ld",(long)i];
            imageItem.photoKey = picName;
        }
        else
            picName = imageItem.photoID;
        if(picSeq.length == 0)
            [picSeq appendString:picName];
        else
            [picSeq appendFormat:@",%@",picName];
    }
    [params setValue:picSeq forKey:@"pic_seqs"];
    [params setValue:kStringFromValue(self.sendToClass) forKey:@"sync_album"];
    [params setValue:kStringFromValue([[NSDate date] timeIntervalSince1970]) forKey:@"onlywifi_time"];
    NSString *url = nil;
    NSMutableString *targetStr = [[NSMutableString alloc] initWithCapacity:0];
    id item0 = [self.targetArray objectAtIndex:0];
    if([item0 isKindOfClass:[StudentInfo class]])
    {
        url = @"class/picture_to_students";
        for (StudentInfo *studentInfo in self.targetArray) {
            if([targetStr length] == 0)
                [targetStr appendString:studentInfo.uid];
            else
                [targetStr appendFormat:@",%@",studentInfo.uid];
        }
        [params setValue:targetStr forKey:@"student_ids"];
        [params setValue:self.classInfo.classID forKey:@"class_id"];
    }
    else
    {
        url = @"class/picture_to_classes";
        for (ClassInfo *classInfo in self.targetArray) {
            if([targetStr length] == 0)
                [targetStr appendString:classInfo.classID];
            else
                [targetStr appendFormat:@",%@",classInfo.classID];
        }
        [params setValue:targetStr forKey:@"class_ids"];
    }
    
//    MBProgressHUD *hud = [MBProgressHUD showMessag:@"正在上传" toView:self.view];
//    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:url withParams:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        for (NSInteger i = 0; i < [_imageArray count]; i++) {
//            PublishImageItem *imageItem = [_imageArray objectAtIndex:i];
//            NSString *imageName = [NSString stringWithFormat:@"picture_%ld",(long)i];
//            if(imageItem.image)
//                [formData appendPartWithFileData:UIImageJPEGRepresentation(imageItem.image, 0.8) name:imageName fileName:imageName mimeType:@"image/jpeg"];
//        }
//    } completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
//        [hud hide:YES];
//        [MBProgressHUD showSuccess:@"发送成功" toView:self.view];
//        dispatch_after(NSEC_PER_SEC * 2, dispatch_get_main_queue(), ^{
//            [self dismissViewControllerAnimated:YES completion:nil];
//        });
//    } fail:^(NSString *errMsg) {
//        [hud hide:YES];
//        [MBProgressHUD showError:errMsg toView:self.view];
//    }];
    
    if([self.photoOperationDelegate respondsToSelector:@selector(photoOperationDidFinished:)])
    {
        [self.photoOperationDelegate photoOperationDidFinished:@{kPostUrlKey : url , kNormalParamsKey : params, kImageArrayKey : _imageArray}];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//#pragma mark - UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    [self.view endEditing:YES];
//}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSString *text = textView.text;
    NSInteger num = text.length;
    if(num > kCommonMaxNum)
        [textView setText:[text substringToIndex:kCommonMaxNum]];
    [_numLabel setText:kStringFromValue(kCommonMaxNum - textView.text.length)];
}
#pragma mark - PhotoPickerDelegate
- (void)photoPickerDidSelectAlbum:(PhotoPickerView *)picker
{
    [self.view endEditing:YES];
    NSString *classID = nil;
    if([self.classInfo.classID isEqualToString:@"-1"])
    {
        if(self.targetArray.count == 1)
        {
            ClassInfo *classInfo = [self.targetArray objectAtIndex:0];
            classID = classInfo.classID;
        }
    }
    else
        classID = self.classInfo.classID;
    if(classID)
    {
        PhotoPickerVC *photoPickerVC = [[PhotoPickerVC alloc] init];
        [photoPickerVC setMaxToSelected:9 - _imageArray.count];
        [photoPickerVC setClassID:classID];
        [photoPickerVC setDelegate:self];
        UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:photoPickerVC];
        [self presentViewController:navigationVC animated:YES completion:nil];
    }
    else
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [imagePicker setDelegate:self];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)photoPickerDidSelectCamera:(PhotoPickerView *)picker
{
    [self.view endEditing:YES];
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [imagePicker setDelegate:self];
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - PhotoPickerVCDelegate
- (void)photoPickerVC:(PhotoPickerVC *)photoPickerVC didFinished:(NSArray *)selectedArray
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [_imageArray addObjectsFromArray:selectedArray];
    [self setupSubviews];
}

- (void)photoPickerVCDidCancel:(PhotoPickerVC *)photoPickerVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if(_imageArray.count == 9)
    {
        TNButtonItem *item = [TNButtonItem itemWithTitle:@"确定" action:^{
            
        }];
        TNAlertView *alertView  = [[TNAlertView alloc] initWithTitle:@"最多发9张照片" buttonItems:@[item]];
        [alertView show];
    }
    else
    {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        image = [image formatImage];
        PublishImageItem *imageItem = [[PublishImageItem alloc] init];
        [imageItem setImage:image];
        [_imageArray addObject:imageItem];
        [self setupSubviews];
    }
    [self.navigationController popToRootViewControllerAnimated:NO];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
