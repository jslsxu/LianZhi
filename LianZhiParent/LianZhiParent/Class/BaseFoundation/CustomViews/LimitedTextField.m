//
//  LimitedTextField.m
//  LianZhiParent
//
//  Created by jslsxu on 15/3/8.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "LimitedTextField.h"

@implementation LimitedTextField



- (void)textFieldValueChanged
{
    NSInteger limitedLength = self.limitedNum;
    //下面是修改部分
    bool isChinese;//判断当前输入法是否是中文
    NSArray *currentar = [UITextInputMode activeInputModes];
    UITextInputMode *current = [currentar firstObject];
    if ([current.primaryLanguage isEqualToString: @"en-US"]) {
        isChinese = false;
    }
    else
    {
        isChinese = true;
    }
    
    NSString *str = [self.text stringByReplacingOccurrencesOfString:@"?" withString:@""];
    if (isChinese)
    {
        UITextRange *selectedRange = [self markedTextRange];
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
        if (!position)
        {
            if ( str.length>=limitedLength)
            {
                NSString *strNew = [NSString stringWithString:str];
                [self setText:[strNew substringToIndex:limitedLength]];
            }
        }
        else
        {
            
        }
    }
    else
    {
        if ([str length]>=limitedLength)
        {
            NSString *strNew = [NSString stringWithString:str];
            [self setText:[strNew substringToIndex:limitedLength]];
            
        }
    }
}


@end
