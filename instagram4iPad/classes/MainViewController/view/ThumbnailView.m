//
//  ThumbnailView.m
//  instagram4iPad
//
//  Created by Markus Emrich on 02.05.12.
//  Copyright (c) 2012 Markus Emrich. All rights reserved.
//

#import "ThumbnailView.h"

#define LOCATION_PIN_MARGIN 5

NSString* const DID_SELECT_THUMBNAIL_NOTIFICATION = @"DID_SELECT_THUMBNAIL_NOTIFICATION";

@implementation ThumbnailView

@synthesize photoData = mPhotoData;

- (id)init
{
    self = [super init];
    if (self) {
        mLocationLabel.text = @"";
        mLazyImage.delegate = self;
    }
    return self;
}

- (id)initWithPhotoData: (Photo*) photoData
{
    self = [self init];
    if (self) {
        self.photoData = photoData;
    }
    return self;
}

- (void)dealloc
{
    mPhotoData = nil;
}

#pragma mark -
#pragma mark access

- (void) setPhotoData:(Photo *)photoData
{
    mPhotoData = photoData;
    
    // get image data
    NSString* url    = [mPhotoData urlForPhotoType: ePhotoTypeThumbnail];
    CGSize imageSize = [mPhotoData sizeForPhotoType: ePhotoTypeThumbnail];
    
    // set size
    self.frameWidth = imageSize.width;
    self.frameHeight = imageSize.height;
    
    // fix location pin position and show, if available
    mLocationImage.frameRight = self.frameRight - LOCATION_PIN_MARGIN;
    mLocationImage.frameY     = LOCATION_PIN_MARGIN;
    mLocationImage.hidden = (photoData.location == nil);
    
    // show location text
    mLocationLabel.text = photoData.location;
    mLocationLabel.centerY = mLocationImage.centerY;
    mLocationLabel.frameY = floor(mLocationLabel.frameY);
    mLocationLabel.frameRight = mLocationImage.frameX - LOCATION_PIN_MARGIN;
    
    // setup placeholder and load image
    UIImage* placeholder = [UIImage imageNamed: @"ImageRect.png"];
    mLazyImage.imageView.image = [placeholder stretchableImageWithLeftCapWidth: 10 topCapHeight: 10];
    [mLazyImage loadImageFromUrlString: url];
    
    // add info text
    mLabel.text = photoData.formattedCommentsAndLikes;
}

#pragma mark -
#pragma mark lazy image delegate

- (void) lazyImageDidFailToLoadImageFromUrl:(NSString *)imageUrl
{
    // always retry loading
    [mLazyImage loadImageFromUrlString: imageUrl];
}

#pragma mark -
#pragma mark interaction

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    mOverlay.hidden = NO;
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    mOverlay.hidden = YES;
    
    // inform application
    NSDictionary* info = [NSDictionary dictionaryWithObject: mPhotoData forKey: @"data"];
    [[NSNotificationCenter defaultCenter] postNotificationName: DID_SELECT_THUMBNAIL_NOTIFICATION object: nil userInfo: info];
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    mOverlay.hidden = YES;
}

@end
