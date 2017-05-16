//
//  PublishPhotoVC.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/19.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "PublishPhotoVC.h"
#import "TreeHousePublishManager.h"
#define kBorderMargin                   16
#define kMaxPhotoNum                    15
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
    
    [_imageArray addObjectsFromArray:self.originalImageArray];
    _scrollView = [[UITouchScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    [_scrollView setBounces:YES];
    [_scrollView setAlwaysBounceVertical:YES];
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_scrollView];
    
    _pickerView = [[PhotoPickerView alloc] initWithFrame:CGRectMake(0, 0, 82, 82)];
    [_pickerView setDelegate:self];

    [self setupScrollView];
}

- (void)setupScrollView
{
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSInteger width = _scrollView.width - kBorderMargin * 2;
    CGFloat spaceYStart = kBorderMargin;
    _textView = [[UTPlaceholderTextView alloc] initWithFrame:CGRectMake(kBorderMargin, spaceYStart, width, 100)];
    [_textView setBackgroundColor:[UIColor colorWithHexString:@"ebebeb"]];
    [_textView.layer setCornerRadius:10];
    [_textView.layer setMasksToBounds:YES];
    [_textView setReturnKeyType:UIReturnKeyDone];
    [_textView setFont:[UIFont systemFontOfSize:14]];
    [_textView setDelegate:self];
    [_textView setPlaceholder:[NSString stringWithFormat:@"快为%@记录下美好时光",[UserCenter sharedInstance].curChild.name]];
    [_textView setText:self.words];
    [_scrollView addSubview:_textView];
    
    spaceYStart = _textView.bottom;
    
    _poiInfoView = [[PoiInfoView alloc] initWithFrame:CGRectMake(kBorderMargin, spaceYStart, width, 40)];
    [_poiInfoView setParentVC:self];
    if(self.poiItem)
        [_poiInfoView setPoiItem:self.poiItem];
    [_scrollView addSubview:_poiInfoView];
    
    spaceYStart = _poiInfoView.bottom + 5;
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(kBorderMargin, spaceYStart, width, width)];
    [_scrollView addSubview:_bgView];
    
    [self setupImageView];
    spaceYStart = _bgView.bottom + kBorderMargin;
    
    [_scrollView setContentSize:CGSizeMake(_scrollView.width, MAX(self.view.height - 64, spaceYStart))];
}

- (void)setupImageView
{
    [_pickerView removeFromSuperview];
    [_imageItemViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_imageItemViewArray removeAllObjects];
    NSInteger innerMargin = 6;
    CGFloat width = (_bgView.width - innerMargin * 2) / 3;
    NSInteger num = kMaxPhotoNum;
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
        [_bgView setHeight:imageView.bottom + innerMargin];
    }
    if(_imageArray.count < kMaxPhotoNum)
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
    [item setCanEdit:YES];
    NSMutableArray *photos = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSInteger i = 0; i < [_imageArray count];i++) {
        PublishImageItem *imageItem = _imageArray[i];
        [imageItem setPhotoKey:[NSString stringWithFormat:@"picture_%ld",(long)i]];
        
        PhotoItem *photoItem = [[PhotoItem alloc] init];
        UIImage *sourceImage = imageItem.image;
        if(sourceImage == nil)
        {
            sourceImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageItem.thumbnailUrl];
        }
        [photoItem setImage:sourceImage];
        [photoItem setPhotoID:imageItem.photoID];
        [photoItem setSmall:imageItem.thumbnailUrl];
        [photoItem setBig:imageItem.originalUrl];
        [photoItem setPublishImageItem:imageItem];
        [photos addObject:photoItem];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    POIItem *poiItem = _poiInfoView.poiItem;
    if(!poiItem.clearLocation)
    {
        [params setValue:poiItem.poiInfo.name forKey:@"position"];
    }
    [params setValue:kStringFromValue(self.forward) forKey:@"forward"];
    [params setValue:kStringFromValue((NSInteger)[[NSDate date] timeIntervalSince1970]) forKey:@"onlywifi_time"];
    [item setParams:params];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    if(!poiItem.clearLocation)
    {
        [item setPosition:poiItem.poiInfo.name];
    }
    [item setTime:[formatter stringFromDate:date]];
    [item setPhotos:photos];
    NSString *detail = _textView.text;
    if(detail.length == 0)
        detail = _textView.placeholder;
    [item setDetail:detail];
    [item setUser:[UserCenter sharedInstance].userInfo];
    [item setNewSend:YES];
//    if([self.delegate respondsToSelector:@selector(publishTreeHouseSuccess:)])
//        [self.delegate publishTreeHouseSuccess:item];
    [[TreeHousePublishManager sharedInstance] startUploading:item];
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
    PhotoPickerVC *photoPickerVC = [[PhotoPickerVC alloc] init];
    [photoPickerVC setMaxToSelected:kMaxPhotoNum - _imageArray.count];
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
    [self setupImageView];
}

- (void)photoPickerVCDidCancel:(PhotoPickerVC *)photoPickerVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if(_imageArray.count == kMaxPhotoNum)
    {
        TNButtonItem *item = [TNButtonItem itemWithTitle:@"确定" action:^{
            
        }];
        TNAlertView *alertView  = [[TNAlertView alloc] initWithTitle:[NSString stringWithFormat:@"最多发%zd张照片",kMaxPhotoNum] buttonItems:@[item]];
        [alertView show];
    }
    else
    {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        image = [image formatImage];
        PublishImageItem *imageItem = [[PublishImageItem alloc] init];
        [imageItem setImage:image];
        [_imageArray addObject:imageItem];
        [self setupImageView];
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

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UItextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    self.words = textView.text;
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
