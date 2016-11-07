//
//  HomeworkReplyView.m
//  LianZhiParent
//
//  Created by qingxu zhou on 16/10/14.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkReplyView.h"
#import "HomeworkReplyAlertView.h"
#import "DNImagePickerController.h"
@interface HomeworkPhotoItemView ()
@property (nonatomic, strong)UIImageView*   imageView;
@property (nonatomic, strong)UIButton*      removeButton;
@end

@implementation HomeworkPhotoItemView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [self.imageView setClipsToBounds:YES];
        [self addSubview:self.imageView];
        
        self.removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.removeButton setFrame:CGRectMake(self.width - 26, 0, 26, 26)];
        [self.removeButton setImage:[UIImage imageNamed:@"homeworkDeletePhoto"] forState:UIControlStateNormal];
        [self.removeButton addTarget:self action:@selector(onRemoveButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.removeButton];

    }
    return self;
}

- (void)setPhotoItem:(PhotoItem *)photoItem
{
    _photoItem = photoItem;
    if(_photoItem.isLocal){
        NSData *data = [NSData dataWithContentsOfFile:_photoItem.big];
        [self.imageView setImage:[UIImage imageWithData:data]];
    }
    else{
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:_photoItem.big]];
    }
}

- (void)onRemoveButtonClicked{
    if(self.deleteCallback){
        self.deleteCallback();
    }
}

@end

@interface HomeworkReplyView ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, DNImagePickerControllerDelegate>
@property (nonatomic, strong)UIScrollView*  scrollView;
@property (nonatomic, strong)NSMutableArray *photoArray;
@property (nonatomic, strong)UIView*        contentView;
@end

@implementation HomeworkReplyView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.photoArray = [NSMutableArray array];
        
        UIView* sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 10 - 36 - 10, self.width, kLineHeight)];
        [sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:sepLine];
        
        UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendButton setFrame:CGRectMake(10, self.height - 10 - 36, self.width - 10 * 2, 36)];
        [sendButton setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
        [sendButton addTarget:self action:@selector(onSend) forControlEvents:UIControlEventTouchUpInside];
        [sendButton setBackgroundImage:[UIImage imageWithColor:kCommonParentTintColor size:sendButton.size cornerRadius:3] forState:UIControlStateNormal];
        [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sendButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [sendButton setTitle:@"回复作业" forState:UIControlStateNormal];
        [self addSubview:sendButton];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height - 10 - 36 - 10)];
        [_scrollView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [_scrollView setAlwaysBounceVertical:YES];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [self addSubview:_scrollView];
        
        [_scrollView addSubview:[self contentView]];
        
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.width - 10 * 2, 0)];
        [titleLabel setFont:[UIFont systemFontOfSize:15]];
        [titleLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
        [titleLabel setText:@"给教师发送图片"];
        [titleLabel sizeToFit];
        [self addSubview:titleLabel];
        
        UILabel* descriptionlabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [descriptionlabel setFont:[UIFont systemFontOfSize:12]];
        [descriptionlabel setText:@"请保持图片清晰，方便老师解答难题"];
        [descriptionlabel sizeToFit];
        [descriptionlabel setOrigin:CGPointMake(10, titleLabel.bottom + 10)];
        [self addSubview:descriptionlabel];
        
        [self addSubview:[self contentView]];
        [self.contentView setOrigin:CGPointMake(0, descriptionlabel.bottom + 10)];
    }
    return self;
}

- (void)onSend{
    if([self.photoArray count] == 0){
        [ProgressHUD showHintText:@"请选择照片"];
        return;
    }
    __weak typeof(self) wself = self;
    [HomeworkReplyAlertView showAlertViewWithCompletion:^{
        [wself replyHomework];
    }];
    
}

- (void)replyHomework{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    __weak typeof(self) wself = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.homeworkItem.eid forKey:@"eid"];
    NSMutableString *picStr = [NSMutableString string];
    for (NSInteger i = 0; i < [self.photoArray count]; i++) {
        if([picStr length] == 0){
            [picStr appendString:[NSString stringWithFormat:@"picture_%zd",i]];
        }
        else{
            [picStr appendString:[NSString stringWithFormat:@",picture_%zd",i]];
        }
    }
    [params setValue:picStr forKey:@"pic_seqs"];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"exercises/reply" withParams:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (NSInteger i = 0; i < [wself.photoArray count]; i++) {
            PhotoItem *photoItem = wself.photoArray[i];
            NSString *filename = [NSString stringWithFormat:@"picture_%zd",i];
            if(photoItem.photoID.length > 0){
                
            }
            else{
                NSData *data = [NSData dataWithContentsOfFile:photoItem.big];
                if(data.length > 0){
                    [formData appendPartWithFileData:data name:filename fileName:filename mimeType:@"image/jpeg"];
                }
            }
            
        }
    } completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        TNDataWrapper *dataWrapper = [responseObject getDataWrapperForKey:@"s_answer"];
        HomeworkStudentAnswer* sAnswer = [HomeworkStudentAnswer nh_modelWithJson:dataWrapper.data];
        [wself.homeworkItem setS_answer:sAnswer];
        [[NSNotificationCenter defaultCenter] postNotificationName:kHomeworkItemChangedNotification object:nil];
        [hud hide:NO];
    } fail:^(NSString *errMsg) {
        [hud hide:NO];
    }];
}

- (UIView *)contentView{
    if(_contentView == nil){
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0)];
        [self setupContentView];
    }
    return _contentView;
}

- (void)addPhoto{
    if([self.photoArray count] >= 9){
        [ProgressHUD showHintText:@"不能超过9张图"];
        return;
    }
    __weak typeof(self) wself = self;
    LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:nil message:nil style:LGAlertViewStyleActionSheet buttonTitles:@[@"拍照", @"从手机相册选择"] cancelButtonTitle:@"取消" destructiveButtonTitle:nil];
    [alertView setCancelButtonFont:[UIFont systemFontOfSize:18]];
    [alertView setButtonsTitleColor:kCommonParentTintColor];
    [alertView setButtonsTitleColorHighlighted:kCommonParentTintColor];
    [alertView setCancelButtonTitleColor:kCommonParentTintColor];
    [alertView setCancelButtonTitleColorHighlighted:kCommonParentTintColor];
    [alertView setButtonsBackgroundColorHighlighted:[UIColor colorWithHexString:@"eeeeee"]];
    [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"eeeeee"]];
    [alertView setActionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger position) {
        if(position == 0){
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            [imagePicker setDelegate:wself];
            [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
            [CurrentROOTNavigationVC presentViewController:imagePicker animated:YES completion:nil];
        }
        else{
            DNImagePickerController *imagePicker = [[DNImagePickerController alloc] init];
            [imagePicker setFilterType:DNImagePickerFilterTypePhotos];
            [imagePicker setImagePickerDelegate:self];
            [imagePicker setMaxImageCount:9 - [wself.photoArray count]];
            [CurrentROOTNavigationVC presentViewController:imagePicker animated:YES completion:nil];
        }
    }];
    [alertView showAnimated:YES completionHandler:nil];
}

- (void)addPhotos:(NSArray *)photoList{
    [self.photoArray addObjectsFromArray:photoList];
    [self setupContentView];
}

- (void)deletePhoto:(PhotoItem *)photoItem{
    [self.photoArray removeObject:photoItem];
    [self setupContentView];
}

- (void)setupContentView{
    [_contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSInteger margin = 10;
    NSInteger itemWidth = (_contentView.width - margin * 5) / 4;
    for (NSInteger i = 0; i < [self.photoArray count] + 1; i++) {
        NSInteger row = i / 4;
        NSInteger column = i % 4;
        CGRect frame = CGRectMake(margin + (itemWidth + margin) * column, margin + (itemWidth + margin) * row, itemWidth, itemWidth);
        if(i < [self.photoArray count]){
            PhotoItem *photoItem = self.photoArray[i];
            HomeworkPhotoItemView *itemView = [[HomeworkPhotoItemView alloc] initWithFrame:frame];
            [itemView setPhotoItem:photoItem];
            @weakify(self)
            [itemView setDeleteCallback:^{
                @strongify(self)
                [self deletePhoto:photoItem];
            }];
            [_contentView addSubview:itemView];
        }
        else{
            UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [addButton setBackgroundImage:[UIImage imageNamed:@"homeworkAddPhoto"] forState:UIControlStateNormal];
            [addButton addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
            [addButton setFrame:frame];
            [_contentView addSubview:addButton];
        }
        
    }
    NSInteger row = ([self.photoArray count]) / 4 + 1;
    [_contentView setHeight:margin + (itemWidth + margin) * row];
    [_scrollView setContentSize:CGSizeMake(_contentView.width, _contentView.bottom)];
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if(image){
        MBProgressHUD *hud = [MBProgressHUD showMessag:@"正在压缩" toView:[UIApplication sharedApplication].keyWindow];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *resultImage = [image aspectFit:CGSizeMake(kScreenWidth * 2, kScreenHeight * 2)];
            NSString *tmpImagePath = [NHFileManager getTmpImagePath];
            NSData *imageData = UIImageJPEGRepresentation(resultImage, 0.8);
            [imageData writeToFile:tmpImagePath atomically:YES];
            PhotoItem *photoItem = [[PhotoItem alloc] init];
            [photoItem setWidth:resultImage.size.width];
            [photoItem setHeight:resultImage.size.height];
            [photoItem setBig:tmpImagePath];
            [photoItem setSmall:tmpImagePath];
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide:YES];
                [self addPhotos:@[photoItem]];
            });
        });
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - DNImagePickerControllerDelegate
- (void)dnImagePickerController:(DNImagePickerController *)imagePicker sendImages:(NSArray *)imageAssets isFullImage:(BOOL)fullImage{
    if([imageAssets count] > 0){
        NSMutableArray *addImageArray = [NSMutableArray array];
        for (ALAsset *asset in imageAssets) {
            UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage] scale:1.f orientation:UIImageOrientationUp];
            if(image)
            {
                [addImageArray addObject:image];
            }
        }
        if(addImageArray.count > 0){
            MBProgressHUD *hud = [MBProgressHUD showMessag:@"正在压缩" toView:[UIApplication sharedApplication].keyWindow];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSMutableArray *photoItemArray = [NSMutableArray array];
                for (UIImage *image in addImageArray) {
                    NSString *tmpImagePath = [NHFileManager getTmpImagePath];
                    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
                    [imageData writeToFile:tmpImagePath atomically:YES];
                    PhotoItem *photoItem = [[PhotoItem alloc] init];
                    [photoItem setWidth:image.size.width];
                    [photoItem setHeight:image.size.height];
                    [photoItem setBig:tmpImagePath];
                    [photoItem setSmall:tmpImagePath];
                    [photoItemArray addObject:photoItem];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hide:YES];
                    [self addPhotos:photoItemArray];
                });
            });
        }

    }

    [imagePicker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)dnImagePickerControllerDidCancel:(DNImagePickerController *)imagePicker{
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}

@end
