//
//  MJPhotoBrowser.m
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.

#import <QuartzCore/QuartzCore.h>
#import "MJPhotoBrowser.h"
#import "PhotoBrowserInfoBar.h"
#import "PhotoBrowserNavigationBar.h"

@interface MJPhotoBrowser()<PhotoBrowserNavigationBarDelegate>
{
    PhotoBrowserInfoBar *_infoBar;
    PhotoBrowserNavigationBar *_navBar;
    BOOL isHidden;
}

@end

@implementation MJPhotoBrowser

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _navBar = [[PhotoBrowserNavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
    [_navBar setDelegate:self];
    [self.view addSubview:_navBar];
    
    _infoBar = [[PhotoBrowserInfoBar alloc] initWithFrame:CGRectMake(0, self.view.height - 100, self.view.width, 100)];
    [self.view addSubview:_infoBar];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:42 / 255.0 green:42 / 255.0 blue:42 / 255.0 alpha:1.f]];
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [_flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [_flowLayout setItemSize:self.view.size];
    [_flowLayout setMinimumInteritemSpacing:0];
    [_flowLayout setMinimumLineSpacing:0];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:_flowLayout];
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    [_collectionView setShowsHorizontalScrollIndicator:NO];
    [_collectionView setPagingEnabled:YES];
    [_collectionView setDelegate:self];
    [_collectionView setDataSource:self];
    [_collectionView registerClass:[PhotoBrowseCell class] forCellWithReuseIdentifier:@"PhotoBrowseCell"];
    //    [_collectionView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [self.view insertSubview:_collectionView belowSubview:_navBar];
    
    //    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentPhotoIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    [_collectionView setContentOffset:CGPointMake(_collectionView.width * self.currentPhotoIndex, 0)];
    [self scrollViewDidScroll:_collectionView];
    isHidden = NO;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint contentOffset = [scrollView contentOffset];
    NSInteger index = (contentOffset.x + 1) / scrollView.width;
    self.currentPhotoIndex = index;
}

- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex
{
    _currentPhotoIndex = currentPhotoIndex;
    PhotoItem *photoItem = [self.photos objectAtIndex:_currentPhotoIndex];
    [_navBar setPhoto:photoItem];
    [_infoBar setPhotoItem:photoItem];
}

- (void)photoViewSingleTap:(MJPhotoView *)photoView
{
    if (isHidden) {
        isHidden = NO;
        [self showBars];
    }else{
        isHidden = YES;
        [self hideBars];
    }
}


- (void)showBars
{
    [UIView animateWithDuration:0.3 animations:^(void){
        CGRect bottomBarF = _infoBar.frame;
        bottomBarF.origin.y -= bottomBarF.size.height;
        _infoBar.frame = bottomBarF;
        CGRect topBarF = _navBar.frame;
        topBarF.origin.y += topBarF.size.height;
        _navBar.frame = topBarF;
    }completion:^(BOOL finished){
        if (finished) {
        }
    }];
}

- (void)hideBars
{
    [UIView animateWithDuration:0.3 animations:^(void){
        CGRect bottomBarF = _infoBar.frame;
        bottomBarF.origin.y += bottomBarF.size.height;
        _infoBar.frame = bottomBarF;
        CGRect topBarF = _navBar.frame;
        topBarF.origin.y -= topBarF.size.height;
        _navBar.frame = topBarF;
    }completion:^(BOOL finished){
        if (finished) {
        }
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoBrowseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoBrowseCell" forIndexPath:indexPath];
    [cell.photoView setPhotoViewDelegate:self];
    [cell setPhotoItem:self.photos[indexPath.row]];
    return cell;
}


#pragma mark - PhotoBrowserNavigationBarDelegate
- (void)didClickDeleteButton:(PhotoItem *)photoItem
{
    
    TNButtonItem *cancelItem = [TNButtonItem itemWithTitle:@"取消" action:nil];
    TNButtonItem *confirmItem = [TNButtonItem itemWithTitle:@"删除" action:^{
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:self.classID forKey:@"class_id"];
        [params setValue:photoItem.photoID forKey:@"picture_id"];
        MBProgressHUD *hud = [MBProgressHUD showMessag:@"正在删除照片" toView:self.view];
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"class/delete_picture" method:REQUEST_POST type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            [hud hide:YES];
            [MBProgressHUD showSuccess:@"删除成功" toView:self.view];
            NSInteger targetIndex = 0;
            if(self.photos.count > 1)
            {
                if(self.currentPhotoIndex == self.photos.count - 1)
                    targetIndex = self.currentPhotoIndex - 1;
                else
                    targetIndex = self.currentPhotoIndex;
                if([self.photos containsObject:photoItem])
                     [self.photos removeObject:photoItem];
                [self setCurrentPhotoIndex:targetIndex];
                [_collectionView reloadData];
                [_collectionView setContentOffset:CGPointMake(_collectionView.width * self.currentPhotoIndex, 0)];
            }
            else
            {
                if([self.photos containsObject:photoItem])
                     [self.photos removeObject:photoItem];
                [self.navigationController popViewControllerAnimated:YES];
            }
            if([self.delegate respondsToSelector:@selector(photoBrowserFinished:)])
                [self.delegate photoBrowserFinished:self.photos];
            if(self.deleteCallBack)
                self.deleteCallBack(1);
        } fail:^(NSString *errMsg) {
            [hud hide:YES];
            [MBProgressHUD showSuccess:errMsg toView:self.view];
        }];
    }];
    
    TNAlertView *alertView = [[TNAlertView alloc] initWithTitle:@"确定要删除照片吗?" buttonItems:@[cancelItem, confirmItem]];
    [alertView show];
}

- (void)didClickBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
