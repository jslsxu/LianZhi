//
//  ChatFaceCell.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/1.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "ChatContentFaceView.h"
#define kFaceWith                   100
#define kFaceHeight                 80
@implementation ChatContentFaceView
- (instancetype)initWithModel:(MessageItem *)messageItem maxWidth:(CGFloat)maxWidth{
    self = [super init];
    if(self){
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_imageView setContentMode:UIViewContentModeCenter];
        [self addSubview:_imageView];
    }
    return self;
}

- (void)setMessageItem:(MessageItem *)messageItem{
    _messageItem = messageItem;
    NSString *faceText = messageItem.content.text;
    NSInteger index = [MFWFace indexForFace:faceText];
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"biaoqing%ld",(long)(index + 1)]];
    CGSize imageSize = image.size;
    CGSize targetSize;
    if(imageSize.height > kFaceHeight){
        targetSize = CGSizeMake(kFaceHeight * imageSize.width / imageSize.height, kFaceHeight);
    }
    else{
        targetSize = imageSize;
    }
    [_imageView setImage:image];
    [_imageView setSize:targetSize];
    [self setSize:targetSize];
}

+ (CGFloat)contentHeightForModel:(MessageItem *)messageItem maxWidth:(CGFloat)maxWidth{
    NSString *faceText = messageItem.content.text;
    NSInteger index = [MFWFace indexForFace:faceText];
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"biaoqing%ld",(long)(index + 1)]];
    CGSize imageSize = image.size;
    CGSize targetSize;
    if(imageSize.height > kFaceHeight){
        targetSize = CGSizeMake(kFaceHeight * imageSize.width / imageSize.height, kFaceHeight);
    }
    else{
        targetSize = imageSize;
    }
    return targetSize.height;
}

@end
