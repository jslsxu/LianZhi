//
//  FaceSelectView.h
// MFWIOS
//
//  Created by dong jianbo on 12-5-25.
//  Copyright 2010 mafengwo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FACESELECT_HEIGHT   170

//*********************************************************************************
// ContentActionInputDelegate
@protocol ContentActionInputDelegate <NSObject>
@required
-(void)ContentActionInput_FaceSelect:(NSString*)face;
-(void)ContentActionInput_BackWord;
-(void)ContentActionInput_ReturnEntered;
@end

//*********************************************************************************
// CustomFaceSelectView
@interface CustomFaceSelectView : UIView {
    int                             _originFrameWidth;
}
@property (nonatomic, assign) id<ContentActionInputDelegate> delegate;
@property (readwrite) int faceRectHeight;
@property (readwrite) int faceRectWidth;

- (void) reset;
- (CGFloat) getViewWidth;

@end

//*********************************************************************************
// CustomFaceSelectView
@interface FaceSelectView : UIView <UIScrollViewDelegate>
{
	UIScrollView*           _scrollViewFace;
	UIPageControl*          _pageControl;
	CustomFaceSelectView*   _customFaceSelectView;
    UIButton*               _deleteBtn1;
    UIButton*               _deleteBtn2;
}

@property (nonatomic, assign) id<ContentActionInputDelegate> delegate;

- (id) initWithFrame:(CGRect)frame;
- (void) reset;
- (void) needOritation:(UIInterfaceOrientation)interfaceOrientation;

@end

