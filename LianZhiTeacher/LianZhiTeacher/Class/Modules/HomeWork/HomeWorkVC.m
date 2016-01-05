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
#import "HomeWorkAudioView.h"
#import "GrowthTimelineClassChangeVC.h"

@interface HomeWorkVC ()<ActionSelectViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>
{
    
}
@property (nonatomic, strong)NSMutableArray *courseArray;
@property (nonatomic, copy)NSString *course;
@property (nonatomic, strong)HomeWorkItem *homeWorkItem;
@property (nonatomic, strong)NSMutableArray*    photoArray;
@property (nonatomic, strong)NSData *audioData;
@property (nonatomic, assign)NSInteger timeSpan;
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
        self.photoArray = [NSMutableArray array];
        self.homeWorkItem = [[HomeWorkItem alloc] init];
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
    [self setupContentView];
    [_scrollView addSubview:_contentView];
    
    _courseView = [[CourseView alloc] initWithFrame:CGRectMake(10, _contentView.bottom + 10, self.view.width - 10 * 2, 60)];
    [_courseView setDelegate:self];
    [_scrollView setContentSize:CGSizeMake(self.view.width, MAX(_scrollView.height, _courseView.bottom))];
    [_scrollView addSubview:_courseView];
}

- (void)setupContentView
{
    UIView *viewParent = _contentView;
    __weak typeof(self) wself = self;
    [viewParent.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if(_textView == nil)
    {
        _textView = [[UTPlaceholderTextView alloc] initWithFrame:CGRectZero];
        [_textView setReturnKeyType:UIReturnKeyDone];
        [_textView setDelegate:self];
        [_textView setFont:[UIFont systemFontOfSize:14]];
        [_textView setPlaceholder:@"请输入文字内容"];
    }
    [viewParent addSubview:_textView];
    if(self.photoArray.count == 0 && self.audioData == nil && self.timeSpan == 0)
    {
        [_textView setFrame:CGRectMake(10, 10, viewParent.width - 10 * 2, viewParent.height - 45 - 10)];
        UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, viewParent.height - 45, viewParent.width, kLineHeight)];
        [sepLine setBackgroundColor:kSepLineColor];
        [viewParent addSubview:sepLine];
        
        UIView *extraView = [[UIView alloc] initWithFrame:CGRectMake(0, sepLine.bottom, viewParent.width, 45)];
        [self setupExtraView:extraView];
        [viewParent addSubview:extraView];
    }
    else if(self.photoArray.count > 0)
    {
        if(_photoView == nil)
        {
            _photoView = [[HomeWorkPhotoView alloc] initWithFrame:CGRectMake(10, viewParent.height - 110, viewParent.width - 10 * 2, 110)];
            [_photoView setCompletion:^{
                [wself setupContentView];
            }];
            [_photoView setAddCompletion:^{
                [wself onAddPhoto];
            }];
        }
        [_photoView setPhotoArray:self.photoArray];
        [viewParent addSubview:_photoView];
        [_textView setFrame:CGRectMake(10, 10, viewParent.width - 10 * 2, _photoView.y - 10 - 10)];
    }
    else
    {
        if(_audioView == nil)
        {
            _audioView = [[HomeWorkAudioView alloc] initWithFrame:CGRectMake(10, viewParent.height - 80 - 10, viewParent.width - 10 * 2, 80)];
            [_audioView setDeleteCompletion:^{
                wself.audioData = nil;
                wself.timeSpan = 0;
                [wself setupContentView];
            }];
        }
        [_audioView setAudioData:self.audioData];
        [_audioView setTimeSpan:self.timeSpan];
        [viewParent addSubview:_audioView];
        [_textView setFrame:CGRectMake(10, 10, viewParent.width - 10 * 2, _audioView.y - 10 - 10)];
    }
    
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
    __weak typeof(self) wself = self;
    MyHomeworkList *homeWorkListVC = [[MyHomeworkList alloc] init];
    [homeWorkListVC setCompletion:^(HomeWorkHistoryItem *homeWorkItem)
     {
         [CurrentROOTNavigationVC popToViewController:wself animated:YES];
     }];
    [CurrentROOTNavigationVC pushViewController:homeWorkListVC animated:YES];
}

- (void)onNext
{
    if(_courseView.course.length == 0)
    {
        [ProgressHUD showHintText:@"尚未选择作业所属科目"];
        return;
    }
    __weak typeof(self) wself = self;
    GrowthTimelineClassChangeVC *classChangeVC = [[GrowthTimelineClassChangeVC alloc] init];
    [classChangeVC setSelectionCompletion:^(NSString *targetStr) {
        [wself sendHomeWork];
    }];
    [CurrentROOTNavigationVC pushViewController:classChangeVC animated:YES];
}

- (void)sendHomeWork
{
    [CurrentROOTNavigationVC popToViewController:self animated:YES];
}

- (void)onAddPhoto
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setDelegate:self];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [imagePicker setAllowsEditing:YES];
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)onAddAudio
{
    __weak typeof(self) wself = self;
    PublishHomeWorkAudioVC *publishAudioVC = [[PublishHomeWorkAudioVC alloc] init];
    [publishAudioVC setCompletion:^(NSData *data, NSInteger timeSpan) {
        wself.audioData = data;
        wself.timeSpan = timeSpan;
        [wself setupContentView];
    }];
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

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    if(self.photoArray.count < 9)
    {
        [self.photoArray addObject:editedImage];
    }
    [self setupContentView];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
