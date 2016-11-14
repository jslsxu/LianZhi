//
//  HomeworkMarkFooterView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/19.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkMarkFooterView.h"

static MarkType currentMarkType = MarkTypeNone;

@interface HomeworkMarkFooterView ()<UITextFieldDelegate>
@property (nonatomic, strong)UIButton*  rightButton;
@property (nonatomic, strong)UIButton*  wrongButton;
@property (nonatomic, strong)UIButton*  halfRightButton;
@property (nonatomic, strong)NSArray*   commentButtonArray;
@property (nonatomic, strong)UITextField*   textField;
@end

@implementation HomeworkMarkFooterView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setFrame:CGRectMake(10, 0, 50, 50)];
        [_rightButton setImage:[UIImage imageNamed:@"homeworkRightButton"] forState:UIControlStateNormal];
        [_rightButton setImage:[UIImage imageNamed:@"homeworkRightButtonSelected"] forState:UIControlStateSelected];
        [_rightButton addTarget:self action:@selector(touchRight) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightButton];
        
        _wrongButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_wrongButton setFrame:CGRectMake(_rightButton.right, 0, 50, 50)];
        [_wrongButton setImage:[UIImage imageNamed:@"homeworkWrongButton"] forState:UIControlStateNormal];
        [_wrongButton setImage:[UIImage imageNamed:@"homeworkWrongButtonSelected"] forState:UIControlStateSelected];
        [_wrongButton addTarget:self action:@selector(touchWrong) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_wrongButton];
        
        _halfRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_halfRightButton setFrame:CGRectMake(_wrongButton.right, 0, 50, 50)];
        [_halfRightButton setImage:[UIImage imageNamed:@"homeworkHalfButton"] forState:UIControlStateNormal];
        [_halfRightButton setImage:[UIImage imageNamed:@"homeworkHalfButtonSelected"] forState:UIControlStateSelected];
        [_halfRightButton addTarget:self action:@selector(touchHalfRight) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_halfRightButton];
        
        UILabel*  operationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [operationLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [operationLabel setFont:[UIFont systemFontOfSize:12]];
        [operationLabel setNumberOfLines:0];
        [operationLabel setWidth:self.width - 10 - _halfRightButton.right - 10];
        [operationLabel setText:@"选中左侧图标后，可在图上直接点击"];
        [operationLabel sizeToFit];
        [operationLabel setOrigin:CGPointMake(self.width - 10 - operationLabel.width, _halfRightButton.centerY - operationLabel.height / 2)];
        [self addSubview:operationLabel];
        
        UILabel* hintLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [hintLabel setText:@"作业评语(20字):"];
        [hintLabel setFont:[UIFont systemFontOfSize:14]];
        [hintLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [hintLabel sizeToFit];
        [hintLabel setFrame:CGRectMake(12, 50, hintLabel.width, 25)];
        [self addSubview:hintLabel];
        
        NSArray *commentImage = @[@"good",@"normal",@"bad"];
        NSMutableArray *commentButtonArray = [NSMutableArray array];
        NSInteger spaceXstart = self.width - (45 + 10) * 3;
        for (NSInteger i = 0; i < 3; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(spaceXstart + (45 + 10) * i, hintLabel.centerY - 15, 45, 30)];
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@Normal",commentImage[i]]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@Selected",commentImage[i]]] forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(onCommentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            [commentButtonArray addObject:button];
        }
        self.commentButtonArray = commentButtonArray;
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(12, hintLabel.bottom + (self.height - hintLabel.bottom - 20) / 2, self.width - 12 * 2, 20)];
        [_textField setFont:[UIFont systemFontOfSize:14]];
        [_textField setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_textField setPlaceholder:@"暂无评语"];
        [_textField setReturnKeyType:UIReturnKeyDone];
        [_textField setDelegate:self];
        [self addSubview:_textField];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanged:) name:UITextFieldTextDidChangeNotification object:_textField];
        __weak typeof(self) wself = self;
        [RACObserve(_textField, text) subscribeNext:^(id x) {
            wself.teacherMark.comment = wself.textField.text;
        }];
    }
    return self;
}

- (void)setTeacherMark:(HomeworkTeacherMark *)teacherMark{
    _teacherMark = teacherMark;
    [self clearMark];
    [_textField setText:_teacherMark.comment];
}

+ (MarkType)currentMarkType{
    return currentMarkType;
}

- (void)clearMark{
    currentMarkType = MarkTypeNone;
    _rightButton.selected = NO;
    _wrongButton.selected = NO;
    _halfRightButton.selected = NO;
}

- (void)touchRight{
    if(currentMarkType == MarkTypeRight){
        [self clearMark];
    }
    else{
        [self clearMark];
        currentMarkType = MarkTypeRight;
        _rightButton.selected = YES;
    }
}

- (void)touchWrong{
    if(currentMarkType == MarkTypeWrong){
        [self clearMark];
    }
    else{
        [self clearMark];
        currentMarkType = MarkTypeWrong;
        _wrongButton.selected = YES;
    }
}

- (void)touchHalfRight{
    if(currentMarkType == MarkTypeHalfRight){
        [self clearMark];
    }
    else{
        [self clearMark];
        currentMarkType = MarkTypeHalfRight;
        _halfRightButton.selected = YES;
    }
}

- (NSString *)comment{
    return [_textField text];
}

- (void)onCommentButtonClicked:(UIButton *)button{
    NSInteger index = [self.commentButtonArray indexOfObject:button];
    NSString *comment = nil;
    if(index == 0){
        comment = @"作业完成的很好，老师非常满意。";
    }
    else if(index == 1){
        comment = @"作业完成的不错，继续努力。";
    }
    else{
        comment = @"如果再仔细一点，相信成功一定属于你。";
    }
    [_textField setText:comment];
}

- (void)textFieldDidChanged:(NSNotification *)notification{
    if(notification.object == self.textField){
        NSInteger maxTextNum = 20;
        NSString *toBeString = self.textField.text;
        
        //获取高亮部分
        UITextRange *selectedRange = [self.textField markedTextRange];
        UITextPosition *position = [self.textField positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            if (toBeString.length > maxTextNum)
            {
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:maxTextNum];
                if (rangeIndex.length == 1)
                {
                    self.textField.text = [toBeString substringToIndex:maxTextNum];
                }
                else
                {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxTextNum)];
                    self.textField.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if([string isEqualToString:@"\n"]){
        [textField resignFirstResponder];
        return NO;
    }
    return true;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}
@end
