//
//  ExpLabel.m
// MFWIOS
//
//  Created by dong jianbo on 12-5-03.
//  Copyright (c) 2012年 mafengwo. All rights reserved.
//

#import "ExpLabel.h"

@implementation ExpLabel

-(id)initWithCoder:(NSCoder *)aDecoder{
	if(self = [super initWithCoder:aDecoder]){
		expText = [[ExpText alloc] init];
		expText.width = self.frame.size.width;
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		expText = [[ExpText alloc] init];
		expText.width = frame.size.width;
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)layoutSubviews{
	[super layoutSubviews];
	if(_autoHeight || _autoWidth){
		expText.width = self.frame.size.width;
		CGSize contentSize = [expText contentSize];

		if(!_autoWidth){
			contentSize.width = self.frame.size.width;
		}
		else if(contentSize.width !=0){
			contentSize.width += 2;
		}
		
		if(!_autoHeight){
			contentSize.height = self.frame.size.height;
		}
		else if(contentSize.height !=0){
			contentSize.height +=2;
		}
		
		if(contentSize.width != self.frame.size.width
		   || contentSize.height != self.frame.size.height){
			self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, contentSize.width, contentSize.height);
			[self.superview layoutSubviews];
		}
	}
}

-(void)drawTextInRect:(CGRect)rect{
	[expText drawRect:rect lineBreakMode:self.lineBreakMode textAlignment:self.textAlignment];
}

-(void)drawRect:(CGRect)rect{
	[super drawRect:rect];
}

-(ExpText *)expText{
	return expText;
}

-(void)setExpText:(ExpText *)inExpText{
    expText = inExpText;
	[super setFont:expText.textFont];
	[super setText:expText.text];
	if(super.highlighted){
		[expText setTextColor:super.highlightedTextColor];
	}
	else {
		[expText setTextColor:super.textColor];
	}
	if(_autoHeight || _autoWidth){
		[self setNeedsLayout];
	}
}

-(void)setHighlighted:(BOOL)highlighted{
	[super setHighlighted:highlighted];
	if(super.highlighted){
		[expText setTextColor:super.highlightedTextColor];
	}
	else {
		[expText setTextColor:super.textColor];
	}
}

-(void)setText:(NSString *)text{
	expText.text = text;
	[super setText:text];
	if(_autoHeight || _autoWidth){
		[self setNeedsLayout];
	}
}

-(void)setFont:(UIFont *)font{
	expText.textFont = font;
	expText.actionFont = font;
	[super setFont:font];
	if(_autoHeight || _autoWidth){
		[self setNeedsLayout];
	}
}

-(void)setTextColor:(UIColor *)color{
	[super setTextColor:color];
	if(super.highlighted){
		[expText setTextColor:super.highlightedTextColor];
	}
	else {
		[expText setTextColor:super.textColor];
	}
}


-(void)setHighlightedTextColor:(UIColor *)color{
	[super setHighlightedTextColor:color];
	if(super.highlighted){
		[expText setTextColor:super.highlightedTextColor];
	}
	else {
		[expText setTextColor:super.textColor];
	}
}
@end


@implementation ExpSrcollLabel


-(id)initWithCoder:(NSCoder *)aDecoder
{	
    self = [super initWithCoder:aDecoder];
    if(self)
    {
		animationTimer = nil;
		need_check = true;
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
    {
		animationTimer = nil;
		need_check = true;
    }
    return self;
}

-(void)checkNeedsSrcoll{
	
	if (expText.contentSize.width > expText.width)
	{
		if (animationTimer == nil)
		{
			animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(tick) userInfo:nil repeats:YES];
		}
	}
	need_check = false;
}

-(void)drawRect:(CGRect)rect{
	
	CGRect rc = CGRectMake(rect.origin.x + offset_x, rect.origin.y, rect.size.width, rect.size.height);
	
	[expText drawRect:rc lineBreakMode:self.lineBreakMode textAlignment:self.textAlignment];
	
	if (need_check)
	{
		[self checkNeedsSrcoll];
	}
}

-(void)tick
{
	if (expText.contentSize.width > expText.width)
	{
		if (animationTimer == nil)
		{
			animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(tick) userInfo:nil repeats:YES];
		}
		offset_x -= 3;
		if(offset_x < (0 - expText.contentSize.width))
		{
			offset_x = 0;
		}
		[self setNeedsDisplay];
	}
	else
	{
		if (animationTimer)
		{
			[animationTimer invalidate];
			animationTimer = nil;
		}
	}
}

-(void)setText:(NSString *)text{
	[super setText:text];
	offset_x = 0;
	[self tick];
}

-(void)setExpText:(ExpText *)inExpText{
	[super setExpText:inExpText];
	[expText setSrcollMode];
	offset_x = 0;
	
	[self tick];
}
@end

