//
//  ThumbnailView.h
//  instagram4iPad
//
//  Created by Markus Emrich on 02.05.12.
//  Copyright (c) 2012 Markus Emrich. All rights reserved.
//

#import "ViewLoadedFromNib.h"
#import "LazyImageView.h"
#import "Photo.h"

extern NSString* const DID_SELECT_THUMBNAIL_NOTIFICATION;

@interface ThumbnailView : ViewLoadedFromNib <LazyImageViewDelegate>
{
    __weak IBOutlet LazyImageView* mLazyImage;
    __weak IBOutlet UILabel* mLabel;
    __weak IBOutlet UIImageView* mLocationImage;
    __weak IBOutlet UILabel *mLocationLabel;
    __weak IBOutlet UIView *mOverlay;
    
    Photo* mPhotoData;
}

@property (nonatomic, strong) Photo* photoData;

- (id)initWithPhotoData: (Photo*) photoData;

@end