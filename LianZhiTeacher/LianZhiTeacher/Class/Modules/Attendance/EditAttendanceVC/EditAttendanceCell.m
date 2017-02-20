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
#import "StudentsAttendanceListModel.h"
@interface EditAttendanceCell ()
@property (nonatomic, strong)UIView* flashView;
@property (nonatomic, strong)AvatarView* avatar;
@property (nonatomic, strong)UILabel* nameLabel;
@property (nonatomic, strong)UIButton* mobileButton;
@property (nonatomic, strong)UIButton* attendanceButton;
@property (nonatomic, strong)UIButton* offButton;
@property (nonatomic, strong)UIImageView* checkView;
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
        
        self.flashView = [[UIView alloc] initWithFrame:self.bounds];
        [self.flashView setAlpha:0.f];
        [self.flashView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [self.flashView setBackgroundColor:kCommonTeacherTintColor];
        [self addSubview:self.flashView];
        
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
        [self.attendanceButton.layer setBorderColor:kSepLineColor.CGColor];
        [self.attendanceButton.layer setBorderWidth:kLineHeight];
        [self.attendanceButton setFrame:CGRectMake(self.width / 2, 10, self.width / 4, 30)];
        [self.attendanceButton addTarget:self action:@selector(attendanceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.attendanceButton];
        
        self.offButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.offButton.layer setBorderColor:kSepLineColor.CGColor];
        [self.offButton.layer setBorderWidth:kLineHeight];
        [self.offButton setFrame:CGRectMake(self.attendanceButton.right, 10, self.width / 4, 30)];
        [self.offButton addTarget:self action:@selector(attendanceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.offButton];
        
        self.checkView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckMarkAttendance"]];
        [self addSubview:self.checkView];
        
        self.noteView = [[NoteView alloc] initWithFrame:CGRectMake(10, 0, self.width - 20 - 10, 20)];
        [self addSubview:self.noteView];
        
//        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noteClicked)];
//        [self.noteView addGestureRecognizer:tapGesture];
        
        self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.commentButton addTarget:self action:@selector(addComment) forControlEvents:UIControlEventTouchUpInside];
        [self.commentButton setImage:[UIImage imageNamed:@"editComment"] forState:UIControlStateNormal];
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
        
        UIView* sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [sepLine setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
        [sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:sepLine];
    }
    return self;
}

- (void)onReloadData:(TNModelItem *)modelItem{
    StudentAttendanceItem* attendanceItem = (StudentAttendanceItem *)modelItem;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:attendanceItem.child_info.avatar]];
    [self.nameLabel setText:attendanceItem.child_info.name];
    [self.nameLabel sizeToFit];
    [self.nameLabel setOrigin:CGPointMake(self.avatar.right + 5, self.avatar.centerY - self.nameLabel.height / 2)];
    
    [self.mobileButton setOrigin:CGPointMake(self.nameLabel.right + 5, self.avatar.centerY - self.mobileButton.height / 2)];
    
    NSString* checkStr = nil;
    if(attendanceItem.newStatus == AttendanceStatusNormal){
        checkStr = @"CheckMarkAttendance";
    }
    else if(attendanceItem.newStatus == AttendanceStatusLate){
        checkStr = @"CheckMarkLate";
    }
    else if(attendanceItem.newStatus == AttendanceStatusAbsence){
        checkStr = @"CheckMarkAbsence";
    }
    else if(attendanceItem.newStatus == AttendanceStatusLeave){
        checkStr = @"CheckMarkLeave";
    }
    [self.checkView setImage:[UIImage imageNamed:checkStr]];
    if([attendanceItem editNormalAttenance]){
        [self.checkView setCenter:self.attendanceButton.center];
    }
    else{
        [self.checkView setCenter:self.offButton.center];
    }
    
    CGFloat spaceYStart = 45;
    if([attendanceItem.recode count] > 0){
        [self.noteView setHidden:NO];
        [self.noteView setNoteItem:[attendanceItem.recode firstObject]];
        [self.noteView setOrigin:CGPointMake(10, spaceYStart)];
        spaceYStart = self.noteView.bottom;
    }
    else{
        [self.noteView setHidden:YES];
    }
    
    [self.commentButton setOrigin:CGPointMake(10, spaceYStart)];
    spaceYStart = self.commentButton.bottom;
    if([attendanceItem.edit_mark length] > 0){
        [self.commentLabel setHidden:NO];
        [self.commentLabel setWidth:self.width - 10 * 2];
        [self.commentLabel setText:attendanceItem.edit_mark];
        [self.commentLabel sizeToFit];
        [self.commentLabel setOrigin:CGPointMake(10, spaceYStart)];
    }
    else{
        [self.commentLabel setHidden:YES];
    }

}


//- (void)noteClicked{
//    StudentAttendanceItem* attendanceItem = (StudentAttendanceItem *)self.modelItem;
//    [NoteDetailView showWithNotes:attendanceItem.recode];
//}

- (void)onMobileClicked{
    StudentAttendanceItem* attendanceItem = (StudentAttendanceItem *)self.modelItem;
    StudentInfo* studentInfo = attendanceItem.child_info;
    NSMutableArray *familyArray = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger i = 0; i < studentInfo.family.count; i++) {
        FamilyInfo *familyInfo = studentInfo.family[i];
        [familyArray addObject:[NSString stringWithFormat:@"%@: %@",familyInfo.relation, familyInfo.mobile]];
    }
    LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:attendanceItem.child_info.name message:nil style:LGAlertViewStyleActionSheet buttonTitles:familyArray cancelButtonTitle:@"取消" destructiveButtonTitle:nil];
    [alertView setCancelButtonFont:[UIFont systemFontOfSize:18]];
    [alertView setButtonsBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
    [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
    [alertView setButtonsTitleColor:[UIColor colorWithHexString:@"28c4d8"]];
    [alertView setCancelButtonTitleColor:[UIColor colorWithHexString:@"28c4d8"]];
    [alertView setActionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
        FamilyInfo *familyInfo = studentInfo.family[index];
        NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"tel://%@",familyInfo.mobile];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }];
    [alertView showAnimated:YES completionHandler:nil];
}

- (void)addComment{
    StudentAttendanceItem* attendanceItem = (StudentAttendanceItem *)self.modelItem;
    __weak typeof(self) wself = self;
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入备注(可不填)" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setFont:[UIFont systemFontOfSize:15]];
        [textField setTextColor:kColor_66];
        [textField setText:attendanceItem.edit_mark];
        UITextPosition *endDocument = textField.endOfDocument;//获取 text的 尾部的 TextPositext
        
        UITextPosition *end = [textField positionFromPosition:endDocument offset:0];
        UITextPosition *start = [textField positionFromPosition:end offset:-textField.text.length];//左－右＋
        textField.selectedTextRange = [textField textRangeFromPosition:start toPosition:end];
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField* textField = alertController.textFields[0];
        attendanceItem.edit_mark = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if(wself.attendanceChanged){
            wself.attendanceChanged();
        }
    }]];
    [CurrentROOTNavigationVC presentViewController:alertController animated:YES completion:nil];
}

- (void)flash{
    [UIView animateWithDuration:0.4 animations:^{
        [self.flashView setAlpha:0.5];
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            [self.flashView setAlpha:0.f];
        }];
    }];
}

- (void)attendanceButtonClicked:(UIButton *)button{
    StudentAttendanceItem* attendanceItem = (StudentAttendanceItem *)self.modelItem;
    NSString* title = nil;
    NSArray* reasonArray = nil;
    NSString* destructiveTitle = nil;
    if(button == self.attendanceButton){
        title = nil;
        reasonArray = @[@"正常出勤", @"迟到"];
        if(![attendanceItem editNormalAttenance]){
            attendanceItem.newStatus = AttendanceStatusNormal;
            attendanceItem.edit_mark = nil;
            if(self.attendanceChanged){
                self.attendanceChanged();
            }
        }
    }
    else{
        title = @"缺勤原因";
        reasonArray = @[@"生病休息", @"家中有事"];
        destructiveTitle = @"无故缺勤";
        if([attendanceItem editNormalAttenance]){
            attendanceItem.newStatus = AttendanceStatusAbsence;
            attendanceItem.edit_mark = destructiveTitle;
            if(self.attendanceChanged){
                self.attendanceChanged();
            }
        }
    }
    __weak typeof(self) wself = self;
    LGAlertView* alertView = [[LGAlertView alloc] initWithTitle:title message:nil style:LGAlertViewStyleActionSheet buttonTitles:reasonArray cancelButtonTitle:@"关闭" destructiveButtonTitle:destructiveTitle];
    [alertView setButtonsTitleColor:kCommonTeacherTintColor];
    [alertView setButtonsBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
    [alertView setDestructiveButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
    [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
    [alertView setCancelButtonTitleColor:kCommonTeacherTintColor];
    [alertView setDestructiveHandler:^(LGAlertView *alertView) {
        attendanceItem.newStatus = AttendanceStatusAbsence;
        attendanceItem.edit_mark = destructiveTitle;
        if(wself.attendanceChanged){
            wself.attendanceChanged();
        }
    }];
    [alertView setActionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger row) {
        if([attendanceItem editNormalAttenance]){
            attendanceItem.newStatus = AttendanceStatusNormal + row;
        }
        else{
            attendanceItem.newStatus = AttendanceStatusLeave;
        }
        if(attendanceItem.newStatus != AttendanceStatusNormal){
            attendanceItem.edit_mark = title;
        }
        else{
            attendanceItem.edit_mark = nil;
        }
    
        if(wself.attendanceChanged){
            wself.attendanceChanged();
        }
    }];
    [alertView showAnimated:YES completionHandler:nil];
    [self onReloadData:self.modelItem];
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width{
    StudentAttendanceItem* attendanceItem = (StudentAttendanceItem *)modelItem;
    
    CGFloat height = 45;
    if([attendanceItem.recode count] > 0){
        height += 20;
    }
    height += 30;
    if([attendanceItem.edit_mark length] > 0){
        CGSize size = [attendanceItem.edit_mark sizeForFont:[UIFont systemFontOfSize:15] size:CGSizeMake(width - 10 * 2, CGFLOAT_MAX) mode:NSLineBreakByWordWrapping];
        height += size.height;
    }
    height += 5;
    return @(height);
}
@end
