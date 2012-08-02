//
//  LazyImageViewController.m
//  instagram4iPad
//
//  Created by Markus Emrich on 27.10.10.
//  Copyright 2010 Markus Emrich. All rights reserved.
//

#import "LazyImageView.h"


@interface LazyImageView (hidden)
- (void) setup;
@end


static NSCache* staticImageCache;


@implementation LazyImageView

@synthesize delegate = mDelegate;
@synthesize imageView = mImageView;
@synthesize cacheEnabled = mCacheEnabled;

#pragma mark -
#pragma mark init

- (id) init
{
	self = [super initWithFrame: CGRectMake(0, 0, 40, 40)];
	if (self != nil)
	{
        [self setup];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) setup
{	
    mCacheEnabled = YES;
    
    mImageView = [[UIImageView alloc] initWithFrame: self.frame];
    mImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self addSubview: mImageView];
    
    mActivityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite];
    mActivityView.center = mImageView.center;
    mActivityView.hidesWhenStopped = YES;
    
    [self addSubview: mActivityView];
    
    [self showActivityIndicator: NO];
    
    mLastUsedUrl = [[NSString alloc] initWithString: @""];
    
    if (staticImageCache == nil) {
        staticImageCache = [[NSCache alloc] init];
    }
}

- (id) initAndLoad: (NSString *) urlString
{
	self = [self init];
	if (self != nil) {
		
		[self loadImageFromUrlString: urlString];
	}
	return self;
}


- (void)dealloc {
	
	[self releaseConnectionAndData];
	[mLastUsedUrl release];
	[mImageView release];
	[mActivityView release];
	
    [super dealloc];
}


- (void) setFrame: (CGRect)rect
{
	[super setFrame: rect];
	mImageView.frameSize = rect.size;
	
	mActivityView.center = mImageView.center;
}


#pragma mark -
#pragma mark load image from web

- (void) loadImageFromUrlString: (NSString *) urlString
{	
	if ([urlString length] == 0) {
		return;
	}
	
	[mLastUsedUrl release];
	mLastUsedUrl = [[NSString alloc] initWithString: urlString];
	
	[self releaseConnectionAndData];
	
	// check if cached image is available
	if (mCacheEnabled && [staticImageCache objectForKey: urlString] != nil) {
		[self imageLoaded: [staticImageCache objectForKey: urlString]];
		return;
	}
	
	//mImageView.image = nil;
	[self showActivityIndicator: YES];
	
	// inform delegate
	if (mDelegate && [mDelegate respondsToSelector: @selector(lazyImageWillLoadImageFromUrl:)]) {
		[mDelegate lazyImageWillLoadImageFromUrl: urlString];
	}
	
	NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:urlString] 
											  cachePolicy:NSURLRequestUseProtocolCachePolicy
										  timeoutInterval:10.0];
	
	mConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self startImmediately: NO];
	
	if(mConnection)
	{
		[mConnection scheduleInRunLoop: [NSRunLoop currentRunLoop] forMode: NSRunLoopCommonModes]; 
		[mConnection start]; 
		
		mReceivedData = [[NSMutableData data] retain];
	}
	else
	{
		//LOG(@"no connection");
	}
}


- (void) imageLoaded: (UIImage*) image;
{	
	mImageView.image = image;
	[self showActivityIndicator: NO];
	
	// inform delegate
	if (mDelegate && [mDelegate respondsToSelector: @selector(lazyImageDidLoadNewImage:)]) {
		[mDelegate lazyImageDidLoadNewImage: self];
	}
	
	[mImageView setNeedsDisplay];
}


- (void) imageLoadingFailed
{
	mImageView.image = [[UIImage imageNamed: @"ImageError.png"] stretchableImageWithLeftCapWidth: 5 topCapHeight: 5];
	[self showActivityIndicator: NO];
	[mImageView setNeedsDisplay];
	
	// inform delegate
	if (mDelegate && [mDelegate respondsToSelector: @selector(lazyImageDidFailToLoadImageFromUrl:)]) {
		[mDelegate lazyImageDidFailToLoadImageFromUrl: mLastUsedUrl];
	}
}


- (void) showActivityIndicator: (BOOL) showIndicator
{	
	//mImageView.hidden = showIndicator;
	
	if (showIndicator)
	{		
		[mActivityView startAnimating];
	}
	else
	{		
		[mActivityView stopAnimating];
	}
}

#pragma mark -
#pragma mark cache

+ (void) clearImageCache
{
    if (staticImageCache != nil) {
        [staticImageCache removeAllObjects];
    }
}

#pragma mark -
#pragma mark NSURLConnection delegates

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [mReceivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[self releaseConnectionAndData];
	
	[self imageLoadingFailed];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	// LOG(@"Succeeded! Received %d bytes of data", [mReceivedData length]);
	
	UIImage * loadedImage = [UIImage imageWithData: mReceivedData];
	
	if (loadedImage) {
		
		// LOG(@"Succesfully loaded Image. Now showing.");
		
        if (mCacheEnabled) {
            [staticImageCache setObject: loadedImage forKey: mLastUsedUrl];
        }
		
		[self imageLoaded: loadedImage];
	}
	else
	{
		// LOG(@"Couldn't create image from received data.");
		
		[self imageLoadingFailed];
	}
	
	[self releaseConnectionAndData];
}

#pragma mark -

- (void) releaseConnectionAndData
{
	if (mConnection) {
		[mConnection unscheduleFromRunLoop: [NSRunLoop currentRunLoop] forMode: NSRunLoopCommonModes];
		[mConnection cancel];
	}
	[mConnection release];
	[mReceivedData release];
	
	mConnection = nil;
	mReceivedData = nil;
}


@end
