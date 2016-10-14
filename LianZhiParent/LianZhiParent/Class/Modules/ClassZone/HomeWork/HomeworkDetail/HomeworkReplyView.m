//
//  HomeworkReplyView.m
//  LianZhiParent
//
//  Created by qingxu zhou on 16/10/14.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkReplyView.h"

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
        [self.removeButton setFrame:CGRectMake(self.width - 30, 0, 30, 30)];
        [self.removeButton setImage:[UIImage imageNamed:@"media_delete"] forState:UIControlStateNormal];
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

@interface HomeworkReplyView ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong)NSMutableArray *photoArray;
@property (nonatomic, strong)UIView*        contentView;
@end

@implementation HomeworkReplyView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.photoArray = [NSMutableArray array];
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
        
        UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendButton setFrame:CGRectMake(10, self.height - 10 - 36, self.width - 10 * 2, 36)];
        [sendButton setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
        [sendButton addTarget:self action:@selector(onSend) forControlEvents:UIControlEventTouchUpInside];
        [sendButton setBackgroundImage:[UIImage imageWithColor:kCommonParentTintColor size:sendButton.size cornerRadius:3] forState:UIControlStateNormal];
        [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sendButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [sendButton setTitle:@"回复作业" forState:UIControlStateNormal];
        [self addSubview:sendButton];
    }
    return self;
}

- (void)onSend{
    
}

- (UIView *)contentView{
    if(_contentView == nil){
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0)];
        [self setupContentView];
    }
    return _contentView;
}

- (void)addPhoto{
    LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:nil message:nil style:LGAlertViewStyleActionSheet buttonTitles:@[@"拍照", @"从手机相册选择"] cancelButtonTitle:@"取消" destructiveButtonTitle:nil];
    [alertView setCancelButtonFont:[UIFont systemFontOfSize:18]];
    [alertView setButtonsTitleColor:kCommonParentTintColor];
    [alertView setButtonsTitleColorHighlighted:kCommonParentTintColor];
    [alertView setCancelButtonTitleColor:kCommonParentTintColor];
    [alertView setCancelButtonTitleColorHighlighted:kCommonParentTintColor];
    [alertView setButtonsBackgroundColorHighlighted:[UIColor colorWithHexString:@"eeeeee"]];
    [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"eeeeee"]];
    [alertView setActionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger position) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        [imagePicker setDelegate:self];
        if(position == 0){
            [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        }
        else if(position == 1){
            [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        [CurrentROOTNavigationVC presentViewController:imagePicker animated:YES completion:nil];
    }];
    [alertView showAnimated:YES completionHandler:nil];
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
            [addButton setBackgroundImage:[UIImage imageNamed:@"Icon"] forState:UIControlStateNormal];
            [addButton addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
            [addButton setFrame:frame];
            [_contentView addSubview:addButton];
        }
        
    }
    NSInteger row = ([self.photoArray count]) / 4 + 1;
    [_contentView setHeight:margin + (itemWidth + margin) * row];
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
