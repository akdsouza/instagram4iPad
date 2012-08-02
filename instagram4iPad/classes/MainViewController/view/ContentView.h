//
//  ContentView.h
//  instagram4iPad
//
//  Created by Markus Emrich on 01.05.12.
//  Copyright (c) 2012 Markus Emrich. All rights reserved.
//

#import "ThumbnailView.h"

@interface ContentView : UIScrollView
{
    UIButton* mLoadMoreButton;
    
    NSMutableArray* mPhotoArray;
    NSInteger mPhotosInOneRow;
    CGFloat mCurrentMargin;
}

@property (nonatomic, readonly) UIButton* loadMoreButton;

- (void) showPhotos: (NSArray*) photos;
- (void) clear;

- (void) updateInsetsForHeaderHeight: (CGFloat) headerHeight;
- (void) relayout;

- (void) setButtonStateFinished;
- (void) setButtonStateLoading;

@end
