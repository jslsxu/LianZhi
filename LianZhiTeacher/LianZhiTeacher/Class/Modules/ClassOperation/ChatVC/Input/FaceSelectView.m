//
//  FaceSelectView.m
// MFWIOS
//
//  Created by dong jianbo on 12-5-25.
//  Copyright 2010 mafengwo. All rights reserved.
//

#import "FaceSelectView.h"
#import "MFWFace.h"

#define ROWPERPAGE          4
#define FACERECTHEIGHT      38
#define FACERECTWIDTH       40.0
#define PAGECONTROL_HEIGHT  20.0 

//*********************************************************************************
// CustomFaceSelectView
@implementation CustomFaceSelectView

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self)
    {
		_originFrameWidth = frame.size.width;
		_faceRectWidth = FACERECTWIDTH;
		_faceRectHeight = FACERECTHEIGHT;
		
		frame.size.width = [self getViewWidth];
		self.frame = frame;
		
		self.contentMode = UIViewContentModeRedraw;
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}



-(CGFloat) getViewWidth
{
	int facePerPage = (_originFrameWidth / _faceRectWidth * ROWPERPAGE)-1;
	return ([MFWFace numberOfFace]/facePerPage + 1 ) * _originFrameWidth;
}


-(void)reset
{
	CGRect frame = self.superview.frame;
	_originFrameWidth = self.superview.frame.size.width;
	frame.size.width = [self getViewWidth];	
	self.frame = frame;
	[self setNeedsDisplay];
}

- (void)drawFace
{
    NSInteger imageNum = 0;
    imageNum = [MFWFace numberOfFace];
	
	int itemPerPage = _originFrameWidth / _faceRectWidth * ROWPERPAGE;
	int facePerRoW = itemPerPage / ROWPERPAGE;		
    
	//表情图标在资源文件中的大小和所在模块	
	for(int i=0;i<imageNum;i++)
	{
		//图片在视图中的位置
		int page = i/(itemPerPage-1);
        int pos = i%(itemPerPage-1);
		int row = pos%facePerRoW;
		int colum = pos/facePerRoW;
        
        UIImage* face = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",i]];
        CGRect rc = CGRectZero;
//        if(i >= 24 && i <= 30)
//        {
//            int faceWidth = face.size.width;
//            int faceHeight = face.size.height;
//            rc = CGRectMake((int)(_originFrameWidth * page + _faceRectWidth * row + (_faceRectWidth - faceWidth)/2.0),
//                            (int)(_faceRectHeight * colum + (_faceRectHeight - faceHeight) / 2.0) + 4, faceWidth, faceHeight);
//        }
//        else
//        {
            int faceWidth = 30;
            int faceHeight = 30;
            rc = CGRectMake((int)(_originFrameWidth * page + _faceRectWidth * row + (_faceRectWidth - faceWidth)/2.0),
                               (int)(_faceRectHeight * colum + (_faceRectHeight - faceHeight) / 2.0) + 4,
                               faceWidth, 
                               faceHeight);
            
//        }
        [face drawInRect:rc];
	}
}

- (void)drawRect:(CGRect)rect {
	CGContextRef contextRef = UIGraphicsGetCurrentContext();
	
	//画最上边的一条线
	float starty = rect.origin.y+1;
	CGContextSetRGBFillColor(contextRef, 0x99/255.0, 0x99/255.0, 0x99/255.0, 1);
    CGContextFillRect(contextRef,CGRectMake(rect.origin.x, starty, rect.size.width, 1));
	starty+=1;
    
	// 渐变色， 从上到下，由浅到深
	float startR = 0xFA/255.0;
	float startG = 0xFA/255.0;
	float startB = 0xFA/255.0;
    
    int times = (rect.origin.y+rect.size.height-starty)/4;
    float step = (0xD3-0xFA)/255.0/times;
	while( starty<=rect.origin.y+rect.size.height )
	{
		CGContextSetRGBFillColor(contextRef, startR, startG, startB, 1);
		CGContextFillRect(contextRef,CGRectMake(rect.origin.x, starty, rect.size.width, 4));
		starty += 4;
		startR += step;
		startG += step;
		startB += step;
	}
	
    [self drawFace];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (NSString*)getStringFroIndex:(int)index
{
    NSString* faceStr = [MFWFace faceStringForIndex:index];
    if (faceStr) {
        faceStr = [NSString stringWithFormat:@"%@%@%@",EXP_FACE_BEGIN, faceStr, EXP_FACE_END];
    }
    
    return faceStr;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint touchPoint = [touch locationInView:self];
	
	int pointx = touchPoint.x;
	int pointy = touchPoint.y - 4;
	
	int page = pointx / _originFrameWidth;
	int row = pointy / _faceRectHeight;
	int colum = pointx % _originFrameWidth / _faceRectWidth;
	
	if( row >= ROWPERPAGE )
    {
        return;   
    }
    
	int facePerPage = _originFrameWidth / _faceRectWidth * ROWPERPAGE;
	int facePerRow = facePerPage / ROWPERPAGE;
	
    if (row == ROWPERPAGE-1 && colum == facePerRow-1)
    {
        return;
    }
    
    int index = page*(facePerPage-1)  + row * facePerRow + colum;
	NSString *imageString = [self getStringFroIndex:index];
    if (imageString != nil)
    {
        [_delegate ContentActionInput_FaceSelect:imageString];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

@end



//*********************************************************************************
// CustomFaceSelectView
@interface FaceSelectView()
- (void) doBackward:(id)sender;
@end

@implementation FaceSelectView
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
		[self setBackgroundColor:[UIColor redColor]];
        
		CGRect subFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
		_scrollViewFace = [[UIScrollView alloc] initWithFrame:subFrame];
		_scrollViewFace.pagingEnabled = YES;
		_scrollViewFace.indicatorStyle = UIScrollViewIndicatorStyleWhite;
		_scrollViewFace.clipsToBounds = YES;
        [_scrollViewFace setScrollsToTop:NO];
		
		_customFaceSelectView = [[CustomFaceSelectView alloc] initWithFrame:subFrame];
		[_scrollViewFace addSubview:_customFaceSelectView];
		_scrollViewFace.contentSize = _customFaceSelectView.frame.size;
		_scrollViewFace.delegate = self;
		_scrollViewFace.showsVerticalScrollIndicator = NO;
		_scrollViewFace.showsHorizontalScrollIndicator = NO;
        _scrollViewFace.bounces = NO;
		[self addSubview:_scrollViewFace];
		
		CGRect pageFrame = CGRectMake(subFrame.origin.x, 
									  subFrame.origin.y + subFrame.size.height - PAGECONTROL_HEIGHT - 3, 
									  subFrame.size.width, 
									  PAGECONTROL_HEIGHT);
		
		_pageControl = [[UIPageControl alloc] initWithFrame:pageFrame]; 
		_pageControl.numberOfPages = 4;
        [_pageControl setUserInteractionEnabled:NO];
        //[_pageControl addTarget:self action:@selector(pageControlTapped) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:_pageControl];
        
        UIImage *btnImage = [UIImage imageNamed:@"btn_comment_face_del@2x.png"];
        _deleteBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(276, 117, 44, 44)];
        [_deleteBtn1 setBackgroundImage:btnImage forState:UIControlStateNormal];
        [_deleteBtn1 addTarget:self action:@selector(doBackward:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteBtn1];
        
        _deleteBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(276, 117, 44, 44)];
        [_deleteBtn2 setBackgroundImage:[UIImage imageNamed:@"btn_comment_face_del@2x.png"] forState:UIControlStateNormal];
        [_deleteBtn2 addTarget:self action:@selector(doBackward:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteBtn2];
        
		[self reset];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)pageControlTapped
{
    CGRect frame = [_scrollViewFace frame];
    NSInteger curPage = [_pageControl currentPage];
    if(curPage < 0 || curPage > _pageControl.numberOfPages - 1)
        return;
    [_scrollViewFace setContentOffset:CGPointMake(curPage * frame.size.width, 0) animated:YES];
}

-(void) needOritation:(UIInterfaceOrientation)interfaceOrientation
{
	CGRect currentFrame = CGRectMake(0, 
									 0, 
									 self.superview.frame.size.width, 
									 self.superview.frame.size.height);
	self.frame = currentFrame;
	_scrollViewFace.frame = currentFrame;
	[self reset];
	
}

-(void)doBackward:(id)sender
{
    [_customFaceSelectView.delegate ContentActionInput_BackWord];
}

-(void)reset
{
	[_customFaceSelectView reset];
	_scrollViewFace.contentSize = _customFaceSelectView.frame.size;
	_pageControl.numberOfPages = _scrollViewFace.contentSize.width / _scrollViewFace.frame.size.width;
    _pageControl.currentPage = _scrollViewFace.contentOffset.x / _scrollViewFace.frame.size.width;
    [_pageControl setNeedsDisplay];
}

-(void)setDelegate:(id<ContentActionInputDelegate>)delegate
{
    _customFaceSelectView.delegate = delegate;
}

-(id<ContentActionInputDelegate>)delegate
{
    return _customFaceSelectView.delegate;
}


#pragma mark -
#pragma mark scrollView delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if( !decelerate )
	{
		int offsetX = scrollView.contentOffset.x;
		_pageControl.currentPage = offsetX / scrollView.frame.size.width;
        [_pageControl setNeedsDisplay];
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	int offsetX = scrollView.contentOffset.x;
	_pageControl.currentPage = offsetX / scrollView.frame.size.width;
    [_pageControl setNeedsDisplay];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int x = scrollView.contentOffset.x;
    int page = x/scrollView.frame.size.width;
    _deleteBtn1.frame = CGRectMake(page*scrollView.frame.size.width+276-x, 117, _deleteBtn1.frame.size.width, _deleteBtn1.frame.size.height);
    _deleteBtn2.frame = CGRectMake((page+1)*scrollView.frame.size.width+276-x, 117, _deleteBtn2.frame.size.width, _deleteBtn2.frame.size.height);
}
@end




