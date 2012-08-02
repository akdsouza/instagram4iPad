//
//  ImageListDataProvider.m
//  instagram4iPad
//
//  Created by Markus Emrich on 28.04.12.
//  Copyright (c) 2012 Markus Emrich. All rights reserved.
//

#import "ImageListDataProvider.h"

@implementation ImageListDataProvider

@synthesize photos = mPhotos;

- (id)init
{
    self = [super initWithUrl: INSTAGRAM_API_POPULAR];
    if (self) {
        [self switchToPopularPhotos];
    }
    return self;
}

- (void)dealloc
{
    mPhotos = nil;
    mNextURL = nil;
}

#pragma mark -
#pragma mark URL setup

- (void) switchToPopularPhotos;
{
    [self stopRequest];
    
    NSURL* url = [NSURL URLWithString: [NSString stringWithFormat: @"%@?client_id=%@", INSTAGRAM_API_POPULAR, INSTAGRAM_CLIENT_ID]];
    [mRequest setURL: url];
    
    // reset results
    mPhotos = nil;
    
    // reset caching
    mLastRequest = nil;
}

- (void) switchToCurrentUserWithAuthToken: (NSString*) authToken
{
    [self stopRequest];
    
    NSInteger imageCount = 50;
    NSString* urlString = [NSString stringWithFormat: @"%@?access_token=%@&count=%d", INSTAGRAM_API_MEDIA_SELF, authToken, imageCount];
    NSURL* url = [NSURL URLWithString: urlString];
    [mRequest setURL: url];
    
    // reset results
    mPhotos = nil;
    
    // reset caching
    mLastRequest = nil;
}

#pragma mark -
#pragma mark following requests

- (BOOL) moreImagesAvailable
{
    return (mNextURL != nil);
}

- (void) loadNext
{
    if (mNextURL != nil)
    {
        // set next url
        [mRequest setURL: [NSURL URLWithString: mNextURL]];
        
        // reset caching
        mLastRequest = nil;
        
        [self startRequest];
    }
}

#pragma mark -
#pragma mark parsing

- (BOOL) handleData:(NSDictionary *)dataDictionary
{
    NSInteger status = [[[dataDictionary objectForKey: @"meta"] objectForKey: @"code"] intValue];
    if (status >= 200 && status <= 299)
    {
        NSMutableArray* photoArray = [NSMutableArray array];
        NSArray* photoDictArray =[dataDictionary objectForKey: @"data"];
        for (NSDictionary* photoDict in photoDictArray) {
            [photoArray addObject: [[Photo alloc] initWithDictionary: photoDict]];
        }
        mPhotos = photoArray;
        mNextURL = [[dataDictionary objectForKey: @"pagination"] objectForKey: @"next_url"];
        
        // on popular photos, just reload on the same url
        if ([[[mRequest URL] absoluteString] hasPrefix: INSTAGRAM_API_POPULAR]) {
            mNextURL = [[mRequest URL] absoluteString];
        }
        
        return YES;
    }
    
    return NO;
}

@end
