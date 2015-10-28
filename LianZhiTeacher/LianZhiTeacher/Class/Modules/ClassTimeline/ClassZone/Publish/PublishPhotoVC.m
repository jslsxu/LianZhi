//
//  PublishPhotoVC.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/19.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "PublishPhotoVC.h"
#import "PoiInfoView.h"
#define kBorderMargin                   16

#define kBaseTag                        1000

@interface PublishPhotoVC ()<UITextViewDelegate>

@end

@implementation PublishPhotoVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        _imageArray = [[NSMutableArray alloc] initWithCapacity:0];
        _imageItemViewArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发照片";
    
    _scrollView = [[UITouchScrollView alloc] initWithFrame:self.view.bounds];
    [_scrollView setBounces:YES];
    [_scrollView setAlwaysBounceVertical:YES];
    [_scrollView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_scrollView];
    
    _pickerView = [[PhotoPickerView alloc] initWithFrame:CGRectMake(0, 0, 82, 82)];
    [_pickerView setDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];

    [self setupScrollView];
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
    NSInteger keyboardHeight = keyboardRect.size.height;
    CGPoint textOrigin = [_textView convertPoint:CGPointZero toView:_scrollView];
    [UIView animateWithDuration:animationDuration animations:^{
        [_scrollView setContentInset:UIEdgeInsetsMake(0, 0, keyboardHeight, 0)];
        [_scrollView setContentOffset:CGPointMake(0, textOrigin.y + _textView.height + keyboardHeight - _scrollView.height)];
    }completion:^(BOOL finished) {
    }];
}

- (void)onKeyboardHide:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration animations:^{
        [_scrollView setContentOffset:CGPointZero];
    }completion:^(BOOL finished) {
        [_scrollView setContentInset:UIEdgeInsetsZero];
    }];
}

- (void)setupScrollView
{
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSInteger width = _scrollView.width - kBorderMargin * 2;
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(kBorderMargin, kBorderMargin, width, width)];
    [_scrollView addSubview:_bgView];
    
    [self setupImageView];
    
    _textView = [[UTPlaceholderTextView alloc] initWithFrame:CGRectMake(kBorderMargin, _bgView.bottom + 20, _bgView.width, 60)];
    [_textView setReturnKeyType:UIReturnKeyDone];
    [_textView setFont:[UIFont systemFontOfSize:16]];
    [_textView setDelegate:self];
    [_textView setPlaceholder:@"我用连枝分享了这些照片，快来点击查看吧"];
    [_scrollView addSubview:_textView];
    
    UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(kBorderMargin, _textView.bottom + 10, _textView.width, 1)];
    [sepLine setBackgroundColor:kCommonTeacherTintColor];
    [_scrollView addSubview:sepLine];
    
    _poiInfoView = [[PoiInfoView alloc] initWithFrame:CGRectMake(10, sepLine.bottom, _bgView.width, 40)];
    [_poiInfoView setParentVC:self];
    [_scrollView addSubview:_poiInfoView];
    
    _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendButton setFrame:CGRectMake(0, _poiInfoView.bottom, 30, 30)];
    [_sendButton setImage:[UIImage imageNamed:@"ControlDefault"] forState:UIControlStateNormal];
    [_sendButton setImage:[UIImage imageNamed:@"ControlSelectAll"] forState:UIControlStateSelected];
    [_sendButton addTarget:self action:@selector(onSendOptionClicked) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_sendButton];
    
    UILabel* optionLabel = [[UILabel alloc] initWithFrame:CGRectMake(_sendButton.right, _poiInfoView.bottom, _scrollView.width - _sendButton.right, 30)];
    [optionLabel setFont:[UIFont systemFontOfSize:14]];
    [optionLabel setText:@"发送图片通知给全班家长"];
    [optionLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
    [_scrollView addSubview:optionLabel];
    
    [_scrollView setContentSize:CGSizeMake(_scrollView.width, MAX(self.view.height - 64, _sendButton.bottom))];
}

- (void)setupImageView
{
    [_pickerView removeFromSuperview];
    [_imageItemViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_imageItemViewArray removeAllObjects];
    NSInteger innerMargin = 6;
    CGFloat width = (_bgView.width - innerMargin * 2) / 3;
    NSInteger num = 9;
    NSInteger row = MAX((num + 2) / 3, 1);
    for (NSInteger i = 0; i < num;i++)
    {
        NSInteger column = i % 3;
        row = i / 3;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake( column * (width + innerMargin) ,(width + innerMargin) * row, width, width)];
        [imageView setTag:kBaseTag + i];
        [imageView setUserInteractionEnabled:YES];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [imageView setClipsToBounds:YES];
        [imageView setBackgroundColor:[UIColor colorWithHexString:@"E6E6E6"]];
        [_bgView addSubview:imageView];
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
        [_pickerView setFrame:CGRectMake( column * (width + innerMargin),(width + innerMargin) * row, width, width)];
        [_bgView addSubview:_pickerView];
    }
}

- (void)onSendOptionClicked
{
    _sendButton.selected = !_sendButton.selected;
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

- (void)onSendClicked
{
    [self.view endEditing:YES];
    if(_imageArray.count == 0)
    {
        [ProgressHUD showHintText:@"你还没有选择照片"];
        return;
    }
    ClassZoneItem *item = [[ClassZoneItem alloc] init];
    [item setNewSent:YES];
    NSString *content = _textView.text;
    if(content.length == 0)
        content = _textView.placeholder;
    [item setContent:content];
    NSMutableArray *photos = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSInteger i = 0; i < [_imageArray count];i++) {
        PublishImageItem *imageItem = _imageArray[i];
        [imageItem setPhotoKey:[NSString stringWithFormat:@"picture_%ld",(long)i]];
        
        PhotoItem *photoItem = [[PhotoItem alloc] init];
        [photoItem setImage:imageItem.image];
        [photoItem setThumbnailUrl:imageItem.thumbnailUrl];
        [photoItem setOriginalUrl:imageItem.originalUrl];
        [photoItem setPublishImageItem:imageItem];
        [photos addObject:photoItem];
    }
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    POIItem *poiItem = _poiInfoView.poiItem;
    if(!poiItem.clearLocation)
    {
        [item setPosition:poiItem.poiInfo.name];
    }
    [item setTime:[formatter stringFromDate:date]];
    [item setPhotos:photos];
    [item setUserInfo:[UserCenter sharedInstance].userInfo];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if(!poiItem.clearLocation)
    {
        [params setValue:poiItem.poiInfo.name forKey:@"position"];
    }
    [params setValue:self.classInfo.classID forKey:@"class_id"];
    [params setValue:kStringFromValue([[NSDate date] timeIntervalSince1970]) forKey:@"onlywifi_time"];
    [params setValue:kStringFromValue(_sendButton.selected) forKey:@"send_notice"];
    [item setParams:params];
    
    if([self.delegate respondsToSelector:@selector(publishZoneItemFinished:)])
        [self.delegate publishZoneItemFinished:item];
    [self onBack];
    return;
}

#pragma mark - PhotoPickerDelegate
- (void)photoPickerDidSelectAlbum:(PhotoPickerView *)picker
{
    [self.view endEditing:YES];
    PhotoPickerVC *photoPickerVC = [[PhotoPickerVC alloc] init];
    [photoPickerVC setMaxToSelected:9 - _imageArray.count];
    [photoPickerVC setDelegate:self];
    UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:photoPickerVC];
    [self presentViewController:navigationVC animated:YES completion:nil];
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
    [self setupScrollView];
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
        [self setupScrollView];

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


#pragma mark - UItextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
