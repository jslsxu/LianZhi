//
//  HomeWorkVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/7.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "HomeWorkVC.h"
#import "PublishHomeWorkBaseVC.h"
#import "PublishHomeWorkAudioVC.h"
#import "PublishHomeWorkPhotoVC.h"
#import "PublishHomeWorkTextVC.h"
#import "HomeWorkItemCell.h"
#import "MyHomeworkList.h"
#define kCourseCacheKey          @"CourseCache"

@implementation CourseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _deleteButtons = [NSMutableArray array];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSArray *courseArray = [userDefaults objectForKey:kCourseCacheKey];
        _courseArray = [NSMutableArray arrayWithArray:courseArray];

        [self setupSubviews];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)setupSubviews
{
    [_deleteButtons removeAllObjects];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if(_courseArray.count == 0)
    {
        UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 0, 0)];
        [hintLabel setFont:[UIFont systemFontOfSize:14]];
        [hintLabel setTextColor:[UIColor colorWithHexString:@"b1b1b1"]];
        [hintLabel setText:@"添加作业所属科目"];
        [hintLabel sizeToFit];
        [hintLabel setOrigin:CGPointMake(10, 10)];
        [self addSubview:hintLabel];
        
        UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"EmptyCourse"]];
        [imageView setOrigin:CGPointMake(hintLabel.right + 3, 10)];
        [imageView setCenterY:hintLabel.centerY];
        [self addSubview:imageView];
        
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [addButton addTarget:self action:@selector(onAddButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [addButton setFrame:CGRectMake(imageView.right + 3, imageView.y + (imageView.height - 30) / 2, 60, 30)];
        [addButton setCenterY:imageView.centerY];
        [addButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"AAAAAA"] size:addButton.size cornerRadius:15] forState:UIControlStateNormal];
        [addButton setImage:[UIImage imageNamed:@"AddCourse"] forState:UIControlStateNormal];
        [self addSubview:addButton];
    }
    else
    {
        NSInteger spaceXStart = 0;
        NSInteger spaceYStart = 0;
        NSInteger innerMargin = 15;
        for (NSInteger i = 0; i < _courseArray.count + 1; i++)
        {
            if(i < _courseArray.count)
            {
                NSString *course = _courseArray[i];
                
                NSInteger buttonWidth = [course sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]}].width + 30;
                if(spaceXStart + buttonWidth > self.width)
                {
                    spaceXStart = 0;
                    spaceYStart = spaceYStart + 30 + 10;
                }
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button addTarget:self action:@selector(onCourseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button setTitle:course forState:UIControlStateNormal];
                [button setFrame:CGRectMake(spaceXStart, spaceYStart, buttonWidth, 30)];
                if([self.course isEqualToString:course])
                {
                    [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"F53757"] size:button.size cornerRadius:15] forState:UIControlStateNormal];
                }
                else
                {
                    [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"AAAAAA"] size:button.size cornerRadius:15] forState:UIControlStateNormal];
                }
                
                [self addSubview:button];
                
                if(_edit)
                {
                    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    [deleteButton setFrame:CGRectMake(button.right - 9, button.y - 9, 18, 18)];
                    [deleteButton setImage:[UIImage imageNamed:@"DeleteCourse"] forState:UIControlStateNormal];
                    [deleteButton addTarget:self action:@selector(onDeleteClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [self addSubview:deleteButton];
                    [_deleteButtons addObject:deleteButton];
                }
                
                UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
                [longPress setMinimumPressDuration:2];
                [button addGestureRecognizer:longPress];
                
                spaceXStart += innerMargin + buttonWidth;
            }
            else
            {
                if(spaceXStart + 60 > self.width)
                {
                    spaceXStart = 0;
                    spaceYStart += 30 + 10;
                }
                UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [addButton addTarget:self action:@selector(onAddButtonClicked) forControlEvents:UIControlEventTouchUpInside];
                [addButton setFrame:CGRectMake(spaceXStart, spaceYStart, 60, 30)];
                [addButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"AAAAAA"] size:addButton.size cornerRadius:15] forState:UIControlStateNormal];
                [addButton setImage:[UIImage imageNamed:@"AddCourse"] forState:UIControlStateNormal];
                [self addSubview:addButton];
                spaceXStart += innerMargin + 60;
            }
        }
        [self setHeight:MAX(self.height, spaceYStart + 30 + innerMargin)];
        if([self.delegate respondsToSelector:@selector(courseViewDidChange)])
            [self.delegate courseViewDidChange];
    }
}

- (void)onTap
{
    if(_edit)
    {
        _edit = NO;
        [self setupSubviews];
    }
}

- (void)onLongPress:(UILongPressGestureRecognizer *)longPress
{
    if(!_edit)
    {
        _edit = YES;
        [self setupSubviews];
    }
}

- (void)onCourseButtonClicked:(UIButton *)button
{
    if(!_edit)
    {
        NSString *course = [button titleForState:UIControlStateNormal];
        [self setCourse:course];
        [self setupSubviews];
    }
}

- (void)onDeleteClicked:(UIButton *)button
{
    NSInteger index = [_deleteButtons indexOfObject:button];
    NSString *course = [_courseArray objectAtIndex:index];
    [_courseArray removeObject:course];
    if(_courseArray.count == 0)
        _edit = NO;
    [self setupSubviews];
}

- (void)onAddButtonClicked
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    _replyBox = [[ReplyBox alloc] initWithFrame:CGRectMake(0, keyWindow.height - REPLY_BOX_HEIGHT, keyWindow.width, REPLY_BOX_HEIGHT)];
    [_replyBox setDelegate:self];
    [keyWindow addSubview:_replyBox];
    [_replyBox assignFocus];
}

- (void)onActionViewCommit:(NSString *)content
{
    if(content.length > 0)
    {
        BOOL contain = NO;
        for (NSString *course in _courseArray)
        {
            if([course isEqualToString:content])
                contain = YES;
        }
        if(!contain)
        {
            [_courseArray insertObject:content atIndex:0];
            NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
            [userdefaults setObject:_courseArray forKey:kCourseCacheKey];
        }
        [self setCourse:content];
        [self setupSubviews];
    }
    [_replyBox resignFocus];
    [_replyBox removeFromSuperview];
    _replyBox = nil;
}

- (void)onActionViewCancel
{
    [_replyBox resignFocus];
    [_replyBox removeFromSuperview];
    _replyBox = nil;
}

@end
@interface HomeWorkVC ()<ActionSelectViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>
@property (nonatomic, strong)NSMutableArray *courseArray;
@property (nonatomic, copy)NSString *course;
@property (nonatomic, strong)NSMutableArray *homeWorkArray;
@property (nonatomic, strong)HomeWorkItem *homeWorkItem;
@end

@implementation HomeWorkVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        self.homeWorkArray = [NSMutableArray array];
        [self addKeyboardNotifications];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"作业练习";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(onNext)];
    self.courseArray = [NSMutableArray array];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:_scrollView];
    
    UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectButton setFrame:CGRectMake(10, 25, self.view.width - 10 * 2, 30)];
    [selectButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"5ed016"] size:selectButton.size cornerRadius:15] forState:UIControlStateNormal];
    [selectButton setTitle:@"从我的作业库选择" forState:UIControlStateNormal];
    [selectButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [selectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectButton addTarget:self action:@selector(onSelectFromHistory) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:selectButton];
    
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(10, selectButton.bottom + 10, self.view.width - 10 * 2, _scrollView.height - (selectButton.bottom + 10) - 64 - 80)];
    [_contentView setBackgroundColor:[UIColor whiteColor]];
    [_contentView.layer setCornerRadius:10];
    [_contentView.layer setMasksToBounds:YES];
    [self setupContentView:_contentView];
    [_scrollView addSubview:_contentView];
    
    _courseView = [[CourseView alloc] initWithFrame:CGRectMake(10, _contentView.bottom + 10, self.view.width - 10 * 2, 60)];
    [_courseView setDelegate:self];
    [_scrollView setContentSize:CGSizeMake(self.view.width, MAX(_scrollView.height, _courseView.bottom))];
    [_scrollView addSubview:_courseView];
}

- (void)setupContentView:(UIView *)viewParent
{
    _textView = [[UTPlaceholderTextView alloc] initWithFrame:CGRectMake(10, 10, viewParent.width - 10 * 2, viewParent.height - 45 - 10)];
    [_textView setReturnKeyType:UIReturnKeyDone];
    [_textView setDelegate:self];
    [_textView setFont:[UIFont systemFontOfSize:14]];
    [_textView setPlaceholder:@"请输入文字内容"];
    [viewParent addSubview:_textView];
    
    UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, viewParent.height - 45, viewParent.width, kLineHeight)];
    [sepLine setBackgroundColor:kSepLineColor];
    [viewParent addSubview:sepLine];
    
    UIView* extraView = [[UIView alloc] initWithFrame:CGRectMake(0, sepLine.bottom, viewParent.width, 45)];
    [self setupExtraView:extraView];
    [viewParent addSubview:extraView];
}

- (void)setupExtraView:(UIView *)viewParent
{
    UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [hintLabel setFont:[UIFont systemFontOfSize:14]];
    [hintLabel setText:@"添加附件"];
    [hintLabel sizeToFit];
    [hintLabel setOrigin:CGPointMake(10, (viewParent.height - hintLabel.height) / 2)];
    [viewParent addSubview:hintLabel];
    
    UIButton*  addAudioButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addAudioButton setFrame:CGRectMake(viewParent.width - 45, 0, 45, 45)];
    [addAudioButton setImage:[UIImage imageNamed:@"HomeWorkAddAudio"] forState:UIControlStateNormal];
    [addAudioButton addTarget:self action:@selector(onAddAudio) forControlEvents:UIControlEventTouchUpInside];
    [viewParent addSubview:addAudioButton];
    
    UIButton*  addPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addPhotoButton setFrame:CGRectMake(addAudioButton.left - 45, 0, 45, 45)];
    [addPhotoButton setImage:[UIImage imageNamed:@"HomeWorkAddPhoto"] forState:UIControlStateNormal];
    [addPhotoButton addTarget:self action:@selector(onAddPhoto) forControlEvents:UIControlEventTouchUpInside];
    [viewParent addSubview:addPhotoButton];
}

- (void)onKeyboardWillShow:(NSNotification *)note
{
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    [UIView animateWithDuration:[duration floatValue] delay:0 options:curve.integerValue animations:^{
        [_scrollView setContentInset:UIEdgeInsetsMake(0, 0, keyboardBounds.size.height, 0)];
    } completion:nil];
}

- (void)onKeyboardWillHide:(NSNotification *)note
{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    [UIView animateWithDuration:[duration floatValue] delay:0 options:curve.integerValue animations:^{
        [_scrollView setContentInset:UIEdgeInsetsZero];
    } completion:nil];
}

- (void)onSelectFromHistory
{
    MyHomeworkList *homeWorkListVC = [[MyHomeworkList alloc] init];
    [homeWorkListVC setCompletion:^(HomeWorkHistoryItem *homeWorkItem)
     {
         
     }];
    TNBaseNavigationController *nav = [[TNBaseNavigationController alloc] initWithRootViewController:homeWorkListVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)onNext
{
    
}

- (void)onAddPhoto
{
    
}

- (void)onAddAudio
{
    PublishHomeWorkAudioVC *publishAudioVC = [[PublishHomeWorkAudioVC alloc] init];
    TNBaseNavigationController *nav = [[TNBaseNavigationController alloc] initWithRootViewController:publishAudioVC];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - CourseViewDelegate
- (void)courseViewDidChange
{
    [_scrollView setContentSize:CGSizeMake(_scrollView.width, MAX(_scrollView.height, _courseView.bottom))];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
