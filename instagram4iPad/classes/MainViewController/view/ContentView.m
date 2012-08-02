//
//  ContentView.m
//  instagram4iPad
//
//  Created by Markus Emrich on 01.05.12.
//  Copyright (c) 2012 Markus Emrich. All rights reserved.
//

#import "ContentView.h"
#import "Photo.h"

#define MAXIMUM_IMAGE_COUNT_AT_ONCE 250

@implementation ContentView

@synthesize loadMoreButton = mLoadMoreButton;

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        mPhotoArray = [[NSMutableArray alloc] init];
        mLoadMoreButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [mLoadMoreButton setImage: [UIImage imageNamed: @"loadmore_button.png"] forState: UIControlStateNormal];
        [self setButtonStateFinished];
        [mLoadMoreButton sizeToFit];
        [mPhotoArray addObject: mLoadMoreButton];
        
        self.autoresizesSubviews = NO;
        self.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    }
    return self;
}

- (void)dealloc
{
    mPhotoArray = nil;
    mLoadMoreButton = nil;
}

#pragma mark -
#pragma mark access

- (void) showPhotos: (NSArray*) photos
{
    for (Photo* photo in photos)
    {
        // create thumbnail view
        ThumbnailView* thumbnail = [[ThumbnailView alloc] initWithPhotoData: photo];
        
        // add to layout array (before loadmore button)
        [mPhotoArray insertObject: thumbnail atIndex: [mPhotoArray count]-1];
        
        // fade in new photos
        thumbnail.alpha = 0;
        [UIView animateWithDuration: 0.5 animations:^{
            thumbnail.alpha = 1.0;
        }];
    }
    
    // remove previous images to stay below a defined limit of the photo count
    NSInteger count = [mPhotoArray count];
    if (count > MAXIMUM_IMAGE_COUNT_AT_ONCE) {
        NSInteger removeCount = count-MAXIMUM_IMAGE_COUNT_AT_ONCE;
        removeCount = removeCount - removeCount%mPhotosInOneRow;  // only remove full rows
        
        // remove views
        for (NSInteger i = 0; i<removeCount; i++) {
            [[mPhotoArray objectAtIndex: i] removeFromSuperview];
        }
        
        // remove from layout array
        [mPhotoArray removeObjectsInRange: NSMakeRange(0, removeCount)];
        
        // fix offset, so reloading behaviour is the same, as when nothing gets removed
        CGFloat rowCount  = floor(removeCount/mPhotosInOneRow);
        CGFloat offsetFix = rowCount * (mCurrentMargin + [[mPhotoArray objectAtIndex: 0] frameHeight]);
        self.contentOffset = CGPointMake(self.contentOffset.x, self.contentOffset.y-offsetFix);
    }
    
    [self relayout];
}

- (void) clear
{
    self.contentSize = CGSizeZero;
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration: 0.3 animations:^{
        for (UIView* view in mPhotoArray) {
            view.alpha = 0.0;
        }
    } completion:^(BOOL finished) {
        for (UIView* view in mPhotoArray) {
            [view removeFromSuperview];
        }
        [mPhotoArray removeAllObjects];
        self.userInteractionEnabled = YES;
        [mPhotoArray addObject: mLoadMoreButton];
        mLoadMoreButton.alpha = 1.0;
    }];
}

#pragma mark -
#pragma mark layout

- (void) updateInsetsForHeaderHeight: (CGFloat) headerHeight
{
    UIEdgeInsets insets = self.contentInset;
    insets.top = headerHeight;
    self.contentInset = insets;
    insets = self.scrollIndicatorInsets;
    insets.top = headerHeight;
    self.scrollIndicatorInsets = insets;
}

- (void) relayout
{
    if ([mPhotoArray count] <= 1) {
        return;
    }
    
    CGSize imageSize = [[mPhotoArray objectAtIndex: 0] frameSize];
    mPhotosInOneRow = floor(self.frameWidth/imageSize.width);
    mCurrentMargin  = floor(((int)self.frameWidth)%((int)imageSize.width) / (mPhotosInOneRow+1));
    CGPoint nextPosition = CGPointMake(mCurrentMargin, mCurrentMargin);
    
    for (UIView* view in mPhotoArray)
    {
        [self addSubview: view];
        view.frameOrigin = nextPosition;
        
        // jump to next position
        nextPosition.x += imageSize.width + mCurrentMargin;
        if (nextPosition.x + imageSize.width > self.frameWidth) {
            nextPosition.x = mCurrentMargin;
            nextPosition.y += imageSize.height + mCurrentMargin;
        }
    }
    
    if (nextPosition.x > mCurrentMargin) {
        nextPosition.y += imageSize.height + mCurrentMargin;
    }
    
    self.contentSize = CGSizeMake(self.frameWidth, nextPosition.y);
}

#pragma mark -
#pragma mark button helper

- (void) setButtonStateFinished
{
    [mLoadMoreButton setImage: [UIImage imageNamed: @"loadmore_button_finished.png"] forState: UIControlStateDisabled];
}

- (void) setButtonStateLoading
{
    [mLoadMoreButton setImage: [UIImage imageNamed: @"loadmore_button_loading.png"] forState: UIControlStateDisabled];
}

@end
