//
//  ExpText.m
// MFWIOS
//
//  Created by dong jianbo on 12-5-03.
//  Copyright (c) 2012年 mafengwo. All rights reserved.
//

#import "ExpText.h"

#define EXP_FACE_FLAG			@"flag"
#define EXP_VIDEO_FLAG          @"video"



//*********************************************************************************
// MessageFaceExpTextDataSource
@implementation MessageFaceExpTextDataSource
@synthesize isScrollMode;

-(BOOL)expText:(ExpText *)extText hasFace:(NSString *)face{
	if([EXP_FACE_FLAG isEqualToString:face] || [EXP_VIDEO_FLAG isEqualToString:face])
    {
		return YES;
	}
	return [MFWFace indexForFace:face] != NSNotFound;
}

-(CGSize)expText:(ExpText *)expText tokenSize:(NSString *) value tokenType:(ExpTokenType)tokenType{
	if([EXP_FACE_FLAG isEqualToString:value])
    {
		return CGSizeMake(14, 14);
	}
    else if ([EXP_VIDEO_FLAG isEqualToString:value])
    {
        return CGSizeMake(14, 13);
    }

	return CGSizeMake([expText.textFont pointSize] + 4, [expText.textFont pointSize] + 4);
}

-(void)expText:(ExpText *)expText drawRect:(CGRect)rect
 lineBreakMode:(NSLineBreakMode)lineBreakMode textAlignment:(NSTextAlignment)textAlignment token:(ExpToken *)token{
	if(token.tokenType == ExpTokenTypeFace){
		if([EXP_FACE_FLAG isEqualToString:token.text])
        {
			//CGContextRef context =  UIGraphicsGetCurrentContext();
			
			[[UIImage imageNamed:@"redflag_icon.png"] drawAtPoint:CGPointMake(rect.origin.x, rect.origin.y +2)];
			//[[shareProvider() otherAnimation] renderModule:context 
			//									   module:OTHER_MODULE_STAR 
			//											x:(int)rect.origin.x
			//											y:(int)rect.origin.y +4
			//										 flag:0];
            
		}
		else if([EXP_VIDEO_FLAG isEqualToString:token.text])
        {
			//CGContextRef context =  UIGraphicsGetCurrentContext();
			
			[[UIImage imageNamed:@"news_video_icon.png"] drawAtPoint:CGPointMake(rect.origin.x, rect.origin.y +2)];
			//[[shareProvider() otherAnimation] renderModule:context 
			//									   module:OTHER_MODULE_STAR 
			//											x:(int)rect.origin.x
			//											y:(int)rect.origin.y +4
			//										 flag:0];
            
		}
		else
        {
            NSUInteger index = [MFWFace indexForFace:token.text];
            if (index != NSNotFound)
            {
//                [[UIImage imageNamed:[NSString stringWithFormat:@"%d.png", index]] drawAtPoint:CGPointMake(rect.origin.x, rect.origin.y)];
                
                [[UIImage imageNamed:[NSString stringWithFormat:@"%ld.png", (long)index]] drawInRect:CGRectMake(rect.origin.x + 1, rect.origin.y + 1, [expText.textFont pointSize] + 2, [expText.textFont pointSize] + 2)];
            }
		}
	}
	else if(token.tokenType == ExpTokenTypeAction){
		if(rect.size.width > expText.width){
			
		}
		CGContextRef context = UIGraphicsGetCurrentContext();
		if(token.selected){
			CGContextSaveGState(context);
			CGContextSetFillColorWithColor(context,  expText.actionSelectColor.CGColor);
			CGContextFillRect(context, rect);
			CGContextRestoreGState(context);
		}
		CGContextSaveGState(context);
        
		CGContextSetTextDrawingMode(context, kCGTextFill);
//		if(token.actionType == -101 || token.actionType == -102){
//			CGContextSetFillColorWithColor(context,  [UIColor grayColor].CGColor);
//		}
//		else
        if(token.actionType == EXP_TYPE_COLOR_TEXT){
            unsigned int color = (unsigned int)token.action;
            int b = color % 256;
            int g = color / 256 % 256;
            int r = color / 256 / 256 % 256;
			CGContextSetFillColorWithColor(context,  [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1.0f].CGColor);
		}
		else{
			CGContextSetFillColorWithColor(context,  expText.actionColor.CGColor);
		}
		
		if(rect.size.width > expText.width){
			rect.size.width = expText.width;
		}
		[token.text drawInRect:rect withFont:expText.actionFont lineBreakMode:lineBreakMode alignment:textAlignment];
		CGContextRestoreGState(context);
	}
	else if(token.tokenType == ExpTokenTypeText){
		CGContextRef context = UIGraphicsGetCurrentContext();
		CGContextSaveGState(context);
		CGContextSetTextDrawingMode(context, kCGTextFill);
		CGContextSetFillColorWithColor(context,  expText.textColor.CGColor);
		if(rect.size.width > expText.width && isScrollMode == NO){
			rect.size.width = expText.width;
		}
		[token.text drawInRect:rect withFont:expText.textFont lineBreakMode:lineBreakMode alignment:textAlignment];
		CGContextRestoreGState(context);
	}
}

-(NSString *)expTextFaceBegin:(ExpText *)extText{
	return EXP_FACE_BEGIN;
}

-(NSString *)expTextFaceEnd:(ExpText *)extText{
	return EXP_FACE_END;
}

-(NSString *)expTextActionBegin:(ExpText *)extText{
	return EXP_ACTION_BEGIN;
}

-(NSString *)expTextActionEnd:(ExpText *)extText{
	return EXP_ACTION_END;
}

-(NSString *)expTextActionExist:(ExpText *)expText{
	return EXP_ACTION;
}

@end



//*********************************************************************************
// ExpToken
@implementation ExpToken

@end



//*********************************************************************************
// ExpContext
@interface ExpContext : NSObject
{
	NSMutableString * value;
	CGFloat  lineHeight;
	CGFloat  lineWidth;
	long long action;
    NSString *actionStr;
	long long actionType;
	int actionClass;
	CGRect frame;
	ExpTokenType tokenType;
	int autoId;
}

@property(nonatomic,assign) ExpTokenType tokenType;
@property(nonatomic,readonly) NSString *value;
@property(nonatomic,assign) CGFloat lineHeight;
@property(nonatomic,assign) CGFloat lineWidth;
@property(nonatomic,assign) long long action;
@property(nonatomic,copy)   NSString *actionStr;
@property(nonatomic,assign) long long actionType;
@property(nonatomic,assign) CGRect frame;
@property(nonatomic,assign) int actionClass;

-(BOOL)zero;
-(void)setZero;
-(void)appendValue:(NSString *)value;
-(void)setOrigin:(CGPoint)origin;
-(CGPoint)origin;
-(void)setSize:(CGSize)size;
-(CGSize)size;
-(int)autoId;
@end

@implementation ExpContext
@synthesize tokenType;
@synthesize lineHeight;
@synthesize lineWidth;
@synthesize action;
@synthesize actionStr;
@synthesize actionType;
@synthesize frame;
@synthesize actionClass;

-(id)init
{
	if(self = [super init]){
		value = [[NSMutableString alloc] initWithCapacity:1024];
	}
    
	return self;
}

-(NSString *)value
{
	return [NSString stringWithString:value];
}

-(void)appendValue:(NSString *)v
{
	[value appendString:v];
}

-(void)setZero
{
	frame.size = CGSizeZero;
	NSRange range = {0,[value length]};
	[value deleteCharactersInRange:range];
	lineWidth = 0;
	lineHeight = 0;
}

-(BOOL)zero
{
	return frame.size.width == 0 && frame.size.height ==0;
}

-(void)setOrigin:(CGPoint)origin
{
	frame.origin = origin;
}

-(CGPoint)origin
{
	return frame.origin;
}

-(void)setSize:(CGSize)size
{
	frame.size = size;
}

-(CGSize)size
{
	return frame.size;
}

-(int)autoId
{
	return ++autoId;
}

@end



//*********************************************************************************
// ExpText
@interface ExpText(Private)
-(void)handle;
-(void)tickChar:(ExpContext *)context charStr: (NSString *)charStr font:(UIFont *)font;
-(void)tickFace:(ExpContext *)context faceStr:(NSString *)faceStr;
-(void)tickAction:(ExpContext *)context title:(NSString *)title action:(long long)action actionType:(long long)actionType actionStr:(NSString *) actionStr;
-(void)addToken:(ExpContext *)context;
-(void)setNeedsHandle;
@end

@implementation ExpText(Private)

-(BOOL) exp_checkStopEmotion:(int)ch
{
    if (ch > 127) return NO;
    if (ch >= 123) return YES;
    
    if (ch > 96) return NO;
    if (ch >= 91) return YES;
    
    if (ch > 64) return NO;
    if (ch >= 59) return YES;
    
    if (ch > 47) return NO;
    if (ch >= 42) return YES;
    
    if (ch > 40) return NO;
    if (ch >= 32) return YES;
    
    return NO;
}

- (NSString *)getStringFromArray:(NSArray *)array range:(NSRange)range
{
    NSMutableString *retStr = [[NSMutableString alloc] initWithCapacity:0];
    NSInteger i = range.location;
    for (; i < range.location + range.length && i <[array count]; i++) {
        [retStr appendString:[array objectAtIndex:i]];
    }
    return  retStr;
}

- (NSRange)rangeOfString:(NSString *)str fromArray:(NSArray *)array range:(NSRange)range
{
    NSMutableArray *composedArray = [[NSMutableArray alloc] initWithCapacity:0];
    [str enumerateSubstringsInRange:NSMakeRange(0, [str length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        [composedArray addObject:substring];
    }];
    
    NSInteger count = [array count];
    NSInteger maxLength = (count < range.location + range.length ? count : range.location + range.length) - 1;
    for (NSInteger i = range.location; i <= maxLength; i++) {
        NSString *cstr = [array objectAtIndex:i];
        if([cstr isEqualToString:[composedArray objectAtIndex:0]])
        {
            BOOL flag = YES;
            for (NSInteger j = 0; j < [composedArray count] && i + j < [array count]; j++) {
                if(![(NSString *)[array objectAtIndex:i+j] isEqualToString:[composedArray objectAtIndex:j]])
                    flag = NO;
            }
            if(flag)
                return NSMakeRange(i, [composedArray count]);
        }
        else
            continue;
    }
    return NSMakeRange(NSNotFound, 0);
}

-(void)handle{
	
	contentSize = CGSizeZero;
	[tokens removeAllObjects];
	ExpContext *context = [[ExpContext alloc] init];
	
	NSString *expFaceBegin  =[dataSource expTextFaceBegin:self];
	NSString *expFaceEnd  =[dataSource expTextFaceEnd:self];
	NSString *expActionBegin  =[dataSource expTextActionBegin:self];
	NSString *expActionEnd =[dataSource expTextActionEnd:self];
	NSString *expActionExist = [dataSource expTextActionExist:self];
	

	NSRange expFaceBeginRange = {0,[expFaceBegin length]};
	NSRange expFaceEndRange = {0,[expFaceEnd length]};
	NSRange expActionBeginRange = {0,[expActionBegin length]};
	NSRange expActionEndRange = {0,[expActionEnd length]};
    
    NSUInteger length = [text length],s=0;
    NSMutableArray *composedArray = [[NSMutableArray alloc] initWithCapacity:0];
    [text enumerateSubstringsInRange:NSMakeRange(0, length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        [composedArray addObject:substring];
    }];

    NSInteger count = [composedArray count];
	NSInteger index = 0;
	for(;index < count;index ++){        
		NSString *c = [composedArray objectAtIndex:index];
		expFaceBeginRange.location = index;
		expFaceEndRange.location = index;
		expActionBeginRange.location = index;
		expActionEndRange.location = index;
		
		if(s == 0)
        {
            //Face 类型
                        
			if(expFaceBeginRange.location+expFaceBeginRange.length <=count 
			   && [[self getStringFromArray:composedArray range:expFaceBeginRange] isEqualToString:expFaceBegin])
            {
				index += expFaceBeginRange.length -1;
				s = 1;
			}
            
            //Action 类型
			else if(expActionBeginRange.location+expActionBeginRange.length <=count 
					&& [[self getStringFromArray:composedArray range:expActionBeginRange] isEqualToString:expActionBegin])
            {
				index += expActionBeginRange.length -1;
				s = 2;
			}
			else
            {
				[self tickChar:context charStr:c font:textFont];
			}
		}
		else if(s == 1)
        {
			// face begin
			NSRange expEnd = NSMakeRange(NSNotFound, 0);
            for (NSInteger i = index; i < count; i++)
            {
                NSString *c = [composedArray objectAtIndex:i];
                if ([self exp_checkStopEmotion:[c characterAtIndex:0]])
                {
                    break;
                }
                else if ([c isEqualToString:@")"])
                {
                    expEnd = NSMakeRange(i, 1);
                    break;
                }
            }
			NSRange faceRange = {index,expEnd.location - index};
			NSString * faceStr = nil;
			if( expEnd.length >0 
			   && (faceStr = [self getStringFromArray:composedArray range:faceRange])
			   && [dataSource expText:self hasFace:faceStr])
            {
				[self tickFace:context faceStr:faceStr];
				index = expEnd.location + expEnd.length - 1;
				s = 0;
			}
			else
            {
				NSRange cRange = {0,1};
				NSString * str = expFaceBegin;
				for(;cRange.location<[str length];cRange.location++)
                {
					[self tickChar:context charStr:[str substringWithRange:cRange] font:textFont];
				}
				[self tickChar:context charStr:c font:textFont];
				s = 0;
			}
		}
		else if(s ==2)
        {
			// action begin;
			NSRange searchRange = {index,count - index};
			NSRange expEnd = [self rangeOfString:expActionEnd fromArray:composedArray range:searchRange];
			if(expEnd.length >0)
            {
				NSRange expRange = {index,expEnd.location - index};
				NSString *exp = [self getStringFromArray:composedArray range:expRange];
				NSRange acRange = [exp rangeOfString:expActionExist];
				if(acRange.length>0)
                {
					NSRange titleRange = {0,acRange.location};
					NSString * title = [exp substringWithRange:titleRange];
					NSRange actionIdRange = {acRange.location + acRange.length,[exp length] - acRange.location - acRange.length};
					acRange = [exp rangeOfString:expActionExist options:NSCaseInsensitiveSearch range:actionIdRange];
					if(acRange.length >0)
                    {
						actionIdRange.length = acRange.location - actionIdRange.location;
					}
                    NSString *actionStr = [exp substringWithRange:actionIdRange];
					long long actionId = [actionStr longLongValue];
					long long type = 0;
					if(acRange.length>0){
						NSRange typeRange = {acRange.location + acRange.length,[exp length] - acRange.location - acRange.length};
						type = [[exp substringWithRange:typeRange] longLongValue];
					}
					[self tickAction:context title:title action:actionId actionType:type actionStr:actionStr];
				}
				else
                {
					NSRange cRange = {0,1};
					NSString * str = expActionBegin;
					for(;cRange.location<[str length];cRange.location++)
                    {
						[self tickChar:context charStr:[str substringWithRange:cRange] font:textFont];
					}
					[self tickChar:context charStr:c font:textFont];
					s = 0;
					continue;
				}
				s = 0;
				index = expEnd.location + expEnd.length -1;
			}
			else{
				NSRange cRange = {0,1};
				NSString * str = expActionBegin;
				for(;cRange.location<[str length];cRange.location++)
                {
					[self tickChar:context charStr:[str substringWithRange:cRange] font:textFont];
				}
				[self tickChar:context charStr:c font:textFont];
				s = 0;
			}
		}
	}
	[self addToken:context];
	contentSize.height += context.lineHeight;
}

-(void)tickChar:(ExpContext *)context charStr:(NSString *)charStr font:(UIFont *)font{
	if([charStr isEqualToString:@"\n"]){
		if(context.lineWidth > contentSize.width){
			contentSize.width = context.lineWidth;
		}
		contentSize.height += context.lineHeight;
		[self addToken:context];
		[context setOrigin:CGPointMake(0, context.origin.y+context.lineHeight)]; 
		[context setZero];
		return;
	}
	
	CGSize s = [charStr sizeWithFont:font];
	
	if(srcollMode == NO && autoWarp && s.width + context.lineWidth > width){
		contentSize.height += context.lineHeight;
		[self addToken:context];
		[context setOrigin:CGPointMake(0, context.origin.y+context.lineHeight)];
		[context setZero];
		context.lineHeight = s.height;
		context.lineWidth = s.width;
		[context appendValue:charStr];
		[context setSize:s];
	}
	else{
		context.lineWidth = context.lineWidth + s.width;
		if(s.height >context.lineHeight){
			context.lineHeight =  s.height;
		}
		[context setSize:CGSizeMake(context.size.width + s.width, context.lineHeight )];
		if(context.lineWidth > contentSize.width ){
			contentSize.width = context.lineWidth;
		}
		[context appendValue:charStr];
	}
}

-(void)tickFace:(ExpContext *)context faceStr:(NSString *)faceStr{
	[self addToken:context];
	CGSize size = [dataSource expText:self tokenSize:faceStr tokenType:ExpTokenTypeFace];
    //换行
	if(srcollMode == NO && context.lineWidth + size.width > width){
		contentSize.height += context.lineHeight;
		[context setOrigin:CGPointMake(0,context.origin.y + context.lineHeight)];
		[context setZero];
		context.tokenType = ExpTokenTypeFace;
		[context appendValue:faceStr];
        [context setSize:size];
		[self addToken:context];
		
		[context setZero];
        context.tokenType = ExpTokenTypeText;
		context.lineHeight = size.height;
		context.lineWidth = size.width;
		if(context.lineWidth > contentSize.width ){
			contentSize.width = context.lineWidth;
		}
		[context setOrigin:CGPointMake(size.width,context.origin.y )];
	}
	else{
		CGFloat lineWidth =  context.lineWidth ;
		CGFloat lineHeight = size.height>context.lineHeight?size.height:context.lineHeight;
		[context setZero];
		
		[context setOrigin:CGPointMake(lineWidth,context.origin.y)];
		[context setSize:size];
		context.tokenType = ExpTokenTypeFace;
		[context appendValue:faceStr];
		[self addToken:context];
		
		[context setZero];
		context.tokenType = ExpTokenTypeText;
		context.lineWidth = lineWidth + size.width;
		context.lineHeight = lineHeight;
		if(context.lineWidth > contentSize.width ){
			contentSize.width = context.lineWidth;
		}
		[context setOrigin:CGPointMake(context.lineWidth,context.origin.y )];
	}
}

-(void)tickAction:(ExpContext *)context title:(NSString *)title action:(long long)action actionType:(long long)actionType actionStr:(NSString *)actionStr {
	
	[self addToken:context];
	
	CGFloat lineWidth = context.lineWidth;
	CGFloat lineHeight = context.lineHeight;
	[context setOrigin:CGPointMake(context.origin.x + context.size.width, context.origin.y)];
	[context setZero];
	context.lineWidth = lineWidth;
	context.lineHeight = lineHeight;
	
	context.actionClass = [context autoId];
	context.action = action;
    context.actionStr = actionStr;
	context.actionType = actionType;
	context.tokenType = ExpTokenTypeAction;
    
    NSMutableArray *composedArray = [[NSMutableArray alloc] initWithCapacity:0];
    [title enumerateSubstringsInRange:NSMakeRange(0, [title length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        [composedArray addObject:substring];
    }];
    
    for (NSInteger i = 0; i < [composedArray count]; i++) {
        NSString *charStr = [composedArray objectAtIndex:i];
        [self tickChar:context charStr:charStr font:actionFont];
    }
	
    /*
	NSRange charRange = {0,1};
	
	for(;charRange.location < [title length];charRange.location++){
		NSString *charStr = [title substringWithRange:charRange];
		[self tickChar:context charStr:charStr font:actionFont];
	}
     */
	
	[self addToken:context];
	
	lineWidth = context.lineWidth;
	lineHeight = context.lineHeight;
	[context setOrigin:CGPointMake(context.origin.x + context.size.width, context.origin.y)];
	[context setZero];
	context.lineWidth = lineWidth;
	context.lineHeight = lineHeight;
	
	context.action = 0;
	context.actionType = 0;
    context.actionStr = nil;
	context.tokenType = ExpTokenTypeText;
	
	if(actionType ==-1){
		[self tickFace:context faceStr:EXP_FACE_FLAG];
	}
}

-(void)addToken:(ExpContext *)context {
	if(![context zero]){
		ExpToken * token = [[ExpToken alloc] init];
		token.tokenType = context.tokenType;
		token.actionClass = context.actionClass;
		token.action = context.action;
		token.actionType = context.actionType;
        token.actionStr = context.actionStr;
		token.frame = context.frame;
		token.text = [context value];
		token.cellIndex = cellIndex;
		[tokens addObject:token];
	}
}

-(void)setNeedsHandle{
	if(_change){
		[self handle];
		_change = NO;
	}
}

@end



//*********************************************************************************
// ExpText
@implementation ExpText

-(id)init{
	if(self = [super init]){
		tokens = [[NSMutableArray alloc] initWithCapacity:10];
		textFont =[UIFont systemFontOfSize:14];
		actionFont = [UIFont systemFontOfSize:14];
		textColor = [[UIColor alloc ] initWithRed:0 green:0 blue:0 alpha:1];
		actionColor = [[UIColor alloc] initWithRed:0x56/256.0 green:0x6b/256.0 blue:0x95/256.0 alpha:1] ;
		actionSelectColor = [[UIColor alloc] initWithRed:0.1 green:0.1 blue:0.1 alpha:0.3] ;
		dataSource =[[MessageFaceExpTextDataSource alloc] init];
		autoWarp = YES;
		srcollMode = NO;
	}
	return self;
}

-(NSString *)text{
	return text;
}
-(void)setText:(NSString *)inText{
	text = inText;
	_change = YES;
	[self setNeedsHandle];
}

-(UIFont *)textFont{
	return textFont;
}

-(void)setTextFont:(UIFont *)inTextFont{
	if(textFont.capHeight != inTextFont.capHeight){
		_change = YES;
	}
	textFont = inTextFont;
}

-(UIFont *)actionFont{
	return actionFont;
}

-(void)setActionFont:(UIFont *)inActionFont{
	if(actionFont.capHeight != inActionFont.capHeight){
		_change = YES;
	}
	actionFont = inActionFont;
}

-(CGFloat)width{
	return width;
}

-(void)setWidth:(CGFloat)inWidth{
	if(inWidth != width){
		width = inWidth;
		_change = YES;
	}
}

-(BOOL)autoWarp{
	return autoWarp;
}

-(void)setAutoWarp:(BOOL)inAutoWarp{
	if(inAutoWarp != autoWarp){
		autoWarp = inAutoWarp;
		_change = YES;
	}
}

-(void)drawRect:(CGRect)rect lineBreakMode:(NSLineBreakMode)lineBreakMode textAlignment:(NSTextAlignment)textAlignment{
	[self setNeedsHandle];
	CGRect frame;
    NSInteger curLine = 0;
	for(ExpToken * token in tokens){
        if (clipInRect) {
            if ( numberOfLines == 0 && (rect.origin.y + token.frame.origin.y + token.frame.size.height > rect.origin.y + rect.size.height))
            {
                break;
            }
            
        }
        if( ( token.frame.origin.x == 0))
            curLine ++;
        if( numberOfLines > 0 && curLine > numberOfLines)
            break;
		frame = CGRectMake(rect.origin.x + token.frame.origin.x, rect.origin.y +token.frame.origin.y
						   , token.frame.size.width
						   , token.frame.size.height);
		[dataSource expText:self drawRect:frame lineBreakMode:lineBreakMode textAlignment:textAlignment token:token];
	}
}

- (NSString*) getShowString
{
    NSMutableString* tempString = [NSMutableString stringWithCapacity:20];
    [self setNeedsHandle];
	for(ExpToken * token in tokens)
    {
        if (token.tokenType == ExpTokenTypeFace)
        {
            [tempString appendFormat:@"%@%@%@)", EXP_FACE_BEGIN, token.text, EXP_FACE_END];
        }
        else
        {
            [tempString appendFormat:@"%@", token.text];
        }
	}
    return tempString;
}

-(CGSize)contentSize{
	[self setNeedsHandle];
	return contentSize;
}

-(void) setWidthAndFont:(CGFloat) inWidth font:(UIFont *)font{
	self.width = inWidth;
	self.textFont = font;
	self.actionFont = font;
}

-(void) setTextAndWidthAndFont:(NSString *)inText width:(CGFloat)inWidth font:(UIFont *)font{
	self.text = inText;
	self.width = inWidth;
	self.textFont = font;
	self.actionFont = font;
}

-(void)setSrcollMode
{
	srcollMode = TRUE;
	dataSource.isScrollMode = TRUE;
}

@end
