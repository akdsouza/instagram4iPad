//
//  ImageListDataProvider.h
//  instagram4iPad
//
//  Created by Markus Emrich on 28.04.12.
//  Copyright (c) 2012 Markus Emrich. All rights reserved.
//

#import "JSONDataProvider.h"
#import "Photo.h"

@interface ImageListDataProvider : JSONDataProvider
{
    NSArray* mPhotos;
    NSString* mNextURL;
}

@property (nonatomic, readonly) NSArray* photos;

- (void) switchToPopularPhotos;
- (void) switchToCurrentUserWithAuthToken: (NSString*) authToken;

- (BOOL) moreImagesAvailable;
- (void) loadNext;

@end
