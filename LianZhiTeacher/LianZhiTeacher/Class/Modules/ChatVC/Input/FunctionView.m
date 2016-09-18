//
//  FunctionView.m
//  LianZhiParent
//
//  Created by jslsxu on 15/9/5.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "FunctionView.h"

@implementation FunctionItem

+ (FunctionItem *)functionItemWithTitle:(NSString *)title image:(NSString *)image type:(FunctionType)functionType{
    FunctionItem *item = [FunctionItem new];
    [item setTitle:title];
    [item setImage:image];
    [item setFunctionType:functionType];
    return item;
}

@end

@implementation FunctionItemCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - 60) / 2, 10, 60, 60)];
        [self addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, self.width, 20)];
        [_titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_titleLabel];
    }
    return self;
}

- (void)setFunctionItem:(FunctionItem *)functionItem{
    _functionItem = functionItem;
    [_imageView setImage:[UIImage imageNamed:_functionItem.image]];
    [_titleLabel setText:_functionItem.title];
}


@end

@interface FunctionView ()
@property (nonatomic, strong)NSMutableArray*    functionArray;
@end

@implementation FunctionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        NSInteger itemWIdth = 75;
        UICollectionViewFlowLayout *_layout = [[UICollectionViewFlowLayout alloc] init];
        [_layout setItemSize:CGSizeMake(itemWIdth, itemWIdth + 15)];
        NSInteger numPerRow = kScreenWidth / itemWIdth;
        NSInteger hMargin = (kScreenWidth - numPerRow * itemWIdth) / 4;
        [_layout setSectionInset:UIEdgeInsetsMake(0, hMargin, 0, hMargin)];
        [_layout setMinimumInteritemSpacing:0];
        [_layout setMinimumLineSpacing:0];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_layout];
        [_collectionView setScrollsToTop:NO];
        [_collectionView setAlwaysBounceHorizontal:YES];
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        [_collectionView registerClass:[FunctionItemCell class] forCellWithReuseIdentifier:@"FunctionItemCell"];
        [self addSubview:_collectionView];
    }
    return self;
}

- (void)setCanCalltelephone:(BOOL)canCalltelephone{
    _canCalltelephone = canCalltelephone;
    [self updateSubviews];
}

- (void)setCanSendGift:(BOOL)canSendGift{
    _canSendGift = canSendGift;
    [self updateSubviews];
}

- (NSMutableArray *)functionArray{
    if(_functionArray == nil){
        _functionArray = [NSMutableArray array];
        [_functionArray addObject:[FunctionItem functionItemWithTitle:@"发照片" image:@"FunctionAlbum" type:FunctionTypePhoto]];
        [_functionArray addObject:[FunctionItem functionItemWithTitle:@"拍照片" image:@"FunctionCamera" type:FunctionTypeCamera]];
        [_functionArray addObject:[FunctionItem functionItemWithTitle:@"小视频" image:@"FunctionVideo" type:FunctionTypeShortVideo]];
    }
    return _functionArray;
}


- (void)updateSubviews{
    if(self.canSendGift){
        if(![self supportType:FunctionTypeSendGift])
            [_functionArray addObject:[FunctionItem functionItemWithTitle:@"发礼物" image:@"FunctionGift" type:FunctionTypeSendGift]];
    }
    if(self.canCalltelephone){
        if(![self supportType:FunctionTypeTelephone])
            [_functionArray addObject:[FunctionItem functionItemWithTitle:@"打电话" image:@"FunctionPhone" type:FunctionTypeTelephone]];
    }
    [_collectionView reloadData];
}

- (BOOL)supportType:(FunctionType)functionType{
    for (FunctionItem *item in self.functionArray) {
        if(functionType == item.functionType)
            return YES;
    }
    return NO;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.functionArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FunctionItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FunctionItemCell" forIndexPath:indexPath];
    [cell setFunctionItem:self.functionArray[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.delegate respondsToSelector:@selector(functionViewDidSelectWithType:)]){
        FunctionItem *item = self.functionArray[indexPath.row];
        [self.delegate functionViewDidSelectWithType:item.functionType];
    }
}


@end
