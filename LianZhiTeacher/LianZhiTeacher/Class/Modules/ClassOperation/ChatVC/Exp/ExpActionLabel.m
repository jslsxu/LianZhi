//
//  ExpActionLabel.m
// MFWIOS
//
//  Created by dong jianbo on 12-5-03.
//  Copyright (c) 2012年 mafengwo. All rights reserved.
//

#import "ExpActionLabel.h"
#import "ExpText.h"
@implementation ExpActionLabel

-(id)initWithCoder:(NSCoder *)aDecoder{
	if(self = [super initWithCoder:aDecoder]){
		actionTokens = [[NSMutableArray alloc] initWithCapacity:10];
		self.contentMode = UIViewContentModeRedraw;
		self.userInteractionEnabled = YES;
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		actionTokens = [[NSMutableArray alloc] initWithCapacity:10];
		self.userInteractionEnabled = YES;
		self.contentMode = UIViewContentModeRedraw;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	
	int actionClass =0;
	BOOL hasAction = NO;
	
	for(UITouch *touch in touches){
		
		CGPoint p = [touch locationInView:[touch view]];
		
		p.x += self.anchor.x;
		p.y += self.anchor.y;

		for(ExpToken *token in expText.tokens){
			if(token.tokenType == ExpTokenTypeAction && token.actionClass
			   && CGRectContainsPoint(token.frame, p)){
                if (token.actionType >= EXP_TYPE_NOCLICK_BEGIN) {
                    continue;
                }
                
				actionClass = token.actionClass;
				hasAction = YES;
				break;
			}
		}
	}
    
	if(hasAction && self.delegate){
		for(ExpToken *token in expText.tokens){
			if(token.actionClass == actionClass && token.tokenType == ExpTokenTypeAction ){
				[actionTokens removeObject:token];
                [actionTokens addObject:token];
				token.selected = YES;
			}
		}
		[self setNeedsDisplay];
	}
	else{
		[super touchesBegan:touches withEvent:event];
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
	if([actionTokens count] > 0 && self.delegate){

		for(ExpToken *token in actionTokens){
			token.selected = NO;
		}
		[self setNeedsDisplay];
		[actionTokens removeAllObjects];
	}
	else{
		[super touchesCancelled:touches withEvent:event];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	if([actionTokens count] > 0 && self.delegate){
		BOOL hasInner = NO;
		NSMutableString * title = [[NSMutableString alloc] initWithCapacity:200];
		NSRange range = {0,[title length]};
		for(UITouch * touch in  touches){
			CGPoint p = [touch locationInView:[touch view]];
			p.x += self.anchor.x;
			p.y += self.anchor.y;
			range.length = [title length];
			[title deleteCharactersInRange:range];
			for(ExpToken *token in actionTokens){
				if(!hasInner && CGRectContainsPoint(token.frame, p)){
					hasInner = YES;
				}
				token.selected = NO;
				[title appendString:token.text];
			}
			if(hasInner){
				break;
			}
		}
		if(hasInner){
			ExpToken * token = [actionTokens lastObject];
			[self.delegate expActionLabel:self action:token.action type:token.actionType actionStr:token.actionStr title:title inCell:token.cellIndex];
		}
		[self setNeedsDisplay];
		[actionTokens removeAllObjects];
	}
	else{
		[super touchesEnded:touches withEvent:event];
	}
}

@end
