//
//  EditAttendanceCell.m
//  LianZhiTeacher
//
//  Created by jslsxu on 16/12/23.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "EditAttendanceCell.h"
#import "NoteDetailView.h"
#import "NoteView.h"
@interface EditAttendanceCell ()
@property (nonatomic, strong)AvatarView* avatar;
@property (nonatomic, strong)UILabel* nameLabel;
@property (nonatomic, strong)UIButton* mobileButton;
@property (nonatomic, strong)UIButton* attendanceButton;
@property (nonatomic, strong)UIButton* offButton;
@property (nonatomic, strong)NoteView* noteView;
@property (nonatomic, strong)UIButton* commentButton;
@property (nonatomic, strong)UILabel* commentLabel;
@end

@implementation EditAttendanceCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:[UIColor whiteColor]];
        
        self.avatar = [[AvatarView alloc] initWithRadius:15];
        [self.avatar setOrigin:CGPointMake(10, 10)];
        [self addSubview:self.avatar];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.nameLabel setFont:[UIFont systemFontOfSize:15]];
        [self.nameLabel setTextColor:kColor_33];
        [self addSubview:self.nameLabel];
        
        self.mobileButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.mobileButton setSize:CGSizeMake(20, 30)];
        [self.mobileButton setImage:[UIImage imageNamed:@"call_telephone"] forState:UIControlStateNormal];
        [self.mobileButton addTarget:self action:@selector(onMobileClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.mobileButton];
        
        self.attendanceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.attendanceButton setFrame:CGRectMake(self.width / 2, 0, self.width / 4, 50)];
        [self.attendanceButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.attendanceButton addTarget:self action:@selector(attendanceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.attendanceButton];
        
        self.offButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.offButton setFrame:CGRectMake(self.attendanceButton.right, 0, self.width / 4, 50)];
        [self.offButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.offButton addTarget:self action:@selector(attendanceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.offButton];
        
        self.noteView = [[NoteView alloc] initWithFrame:CGRectMake(10, 0, self.width - 20 - 10, 20)];
        [self addSubview:self.noteView];
        
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noteClicked)];
        [self.noteView addGestureRecognizer:tapGesture];
        
        self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.commentButton addTarget:self action:@selector(addComment) forControlEvents:UIControlEventTouchUpInside];
        [self.commentButton setImage:[UIImage imageNamed:@"send_cancel"] forState:UIControlStateNormal];
        [self.commentButton setTitleColor:kCommonTeacherTintColor forState:UIControlStateNormal];
        [self.commentButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.commentButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [self.commentButton setTitle:@"备注:" forState:UIControlStateNormal];
        [self.commentButton setFrame:CGRectMake(10, 0, 60, 30)];
        [self.commentButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [self addSubview:self.commentButton];
        
        self.commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.commentLabel setTextColor:kColor_66];
        [self.commentLabel setFont:[UIFont systemFontOfSize:14]];
        [self.commentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.commentLabel setNumberOfLines:0];
        [self addSubview:self.commentLabel];
    }
    return self;
}

- (void)setAttendanceItem:(StudentAttendanceItem *)attendanceItem{
    _attendanceItem = attendanceItem;
    [self reloadData];
}

- (void)reloadData{
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:_attendanceItem.studentInfo.avatar]];
    [self.nameLabel setText:_attendanceItem.studentInfo.name];
    [self.nameLabel sizeToFit];
    [self.nameLabel setOrigin:CGPointMake(self.avatar.right + 5, self.avatar.centerY - self.nameLabel.height / 2)];
    
    [self.mobileButton setOrigin:CGPointMake(self.nameLabel.right + 5, self.avatar.centerY - self.mobileButton.height / 2)];
    BOOL attendance = _attendanceItem.attendance;
    [self.attendanceButton setHidden:!attendance];
    [self.offButton setHidden:attendance];
    
    CGFloat spaceYStart = 45;
    if([_attendanceItem.notes count] > 0){
        [self.noteView setHidden:NO];
        [self.noteView setNoteItem:[_attendanceItem.notes lastObject]];
        [self.noteView setOrigin:CGPointMake(10, spaceYStart)];
        spaceYStart = self.noteView.bottom;
    }
    else{
        [self.noteView setHidden:YES];
    }
    
    [self.commentButton setOrigin:CGPointMake(10, spaceYStart)];
    spaceYStart = self.commentButton.bottom;
    if([_attendanceItem.comment length] > 0){
        [self.commentLabel setHidden:NO];
        [self.commentLabel setWidth:self.width - 10 * 2];
        [self.commentLabel setText:_attendanceItem.comment];
        [self.commentLabel sizeToFit];
        [self.commentLabel setOrigin:CGPointMake(10, spaceYStart)];
    }
    else{
        [self.commentLabel setHidden:YES];
    }
}

- (void)noteClicked{
    [NoteDetailView showWithNotes:self.attendanceItem.notes];
}

- (void)onMobileClicked{
    __weak typeof(self) wself = self;
    NSMutableArray* mobileArray = [NSMutableArray array];
    for (FamilyInfo *familyInfo in self.attendanceItem.studentInfo.family) {
        [mobileArray addObject:[NSString stringWithFormat:@"%@:%@",familyInfo.name, familyInfo.mobile]];
    }
    LGAlertView* alertView = [[LGAlertView alloc] initWithTitle:self.attendanceItem.studentInfo.name message:nil style:LGAlertViewStyleActionSheet buttonTitles:mobileArray cancelButtonTitle:@"取消" destructiveButtonTitle:nil];
    [alertView setButtonsTitleColor:kCommonTeacherTintColor];
    [alertView setCancelButtonTitleColor:kCommonTeacherTintColor];
    [alertView setButtonsBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
    [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
    [alertView setActionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
        FamilyInfo* familyInfo = wself.attendanceItem.studentInfo.family[index];
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel://%@",familyInfo.mobile];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }];
    [alertView showAnimated:YES completionHandler:nil];
}

- (void)addComment{
    __weak typeof(self) wself = self;
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入备注(可不填)" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setFont:[UIFont systemFontOfSize:15]];
        [textField setTextColor:kColor_66];
        [textField setText:wself.attendanceItem.comment];
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField* textField = alertController.textFields[0];
        wself.attendanceItem.comment = textField.text;
        [wself reloadData];
    }]];
    [CurrentROOTNavigationVC presentViewController:alertController animated:YES completion:nil];
}

- (void)attendanceButtonClicked:(UIButton *)button{
    if(button == self.attendanceButton){
        self.attendanceItem.attendance = YES;
    }
    else{
        self.attendanceItem.attendance = NO;
    }
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width{
    StudentAttendanceItem* attendanceItem = (StudentAttendanceItem *)modelItem;
    
    CGFloat height = 45;
    if([attendanceItem.notes count] > 0){
        height += 20;
    }
    height += 30;
    if([attendanceItem.comment length] > 0){
        CGSize size = [attendanceItem.comment sizeForFont:[UIFont systemFontOfSize:15] size:CGSizeMake(width - 10 * 2, CGFLOAT_MAX) mode:NSLineBreakByWordWrapping];
        height += size.height;
    }
    height += 5;
    return @(height);
}
@end
