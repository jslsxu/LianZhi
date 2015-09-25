//
//  PublishPhotoVC.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/19.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "PublishPhotoVC.h"

#define kBorderMargin                   16

#define kBaseTag                        1000
@interface PublishPhotoVC ()<UITextFieldDelegate>

@end

@implementation PublishPhotoVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    [_scrollView setBounces:YES];
    [_scrollView setAlwaysBounceVertical:YES];
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
    [UIView animateWithDuration:animationDuration animations:^{
        [_scrollView setContentInset:UIEdgeInsetsMake(0, 0, keyboardRect.size.height, 0)];
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

- (void)setupScrollView
{
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSInteger width = _scrollView.width - kBorderMargin * 2;
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(kBorderMargin, kBorderMargin, width, width)];
    [_scrollView addSubview:_bgView];
    
    [self setupImageView];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, _bgView.bottom + 20, _bgView.width, 30)];
    [_textField setFont:[UIFont systemFontOfSize:16]];
    [_textField setDelegate:self];
    [_textField setPlaceholder:@"我发了一堆图片，快来看看吧"];
    [_scrollView addSubview:_textField];
    
    UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(10, _textField.bottom, _textField.width, 1)];
    [sepLine setBackgroundColor:kCommonParentTintColor];
    [_scrollView addSubview:sepLine];
    
    _poiInfoView = [[PoiInfoView alloc] initWithFrame:CGRectMake(10, sepLine.bottom, _bgView.width, 40)];
    [_poiInfoView setParentVC:self];
    [_scrollView addSubview:_poiInfoView];
    
    [_scrollView setContentSize:CGSizeMake(_scrollView.width, MAX(self.view.height - 64, _poiInfoView.bottom))];
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
    
    TreehouseItem *item = [[TreehouseItem alloc] init];
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
    [item setParams:@{@"onlywifi_time":kStringFromValue([[NSDate date] timeIntervalSince1970])}];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    POIItem *poiItem = _poiInfoView.poiItem;
    if(!poiItem.clearLocation)
    {
        [item setAddress:poiItem.poiInfo.name];
    }
    [item setTime:[formatter stringFromDate:date]];
    [item setPhotos:photos];
    [item setDetail:_textField.text];
    [item setUser:[UserCenter sharedInstance].userInfo];
    [item setNewSend:YES];
    if([self.delegate respondsToSelector:@selector(publishTreeHouseSuccess:)])
        [self.delegate publishTreeHouseSuccess:item];
    [self onBack];

//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setValue:_textView.text forKey:@"words"];
//    NSMutableString *picSeq = [[NSMutableString alloc] initWithCapacity:0];
//    for (NSInteger i = 0; i < [_imageArray count]; i++)
//    {
//        if(picSeq.length == 0)
//            [picSeq appendFormat:@"picture_%ld",(long)i];
//        else
//            [picSeq appendFormat:@",picture_%ld",(long)i];
//    }
//    [params setValue:picSeq forKey:@"pic_seqs"];
//    
//    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"tree/post_content" withParams:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        for (NSInteger i = 0; i < [_imageArray count]; i++) {
//            UIImage *image = [_imageArray objectAtIndex:i];
//            NSString *imageName = [NSString stringWithFormat:@"picture_%ld",(long)i];
//            [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.8) name:imageName fileName:imageName mimeType:@"image/jpeg"];
//        }
//    } completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
//        TNDataWrapper *infoWrapper = [responseObject getDataWrapperForKey:@"info"];
//        if(infoWrapper.count > 0)
//        {
//            TreehouseItem *zoneItem = [[TreehouseItem alloc] init];
//            [zoneItem parseData:infoWrapper];
//            
//            [MBProgressHUD showSuccess:@"发布成功" toView:self.view];
//            if([self.delegate respondsToSelector:@selector(publishTreeHouseSuccess:)])
//                [self.delegate publishTreeHouseSuccess:zoneItem];
//            
//            [self performSelector:@selector(cancel) withObject:nil afterDelay:2];
//        }
//        
//    } fail:^(NSString *errMsg) {
//        [MBProgressHUD showError:errMsg toView:self.view];
//    }];

}

#pragma mark - PhotoPickerDelegate
- (void)photoPickerDidSelectAlbum:(PhotoPickerView *)picker
{
    [self.view endEditing:YES];
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [imagePicker setDelegate:self];
    [self presentViewController:imagePicker animated:YES completion:nil];
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
        [self setupScrollView];
    }
    [self.navigationController popToRootViewControllerAnimated:NO];
    [picker dismissViewControllerAnimated:YES completion:^{
//        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self setNeedsStatusBarAppearanceUpdate];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self setNeedsStatusBarAppearanceUpdate];
    }];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@"\n"])
    {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
