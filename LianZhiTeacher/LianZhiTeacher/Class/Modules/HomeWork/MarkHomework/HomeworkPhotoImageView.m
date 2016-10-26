//
//  HomeworkPhotoImageView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/22.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkPhotoImageView.h"
#import "HomeworkMarkFooterView.h"

@interface HomeworkMarkItemView ()
@property (nonatomic, assign)CGSize parentSize;
@end

@implementation HomeworkMarkItemView

- (instancetype)initWithMark:(HomeworkPhotoMark *)photoMark parentSize:(CGSize)parentSize{
    self = [super initWithFrame:CGRectZero];
    if(self){
        self.photoMark = photoMark;
        self.parentSize = parentSize;
        NSString *markStr = nil;
        if(self.photoMark.markType == MarkTypeRight){
            markStr = @"rightMark";
        }
        else if(self.photoMark.markType == MarkTypeHalfRight){
            markStr = @"halfMark";
        }
        else if(self.photoMark.markType == MarkTypeWrong){
            markStr = @"wrongMark";
        }
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:markStr]];
        [self addSubview:imageView];
        
        [self setSize:imageView.size];
        [self setCenter:CGPointMake(parentSize.width * photoMark.x, parentSize.height * photoMark.y)];
        
        UIButton* deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteButton setFrame:CGRectMake(self.width - 10, 0, 10, 10)];
        [deleteButton setBackgroundColor:[UIColor redColor]];
        [deleteButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(onDelete) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteButton];
    }
    return self;
}

- (void)onDelete{
    if(self.deleteCallback){
        self.deleteCallback();
    }
}

@end

@interface HomeworkPhotoImageView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong)NSMutableArray* markViewArray;
@property (nonatomic) CGFloat maximumDoubleTapZoomScale;
- (void)handleDoubleTap:(CGPoint)touchPoint;
@end

@implementation HomeworkPhotoImageView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        //
        // Image view
        _photoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_photoImageView setUserInteractionEnabled:YES];
        _photoImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_photoImageView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageViewTap:)];
        [_photoImageView addGestureRecognizer:tapGesture];
        
        // Setup
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    return self;
}


- (void)setMarkItem:(HomeworkMarkItem *)markItem{
    _markItem = markItem;
    [_photoImageView setImage:nil];
    [self displayImage];
    [self setupMarks];
}


- (void)prepareForReuse {
    self.markItem = nil;
}

- (NSMutableArray *)markViewArray{
    if(_markViewArray == nil){
        _markViewArray = [[NSMutableArray alloc] init];
    }
    return _markViewArray;
}

#pragma mark - Image

// Get and display image
- (void)displayImage {
    if (self.markItem) {
        // Reset
        self.maximumZoomScale = 1;
        self.minimumZoomScale = 1;
        self.zoomScale = 1;
        
        self.contentSize = CGSizeMake(0, 0);
        
        CGSize size;
        CGFloat width = self.markItem.picture.width;
        CGFloat height = self.markItem.picture.height;
        if(width / height > self.width / self.height){
            size = CGSizeMake(self.width, self.width * height / width);
        }
        else{
            size = CGSizeMake(self.height * width / height, self.height);
        }
        CGRect photoImageViewFrame;
        photoImageViewFrame.origin = CGPointZero;
        photoImageViewFrame.size = size;
        
        _photoImageView.frame = photoImageViewFrame;
        self.contentSize = photoImageViewFrame.size;
        
        [_photoImageView sd_setImageWithURL:[NSURL URLWithString:self.markItem.picture.big]];
//        [_photoImageView sd_setImageWithURL:[NSURL URLWithString:@"http://img6.bdstatic.com/img/image/smallpic/bizhi1020.jpg"]];
        // Set zoom to minimum zoom
        [self setMaxMinZoomScalesForCurrentBounds];
        
        [self setNeedsLayout];
    }
    else{
        
    }
}

- (void)setupMarks{
    [self.markViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.markViewArray removeAllObjects];
    for (HomeworkPhotoMark *mark in self.markItem.marks) {
        NSString *markStr = nil;
        if(mark.markType == MarkTypeRight){
            markStr = @"rightMark";
        }
        else if(mark.markType == MarkTypeHalfRight){
            markStr = @"halfMark";
        }
        else if(mark.markType == MarkTypeWrong){
            markStr = @"wrongMark";
        }
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:markStr]];
        [imageView setCenter:CGPointMake(mark.x * _photoImageView.width, mark.y * _photoImageView.height)];
        [self.markViewArray addObject:imageView];
        [_photoImageView addSubview:imageView];
    }
}

- (void)addMark:(HomeworkPhotoMark *)mark{
    __weak typeof(self) wself = self;
    HomeworkMarkItemView *markItemView = [[HomeworkMarkItemView alloc] initWithMark:mark parentSize:_photoImageView.size];
    [markItemView setDeleteCallback:^{
        [wself removeMark:mark];
    }];
//    [markItemView setCenter:CGPointMake(_photoImageView.width * mark.x, _photoImageView.height * mark.y)];
    [self.markViewArray addObject:markItemView];
    [_photoImageView addSubview:markItemView];
    [self.markItem.marks addObject:mark];
}

- (void)removeMark:(HomeworkPhotoMark *)mark{
    for (HomeworkMarkItemView *itemView in self.markViewArray) {
        if(itemView.photoMark == mark){
            [itemView removeFromSuperview];
            [self.markViewArray removeObject:itemView];
            [self.markItem.marks removeObject:mark];
            break;
        }
    }
}

#pragma mark - Setup

- (void)setMaxMinZoomScalesForCurrentBounds {
    // Reset
    self.maximumZoomScale = 1;
    self.minimumZoomScale = 1;
    self.zoomScale = 1;

    
    // Sizes
    CGSize boundsSize = self.bounds.size;
    boundsSize.width -= 0.1;
    boundsSize.height -= 0.1;
    
    CGSize imageSize = _photoImageView.frame.size;
    
    // Calculate Min
    CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
    CGFloat minScale = MIN(xScale, yScale);                 // use minimum of these to allow the image to become fully visible
    
    // If image is smaller than the screen then ensure we show it at
    // min scale of 1
    if (xScale > 1 && yScale > 1) {
        //minScale = 1.0;
    }
    
    // Calculate Max
    CGFloat maxScale = 4.0; // Allow double scale
    // on high resolution screens we have double the pixel density, so we will be seeing every pixel if we limit the
    // maximum zoom scale to 0.5.
    if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
        maxScale = maxScale / [[UIScreen mainScreen] scale];
        
        if (maxScale < minScale) {
            maxScale = minScale * 2;
        }
    }
    
    // Calculate Max Scale Of Double Tap
    CGFloat maxDoubleTapZoomScale = 4.0 * minScale; // Allow double scale
    // on high resolution screens we have double the pixel density, so we will be seeing every pixel if we limit the
    // maximum zoom scale to 0.5.
    if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
        maxDoubleTapZoomScale = maxDoubleTapZoomScale / [[UIScreen mainScreen] scale];
        
        if (maxDoubleTapZoomScale < minScale) {
            maxDoubleTapZoomScale = minScale * 2;
        }
    }
    
    // Set
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
    NSLog(@"max scale is %f, min scale is %f",maxScale, minScale);
    self.zoomScale = minScale;
    self.maximumDoubleTapZoomScale = maxDoubleTapZoomScale;
    
    // Reset position
    _photoImageView.frame = CGRectMake(0, 0, _photoImageView.frame.size.width, _photoImageView.frame.size.height);
    [self setNeedsLayout];
}

#pragma mark - Layout

- (void)layoutSubviews {
    
    // Super
    [super layoutSubviews];
    
    // Center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = _photoImageView.frame;
    
    // Horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
    } else {
        frameToCenter.origin.x = 0;
    }
    
    // Vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
    } else {
        frameToCenter.origin.y = 0;
    }
    
    // Center
    if (!CGRectEqualToRect(_photoImageView.frame, frameToCenter))
        _photoImageView.frame = frameToCenter;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _photoImageView;
}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - Tap Detection

- (void)handleDoubleTap:(CGPoint)touchPoint {
    
    
    // Zoom
    if (self.zoomScale == self.maximumZoomScale) {
        
        // Zoom out
        [self setZoomScale:self.minimumZoomScale animated:YES];
        
    } else {
        
//        // Zoom in
//        CGSize targetSize = CGSizeMake(self.frame.size.width / self.maximumDoubleTapZoomScale, self.frame.size.height / self.maximumDoubleTapZoomScale);
//        CGPoint targetPoint = CGPointMake(touchPoint.x - targetSize.width / 2, touchPoint.y - targetSize.height / 2);
        
        [self zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
        
    }
    
}


- (void)onImageViewTap:(UITapGestureRecognizer *)tapGesture{
    CGPoint location = [tapGesture locationInView:_photoImageView];
    if([HomeworkMarkFooterView currentMarkType] != MarkTypeNone){
        HomeworkPhotoMark *mark = [[HomeworkPhotoMark alloc] init];
        [mark setX:location.x / _photoImageView.width];
        [mark setY:location.y / _photoImageView.height];
        [mark setMarkType:[HomeworkMarkFooterView currentMarkType]];
        [self addMark:mark];
    }
}

@end

