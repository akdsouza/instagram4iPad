//
//  LazyImageViewController.h
//  instagram4iPad
//
//  Created by Markus Emrich on 27.10.10.
//  Copyright 2010 Markus Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LazyImageView;

@protocol LazyImageViewDelegate <NSObject>

@optional
- (void) lazyImageWillLoadImageFromUrl: (NSString*) imageUrl;
- (void) lazyImageDidLoadNewImage: (LazyImageView*) imageView;
- (void) lazyImageDidFailToLoadImageFromUrl: (NSString*) imageUrl;

@end


@interface LazyImageView : UIView
{	
	UIImageView* mImageView;
	UIActivityIndicatorView* mActivityView;
	
	NSURLConnection *mConnection;
	NSMutableData * mReceivedData;
	NSString* mLastUsedUrl;
	
    BOOL mCacheEnabled;
    
	id<LazyImageViewDelegate> mDelegate;
}

@property (nonatomic, assign) id<LazyImageViewDelegate> delegate;
@property (nonatomic, readonly) UIImageView* imageView;
@property (nonatomic, assign) BOOL cacheEnabled;


- (id) init;
- (id) initAndLoad: (NSString *) urlString;

- (void) loadImageFromUrlString: (NSString *) urlString;
- (void) imageLoaded: (UIImage*) image;
- (void) imageLoadingFailed;

- (void) releaseConnectionAndData;

- (void) showActivityIndicator: (BOOL) showIndicator;

+ (void) clearImageCache;

@end
