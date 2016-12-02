//
//  HomeworkResultView.m
//  LianZhiParent
//
//  Created by qingxu zhou on 16/10/14.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkResultView.h"
#import "HomeworkPhotoImageView.h"
@interface HomeworkResultView ()
@property (nonatomic, strong)NSMutableArray*    imageViewArray;
@end

@implementation HomeworkResultView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setBackgroundColor:[UIColor whiteColor]];
        self.imageViewArray = [NSMutableArray array];
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [_scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setAlwaysBounceVertical:YES];
        [self addSubview:_scrollView];
        
        [self setupSubviews];
    }
    return self;
}

- (void)setHomeworkItem:(HomeworkItem *)homeworkItem{
    _homeworkItem = homeworkItem;
    if([self.homeworkItem.mark_detail length] > 0 && !self.homeworkItem.s_answer.teacherMark){
        HomeworkTeacherMark *teacherMark = [HomeworkTeacherMark markWithString:self.homeworkItem.mark_detail];
        [self.homeworkItem.s_answer setTeacherMark:teacherMark];
    }
    [self setupSubviews];
}

- (void)setupSubviews{
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSInteger margin = 10;
    AvatarView* avatarView = [[AvatarView alloc] initWithRadius:25];
    [avatarView sd_setImageWithURL:[NSURL URLWithString:[UserCenter sharedInstance].curChild.avatar]];
    [avatarView setOrigin:CGPointMake(margin, margin)];
    [_scrollView addSubview:avatarView];
    
    UILabel* nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [nameLabel setFont:[UIFont systemFontOfSize:14]];
    [nameLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
    [nameLabel setText:[UserCenter sharedInstance].curChild.name];
    [nameLabel sizeToFit];
    [nameLabel setOrigin:CGPointMake(avatarView.right + margin, avatarView.top)];
    [_scrollView addSubview:nameLabel];
    
    NSMutableAttributedString *rateStr = [[NSMutableAttributedString alloc] initWithString:@"正确率: " attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"666666"]}];
    HomeworkTeacherMark *teacherMark = self.homeworkItem.s_answer.teacherMark;
    if(teacherMark){
        CGFloat wrongNum = 0;
        NSInteger totalCount = 0;
        for (HomeworkMarkItem *markItem in teacherMark.marks) {
            for (HomeworkPhotoMark *photoMark in markItem.marks) {
                totalCount ++;
                if(photoMark.markType == MarkTypeWrong){
                    wrongNum += 1;
                }
                else if(photoMark.markType == MarkTypeHalfRight){
                    wrongNum += 0.5;
                }
            }
        }
        CGFloat rightRate = (self.homeworkItem.enums - wrongNum) / self.homeworkItem.enums;
        rightRate = MAX(rightRate, 0);
        NSInteger percent = rightRate * 100;
        [rateStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%zd%%", percent] attributes:@{NSForegroundColorAttributeName : kCommonParentTintColor}]];
    }
    else{
        [rateStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"--" attributes:@{NSForegroundColorAttributeName : kCommonParentTintColor}]];
    }
    UILabel* rateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [rateLabel setFont:[UIFont systemFontOfSize:12]];
    [rateLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
    [rateLabel setAttributedText:rateStr];
    [rateLabel sizeToFit];
    [rateLabel setOrigin:CGPointMake(avatarView.right + margin, (avatarView.height - rateLabel.height) / 2 + margin)];
    [_scrollView addSubview:rateLabel];
    
    NSString* commitTimeStr = @"提交时间: ";
    if([self.homeworkItem.s_answer_time length] > 0){
        commitTimeStr = [NSString stringWithFormat:@"提交时间: %@", self.homeworkItem.s_answer_time];
    }
    UILabel* commitTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [commitTimeLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
    [commitTimeLabel setFont:[UIFont systemFontOfSize:12]];
    [commitTimeLabel setText:commitTimeStr];
    [commitTimeLabel sizeToFit];
    [commitTimeLabel setOrigin:CGPointMake(avatarView.right + margin, avatarView.bottom - commitTimeLabel.height)];
    [_scrollView addSubview:commitTimeLabel];
    
    NSString* commentStr = @"评语:";
    if([self.homeworkItem.s_answer.teacherMark.comment length] > 0){
        commentStr = [NSString stringWithFormat:@"评语:%@",self.homeworkItem.s_answer.teacherMark.comment];
    }
    UILabel* commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, avatarView.bottom + margin, _scrollView.width - margin * 2, 0)];
    [commentLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
    [commentLabel setFont:[UIFont systemFontOfSize:14]];
    [commentLabel setNumberOfLines:0];
    [commentLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [commentLabel setText:commentStr];
    [commentLabel sizeToFit];
    [_scrollView addSubview:commentLabel];
    
     NSInteger spaceYStart = commentLabel.bottom + margin;
    if([self.homeworkItem.s_answer.pics count] > 0){
        NSArray* marks = self.homeworkItem.s_answer.teacherMark.marks;
        for (NSInteger i = 0; i < [self.homeworkItem.s_answer.pics count]; i++) {
            PhotoItem *photoItem = self.homeworkItem.s_answer.pics[i];
            CGFloat width = _scrollView.width - margin * 2;
            CGFloat height = width * photoItem.height / photoItem.width;
            CGRect frame = CGRectMake(margin, spaceYStart, width, height);
            if([marks count] == 0){
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
                [imageView.layer setBorderColor:[UIColor colorWithHexString:@"f4f4f4"].CGColor];
                [imageView.layer setBorderWidth:kLineHeight];
                [imageView setBackgroundColor:[UIColor colorWithHexString:@"eeeeee"]];
                [imageView sd_setImageWithURL:[NSURL URLWithString:photoItem.big]];
                [imageView setContentMode:UIViewContentModeScaleAspectFill];
                [imageView setClipsToBounds:YES];
                [_scrollView addSubview:imageView];
                spaceYStart = imageView.bottom + margin;
            }
            else{
                HomeworkPhotoImageView *imageView = [[HomeworkPhotoImageView alloc] initWithFrame:frame];
                [imageView setMarkItem:marks[i]];
                [_scrollView addSubview:imageView];
                spaceYStart = imageView.bottom + margin;
            }
    
        }
    }
    [_scrollView setContentSize:CGSizeMake(_scrollView.width, spaceYStart)];
}


//- (void)showPhotoBrowser:(UITapGestureRecognizer *)sender {
//    PBViewController *pbViewController = [PBViewController new];
//    pbViewController.pb_dataSource = self;
//    pbViewController.pb_delegate = self;
//    pbViewController.pb_startPage = [self.imageViewArray indexOfObject:sender.view];
//    [CurrentROOTNavigationVC presentViewController:pbViewController animated:YES completion:nil];
//}
//
//- (NSInteger)numberOfPagesInViewController:(PBViewController *)viewController {
//    return self.imageViewArray.count;
//}
//
//- (void)viewController:(PBViewController *)viewController presentImageView:(UIImageView *)imageView forPageAtIndex:(NSInteger)index progressHandler:(void (^)(NSInteger, NSInteger))progressHandler {
//    PhotoItem *item = self.photoArray[index];
//    if(item.isLocal){
//        NSData *imageData = [NSData dataWithContentsOfFile:item.big];
//        [imageView setImage:[UIImage imageWithData:imageData]];
//    }
//    else{
//        UIImageView *curImageView = self.imageViewArray[index];
//        [imageView sd_setImageWithURL:[NSURL URLWithString:item.big]
//                     placeholderImage:curImageView.image
//                              options:0
//                             progress:progressHandler
//                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                            }];
//        
//    }
//    
//}
//
//- (UIView *)thumbViewForPageAtIndex:(NSInteger)index {
//    return self.imageViewArray[index];
//}
//
//#pragma mark - PBViewControllerDelegate
//
//- (void)viewController:(PBViewController *)viewController didSingleTapedPageAtIndex:(NSInteger)index presentedImage:(UIImage *)presentedImage {
//    [viewController dismissViewControllerAnimated:YES completion:nil];
//}
//
//- (void)viewController:(PBViewController *)viewController didLongPressedPageAtIndex:(NSInteger)index presentedImage:(UIImage *)presentedImage {
//    if(presentedImage){
//        LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:nil message:nil style:LGAlertViewStyleActionSheet buttonTitles:@[@"保存到相册"] cancelButtonTitle:@"取消" destructiveButtonTitle:nil];
//        [alertView setCancelButtonFont:[UIFont systemFontOfSize:18]];
//        [alertView setButtonsBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
//        [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
//        [alertView setActionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
//            [Utility saveImageToAlbum:presentedImage];
//        }];
//        [alertView showAnimated:YES completionHandler:nil];
//    }
//}

@end
