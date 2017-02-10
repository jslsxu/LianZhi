//
//  StudentsAttendanceCell.m
//  LianZhiTeacher
//
//  Created by jslsxu on 16/12/23.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "StudentsAttendanceCell.h"
#import "NoteView.h"
#import "NoteDetailView.h"
@interface StudentsAttendanceCell ()
@property (nonatomic, strong)AvatarView* avatar;
@property (nonatomic, strong)UILabel* nameLabel;
@property (nonatomic, strong)UIImageView* checkMark;
@property (nonatomic, strong)UIButton* phoneButton;
@property (nonatomic, strong)NoteView* noteView;

@end

@implementation StudentsAttendanceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:[UIColor whiteColor]];
        
        self.avatar = [[AvatarView alloc] initWithRadius:15];
        [self addSubview:self.avatar];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.nameLabel setTextColor:kColor_33];
        [self.nameLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:self.nameLabel];
        
        self.checkMark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckMarkAttendance"]];
        [self addSubview:self.checkMark];
        
        self.phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.phoneButton setSize:CGSizeMake(20, 30)];
        [self.phoneButton setImage:[UIImage imageNamed:@"call_telephone"] forState:UIControlStateNormal];
        [self.phoneButton addTarget:self action:@selector(phoneClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.phoneButton];
        
        self.noteView = [[NoteView alloc] initWithFrame:CGRectMake(10, 0, self.width - 20 - 10, 20)];
        [self addSubview:self.noteView];
        
        UIView* sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [sepLine setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
        [sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:sepLine];
        
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noteClicked)];
        [self.noteView addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)phoneClicked{
    StudentAttendanceItem* attendanceItem = (StudentAttendanceItem *)self.modelItem;
    NSMutableArray* mobileArray = [NSMutableArray array];
    for (FamilyInfo *familyInfo in attendanceItem.child_info.family) {
        [mobileArray addObject:[NSString stringWithFormat:@"%@:%@",familyInfo.relation, familyInfo.mobile]];
    }
    LGAlertView* alertView = [[LGAlertView alloc] initWithTitle:attendanceItem.child_info.name message:nil style:LGAlertViewStyleActionSheet buttonTitles:mobileArray cancelButtonTitle:@"取消" destructiveButtonTitle:nil];
    [alertView setButtonsTitleColor:kCommonTeacherTintColor];
    [alertView setCancelButtonTitleColor:kCommonTeacherTintColor];
    [alertView setButtonsBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
    [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
    [alertView setActionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
        FamilyInfo* familyInfo = attendanceItem.child_info.family[index];
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel://%@",familyInfo.mobile];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }];
    [alertView showAnimated:YES completionHandler:nil];
}

- (void)onReloadData:(TNModelItem *)modelItem{
    StudentAttendanceItem* attendanceItem = (StudentAttendanceItem *)modelItem;
    [self.avatar setOrigin:CGPointMake(10, 10)];
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:attendanceItem.child_info.avatar] placeholderImage:nil];
    [self.nameLabel setText:attendanceItem.child_info.name];
    [self.nameLabel sizeToFit];
    [self.nameLabel setOrigin:CGPointMake(self.avatar.right + 5, self.avatar.top + (self.avatar.height - self.nameLabel.height) / 2)];
    
    [self.phoneButton setX:self.nameLabel.right + 5];
    [self.phoneButton setCenterY:self.avatar.centerY];
    
    NSString* checkStr = nil;
    if(attendanceItem.status == AttendanceStatusNormal){
        checkStr = @"CheckMarkAttendance";
    }
    else if(attendanceItem.status == AttendanceStatusLate){
        checkStr = @"CheckMarkLate";
    }
    else if(attendanceItem.status == AttendanceStatusAbsence){
        checkStr = @"CheckMarkAbsence";
    }
    else if(attendanceItem.status == AttendanceStatusLeave){
        checkStr = @"CheckMarkLeave";
    }
    [self.checkMark setImage:[UIImage imageNamed:checkStr]];
    if([attendanceItem normalAttendance]){
        [self.checkMark setCenter:CGPointMake(self.width * 5 / 8, 20)];
    }
    else{
        [self.checkMark setCenter:CGPointMake(self.width * 7 / 8, 20)];
    }
    CGFloat spaceYStart = 45;
    if([attendanceItem.recode count] > 0){
        [self.noteView setHidden:NO];
        [self.noteView setNoteItem:[attendanceItem.recode firstObject]];
        [self.noteView setOrigin:CGPointMake(10, spaceYStart)];
        spaceYStart = self.noteView.bottom + 5;
    }
    else{
        [self.noteView setHidden:YES];
    }
    
}

- (void)noteClicked{
    StudentAttendanceItem* attendanceItem = (StudentAttendanceItem *)self.modelItem;
    [NoteDetailView showWithNotes:attendanceItem.recode];
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width{
    StudentAttendanceItem* attendanceItem = (StudentAttendanceItem *)modelItem;
    CGFloat height = 45;
    if([attendanceItem.recode count] > 0){
        height += 20;
    }
    height += 10;
    return @(height);
}

@end
