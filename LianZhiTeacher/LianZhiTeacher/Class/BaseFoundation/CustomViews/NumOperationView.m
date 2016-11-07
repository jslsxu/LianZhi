//
//  NumOperationView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/2.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NumOperationView.h"

@interface NumOperationView ()<UITextFieldDelegate>
@property (nonatomic, assign)NSInteger min;
@property (nonatomic, assign)NSInteger max;
@end

@implementation NumOperationView

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithMin:(NSInteger)min max:(NSInteger)max{
    self = [super initWithFrame:CGRectMake(0, 0, 66, 24)];
    if(self){
        self.min = min;
        self.max = max;

        _decreaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_decreaseButton setFrame:CGRectMake(0, 0, 20, self.height)];
        [_decreaseButton addTarget:self action:@selector(onDescrese) forControlEvents:UIControlEventTouchUpInside];
        [_decreaseButton setImage:[UIImage imageNamed:@"numMinus"] forState:UIControlStateNormal];
        [self addSubview:_decreaseButton];
        
        _increaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_increaseButton setFrame:CGRectMake(self.width - 20, 0, 20, self.height)];
        [_increaseButton addTarget:self action:@selector(onIncrease) forControlEvents:UIControlEventTouchUpInside];
        [_increaseButton setImage:[UIImage imageNamed:@"numAdd"] forState:UIControlStateNormal];
        [self addSubview:_increaseButton];
        
        _contentField = [[UITextField alloc] initWithFrame:CGRectMake(_decreaseButton.right, 0, _increaseButton.left - _decreaseButton.right, self.height)];
        [_contentField setFont:[UIFont systemFontOfSize:15]];
        [_contentField setTextAlignment:NSTextAlignmentCenter];
        [_contentField setKeyboardType:UIKeyboardTypeNumberPad];
        [_contentField setDelegate:self];
        [self addSubview:_contentField];
        
        [self updateSubviews];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged) name:UITextFieldTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)updateSubviews{
    [_decreaseButton setEnabled:self.num > self.min];
    [_increaseButton setEnabled:self.num < self.max];
}

- (void)setNum:(NSInteger)num{
    _num = num;
    [_contentField setText:kStringFromValue(_num)];
    [self updateSubviews];
    if(self.numChangedCallback){
        self.numChangedCallback(self.num);
    }
}

- (void)onDescrese{
    if(self.num - 1 >= self.min){
        [self setNum:self.num - 1];
    }
}

- (void)onIncrease{
    if(self.num + 1 <= self.max){
        [self setNum:self.num + 1];
    }
}

- (void)textChanged{
    NSString *text = _contentField.text;
    NSInteger num = [text integerValue];
    if(num > self.max){
        [self setNum:self.max];
    }
    else if(num < self.min){
        [self setNum:self.min];
    }
    else{
        [self setNum:num];
    }
}

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    UITextPosition *endDocument = textField.endOfDocument;//获取 text的 尾部的 TextPositext
    
    UITextPosition *end = [textField positionFromPosition:endDocument offset:0];
    UITextPosition *start = [textField positionFromPosition:end offset:-textField.text.length];//左－右＋
    textField.selectedTextRange = [textField textRangeFromPosition:start toPosition:end];
}
@end
