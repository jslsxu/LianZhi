//
//  NSString+StringSize.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/19.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "NSString+StringSize.h"

@implementation NSString (StringSize)
- (CGSize)boundingRectWithSize:(CGSize)size andFont:(UIFont *)font
{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, 0)];
    [label setFont:font];
    [label setNumberOfLines:0];
    [label setLineBreakMode:NSLineBreakByWordWrapping];
    [label setText:self];
    [label sizeToFit];
    return label.size;
//    NSDictionary *attribute = @{NSFontAttributeName : font};
//    
//    CGSize retSize = [self boundingRectWithSize:size
//                                             options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
//                                          attributes:attribute
//                                         context:nil].size;
//    return retSize;
}


@end
