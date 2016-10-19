//
//  HomeworkMarkFooterView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/19.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkMarkFooterView.h"

@interface HomeworkMarkFooterView ()
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
        [_rightButton addTarget:self action:@selector(touchRight) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightButton];
        
        _wrongButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_wrongButton setFrame:CGRectMake(_rightButton.right, 0, 50, 50)];
        [_wrongButton setImage:[UIImage imageNamed:@"homeworkWrongButton"] forState:UIControlStateNormal];
        [_wrongButton addTarget:self action:@selector(touchWrong) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_wrongButton];
        
        _halfRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_halfRightButton setFrame:CGRectMake(_wrongButton.right, 0, 50, 50)];
        [_halfRightButton setImage:[UIImage imageNamed:@"homeworkHalfButton"] forState:UIControlStateNormal];
        [_halfRightButton addTarget:self action:@selector(touchHalfRight) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_halfRightButton];
        
        UILabel* hintLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [hintLabel setText:@"作业评语(20字):"];
        [hintLabel setFont:[UIFont systemFontOfSize:14]];
        [hintLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [hintLabel sizeToFit];
        [hintLabel setOrigin:CGPointMake(12, 50)];
        [self addSubview:hintLabel];
        
        NSArray *commentImage = @[@"good",@"normal",@"bad"];
        NSMutableArray *commentButtonArray = [NSMutableArray array];
        NSInteger spaceXstart = self.width - (45 + 10) * 3;
        for (NSInteger i = 0; i < 3; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(spaceXstart + (45 + 10) * i, hintLabel.centerY - 9, 45, 18)];
            [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@Normal",commentImage[i]]] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@Selected",commentImage[i]]] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(onCommentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            [commentButtonArray addObject:button];
        }
        self.commentButtonArray = commentButtonArray;
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, self.height - 10 - 20, self.width - 10 * 2, 20)];
        [_textField setFont:[UIFont systemFontOfSize:14]];
        [_textField setTextColor:[UIColor colorWithHexString:@"333333"]];
        [self addSubview:_textField];
    }
    return self;
}

- (void)touchRight{
    
}

- (void)touchWrong{
    
}

- (void)touchHalfRight{
    
}

- (void)onCommentButtonClicked:(UIButton *)button{
    NSInteger index = [self.commentButtonArray indexOfObject:button];
    if(button.selected){
        button.selected = NO;
    }
    else{
        for (UIButton *commentButton in self.commentButtonArray) {
            if(commentButton == button){
                commentButton.selected = YES;
            }
            else{
                commentButton.selected = NO;
            }
        }
    }
}

@end
