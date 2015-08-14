//
//  AlbumGroupView.m
//  LianZhiParent
//
//  Created by jslsxu on 15/3/11.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "AlbumGroupView.h"

@implementation AlbumItemCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {

        _albumCoverImage = [[UIImageView alloc] initWithFrame:CGRectMake(25, 15, 35, 35)];
        [_albumCoverImage setImage:[UIImage imageNamed:@"Icon.png"]];
        UIImageView *maskView = [[UIImageView alloc] initWithFrame:_albumCoverImage.bounds];
        [maskView setImage:[[UIImage imageNamed:(@"GrayBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
        [_albumCoverImage.layer setMask:maskView.layer];
        [_albumCoverImage setClipsToBounds:YES];
        [_albumCoverImage setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:_albumCoverImage];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_albumCoverImage.right + 5, 15, 200, 15)];
        [_titleLabel setText:@"树屋相册"];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_titleLabel];
        
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(_albumCoverImage.right + 5, 35, 200, 15)];
        [_numLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_numLabel setFont:[UIFont systemFontOfSize:13]];
        [self addSubview:_numLabel];
        
        _checkMark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AlbumCheckMark.png"]];
        [_checkMark setCenter:CGPointMake(self.width - _checkMark.width * 1.5, 30)];
        [self addSubview:_checkMark];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectZero];
        [_sepLine setFrame:CGRectMake(0, 60 - 0.5, self.width, 0.5)];
        [_sepLine setBackgroundColor:[UIColor colorWithHexString:@"d8d8d8"]];
        [self addSubview:_sepLine];
    }
    return self;
}

- (void)setGroup:(ALAssetsGroup *)group
{
    _group = group;
    if(_group)
    {
        [_albumCoverImage setImage:[UIImage imageWithCGImage:_group.posterImage]];
        [_titleLabel setText:[_group valueForProperty:ALAssetsGroupPropertyName]];
        [_numLabel setText:[NSString stringWithFormat:@"%ld张",(long)_group.numberOfAssets]];
    }
    else
    {
        [_titleLabel setText:@"树屋相册"];
    }
}

- (void)setTotal:(NSInteger)total
{
    _total = total;
    [_numLabel setText:[NSString stringWithFormat:@"%ld张",(long)_total]];
}

- (void)setIconUrl:(NSString *)iconUrl
{
    _iconUrl = iconUrl;
    [_albumCoverImage sd_setImageWithURL:[NSURL URLWithString:_iconUrl] placeholderImage:[UIImage imageNamed:@"Icon.png"]];
}

- (void)setAlbumSelected:(BOOL)albumSelected
{
    _albumSelected = albumSelected;
    [_checkMark setHidden:!_albumSelected];
}

@end

@implementation AlbumGroupView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self addSubview:_tableView];
        
        [self loadAssets];
    }
    return self;
}

- (void)reloadData
{
    [self loadAssets];
}

- (void)loadAssets
{
    if(_assetslibrary == nil)
        _assetslibrary = [[ALAssetsLibrary alloc] init];
    if(_albumGroups == nil)
        _albumGroups = [[NSMutableArray alloc] initWithCapacity:0];
    [_albumGroups removeAllObjects];
    ALAssetsFilter *filter = [ALAssetsFilter allPhotos];
    
    ALAssetsLibraryGroupsEnumerationResultsBlock resultsBlock = ^(ALAssetsGroup *group, BOOL *stop)
    {
        if (group)
        {
            [group setAssetsFilter:filter];
            if([group numberOfAssets] > 0)
            [_albumGroups addObject:group];
        }
        else
        {
            [_tableView reloadData];
        }
    };
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error)
    {
        
    };
    
    // Enumerate Camera roll first
    [_assetslibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                             usingBlock:resultsBlock
                                           failureBlock:failureBlock];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _albumGroups.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        static NSString *cellID = @"AlbumCellID";
        AlbumItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if(nil == cell)
        {
            cell = [[AlbumItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        [cell setTotal:self.total];
        [cell setIconUrl:self.iconUrl];
        [cell setAlbumSelected:self.selectedIndex == indexPath.row];
        return cell;
    }
    else
    {
        static NSString *cellID = @"AlbumItemCell";
        AlbumItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if(nil == cell)
        {
            cell = [[AlbumItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        if(indexPath.row > 0)
            [cell setGroup:_albumGroups[indexPath.row - 1]];
        [cell setAlbumSelected:self.selectedIndex == indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 0)
    {
        self.selectedIndex = 0;
        if([self.delegate respondsToSelector:@selector(albumGroupViewSelectedHostAlbum)])
        {
            [self.delegate albumGroupViewSelectedHostAlbum];
        }
    }
    else
    {
        self.selectedIndex = indexPath.row;
        if([self.delegate respondsToSelector:@selector(albumGroupViewSelectedSystemAlbum:)])
            [self.delegate albumGroupViewSelectedSystemAlbum:_albumGroups[indexPath.row - 1]];
    }
}

@end
