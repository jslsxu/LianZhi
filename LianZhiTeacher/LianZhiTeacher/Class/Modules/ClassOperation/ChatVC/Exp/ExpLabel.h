//
//  ExpLabel.h
// MFWIOS
//
//  Created by dong jianbo on 12-5-03.
//  Copyright (c) 2012年 mafengwo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpText.h"

@interface ExpLabel : UILabel {
	ExpText * expText;
	BOOL _autoHeight;
	BOOL _autoWidth;

}
@property(nonatomic,assign) BOOL autoHeight;
@property(nonatomic,assign) BOOL autoWidth;
@property(nonatomic,retain) ExpText * expText;

@end

@interface ExpSrcollLabel : ExpLabel {
	NSTimer *animationTimer;
	bool need_check;
	int offset_x;
}
@end