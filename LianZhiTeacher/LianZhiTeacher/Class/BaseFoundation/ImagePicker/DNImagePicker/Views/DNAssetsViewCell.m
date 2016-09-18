//
//  DNAssetsViewCell.m
//  ImagePicker
//
//  Created by DingXiao on 15/2/11.
//  Copyright (c) 2015年 Dennis. All rights reserved.
//

#import "DNAssetsViewCell.h"


@interface DNAssetsViewCell ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *videoIndicator;
@property (nonatomic, strong) UILabel*  durationLabel;
@property (nonatomic, strong) UIButton *checkButton;
@property (nonatomic, strong) UIImageView *checkImageView;

- (IBAction)checkButtonAction:(id)sender;

@end

@implementation DNAssetsViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self imageView];
        [self checkButton];
        [self checkImageView];
    }
    return self;
}

- (void)fillWithAsset:(ALAsset *)asset isSelected:(BOOL)seleted
{
    self.isSelected = seleted;
    self.asset = asset;
    CGImageRef thumbnailImageRef = [asset thumbnail];
    if (thumbnailImageRef) {
        self.imageView.image = [UIImage imageWithCGImage:thumbnailImageRef];
    } else {
        self.imageView.image = [UIImage imageNamed:@"assets_placeholder_picture"];
    }
    if([[asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]){
        [self.videoIndicator setHidden:YES];
        [self.durationLabel setHidden:YES];
    }
    else{
        [self.videoIndicator setHidden:NO];
        [self.durationLabel setHidden:NO];
        NSInteger duration = [[asset valueForProperty:ALAssetPropertyDuration] integerValue];
        [self.durationLabel setText:[Utility durationText:duration]];
        [self.durationLabel sizeToFit];
        [self.durationLabel setOrigin:CGPointMake(self.width - self.durationLabel.width - 3, self.height - self.durationLabel.height - 5)];
    }
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    self.checkButton.selected = _isSelected;
    [self updateCheckImageView];
}

- (void)updateCheckImageView
{
    if (self.checkButton.selected) {
        self.checkImageView.image = [UIImage imageNamed:@"photo_check_selected"];
        
        [UIView animateWithDuration:0.2 animations:^{
            self.checkImageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }
                         completion:^(BOOL finished){
                             [UIView animateWithDuration:0.2 animations:^{
                                 self.checkImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                             }];
                         }];
    } else {
        self.checkImageView.image = [UIImage imageNamed:@"photo_check_default"];
    }
}

- (void)checkButtonAction:(id)sender
{
    if (self.checkButton.selected) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didDeselectItemAssetsViewCell:)]) {
            [self.delegate didDeselectItemAssetsViewCell:self];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectItemAssetsViewCell:)]) {
            [self.delegate didSelectItemAssetsViewCell:self];
        }
    }
}

- (void)prepareForReuse
{
    _asset = nil;
    _isSelected = NO;
    _delegate = nil;
    _imageView.image = nil;
}

#pragma mark - Getter
- (UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [_imageView setClipsToBounds:YES];
        [_imageView setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (UIImageView *)videoIndicator{
    if(_videoIndicator == nil){
        _videoIndicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"video_type_white"]];
        [_videoIndicator setOrigin:CGPointMake(5, self.height - 5 - _videoIndicator.height)];
        [self addSubview:_videoIndicator];
    }
    return _videoIndicator;
}

- (UILabel *)durationLabel{
    if(_durationLabel == nil){
        _durationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_durationLabel setBackgroundColor:[UIColor clearColor]];
        [_durationLabel setFont:[UIFont systemFontOfSize:13]];
        [_durationLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:_durationLabel];
    }
    return _durationLabel;
}

- (UIButton *)checkButton
{
    if (_checkButton == nil) {
        _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkButton setFrame:CGRectMake(self.width - 30, 0, 30, 30)];
        [_checkButton addTarget:self action:@selector(checkButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_checkButton];
    }
    return _checkButton;
}

- (UIImageView *)checkImageView
{
    if (_checkImageView == nil) {
        _checkImageView = [UIImageView new];
        _checkImageView.contentMode = UIViewContentModeCenter;
        [_checkImageView setFrame:self.checkButton.frame];
        [self addSubview:_checkImageView];
    }
    return _checkImageView;
}

@end
