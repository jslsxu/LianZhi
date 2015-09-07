//
//  MFWFace.h
// MFWIOS
//
//  Created by dong jianbo on 12-5-24.
//  Copyright 2011 mafengwo. All rights reserved.
//

#import "MFWFace.h"

@interface MFWFace (FacePrivate)

+ (MFWFace *)sharedInstance;

-(NSArray*)faces;

@end

@implementation MFWFace (FacePrivate)
-(NSArray*)faces
{
    return faces;
}

+ (MFWFace *)sharedInstance
{
	static MFWFace *faceInstance = nil;
	if(faceInstance == nil)
	{
		faceInstance = [[MFWFace alloc] init];
	}
	return faceInstance;
}
@end

@implementation MFWFace

- (id)init
{
	self = [super init];
	if(self)
	{
        faces = [[NSArray alloc] initWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"emotions_cn.plist"]];
	}
	return self;
}

+ (NSInteger)numOfFaceInPage
{
    NSInteger coutPerRow = kScreenWidth / kFaceItemSize;
    return coutPerRow * 2;
}

+ (NSInteger)numOfPage
{
    NSInteger total = [MFWFace numberOfFace];
    NSInteger perPage = [MFWFace numOfFaceInPage];
    return (total + perPage) / perPage;
}

+ (NSUInteger)numberOfFace
{
    return [[MFWFace sharedInstance].faces count];
}

+ (NSString *)faceStringForIndex:(NSUInteger)index
{
    if (index < [[MFWFace sharedInstance].faces count])
    {
        return [[MFWFace sharedInstance].faces objectAtIndex:index];
    }
    
    return nil;
}

+ (NSUInteger)indexForFace:(NSString *)faceString
{
    return [[MFWFace sharedInstance].faces indexOfObject:faceString];
}


+ (BOOL) faceInFaces:(NSString *)faceString
{
    for (NSString *str in [MFWFace sharedInstance].faces) {
        if([str isEqualToString:faceString])
            return YES;
    }
    return NO;
}

@end
