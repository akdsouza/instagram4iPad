//
//  DataProvider.m
//
//  Created by Markus Emrich on 26.10.10.
//  Copyright 2010 Markus Emrich. All rights reserved.
//

#import "DataProvider.h"

#pragma mark -
#pragma mark private methods

@interface DataProvider (private)

- (void) cleanConnectionAndData;
- (void) informDelegate: (SEL) selector;

@end

#pragma mark -

@implementation DataProvider

#pragma mark -
#pragma mark properties

@synthesize delegate = mDelegate;
@synthesize activityView = mActivityView;

@synthesize cachingEnabled = mCachingEnabled;
@synthesize isDataCachedDated = mIsDataCachedDated;
@synthesize cachingDuration = mCachingDuration;

#pragma mark -
#pragma mark alloc/dealloc

- (id) initWithUrl: (NSString*) urlString
{
	return [self initWithUrl: urlString andTimeOutInterval: 20.0];
}

- (id) initWithUrl: (NSString*) urlString andTimeOutInterval: (NSTimeInterval) timeInterval
{
	self = [super init];
	if (self != nil)
	{
		NSURL* aURL = [NSURL URLWithString: urlString];
		mRequest = [[NSMutableURLRequest alloc] initWithURL: aURL cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: timeInterval];
		mCachingEnabled = YES;
		mIsDataCachedDated = NO;
		mCachingDuration = 180.0;
        
        // setup default activity view
        UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite];
        indicator.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
        indicator.hidesWhenStopped = NO;
        [indicator startAnimating];
        mActivityView = indicator;
	}
	
	return self;
}

- (void) dealloc
{
	[mLastRequest release];
	[mRequest release];
	
	if (mActivityView != nil) {
		[mActivityView removeFromSuperview];
		[mActivityView release];
	}
	
	[self cleanConnectionAndData];
	
	[super dealloc];
}


#pragma mark -
#pragma mark connection

- (void) connection: (NSURLConnection*) connection didReceiveData: (NSData*) data
{
	[mURLConnectionData appendData: data];
}

- (void) connectionDidFinishLoading: (NSURLConnection*) connection
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
	if (mActivityView != nil) {
		mActivityView.hidden = YES;
	}
	
	mIsDataCachedDated = NO;
	BOOL success = [self handleRawData: mURLConnectionData];
	
	[self cleanConnectionAndData];
	
	if (success)
	{
		[self informDelegate: @selector(dataProviderHasDataReady:)];
		
		[mLastRequest release];
		mLastRequest = [[NSDate date] retain];
	}
	else
	{
		[self informDelegate: @selector(dataProviderDidFail:)];
	}
}

- (void) connection: (NSURLConnection*) connection didFailWithError: (NSError*) error
{
	LOG(@"%@", error);
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
	if (mActivityView != nil) {
		mActivityView.hidden = YES;
	}
	
	// inform delegate
	[self informDelegate: @selector(dataProviderDidFail:)];
	
	[self cleanConnectionAndData];
}

- (void) cleanConnectionAndData
{
	if (mConnection)
	{
		[mConnection cancel];
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
		if (mActivityView != nil) {
			mActivityView.hidden = YES;
		}
	}
	
	[mConnection release];
	[mURLConnectionData release];
	mURLConnectionData = nil;
	mConnection = nil;
}

#pragma mark -
#pragma mark public methods / external access

- (void) startRequest
{
	// Caching: no new requests for 'mCachingDuration' seconds
	if (mCachingEnabled && mLastRequest &&[[NSDate date] timeIntervalSinceDate: mLastRequest] < mCachingDuration)
	{
		mIsDataCachedDated = YES;
		
		[self informDelegate: @selector(dataProviderHasDataReady:)];
		return;
	}
	
	[self startRequestWithoutCaching];
}

- (void) startRequestWithoutCaching
{
	// If a connection is running, don't start another one
	if (mConnection != nil)
		return;
	
	// Setup connection
	mConnection = [[NSURLConnection alloc] initWithRequest: mRequest delegate: self];
	
	// Check if connection is ok
	if (!mConnection)
	{
		// inform delegate
		[self informDelegate: @selector(dataProviderDidFail:)];
		return;
	}
	
	mURLConnectionData = [[NSMutableData alloc] initWithLength: 0];
	
	// Inform delegate
	[self informDelegate: @selector(dataProviderWillLoadData:)];
	
	// Start connection
	[mConnection start];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
	if (mActivityView != nil) {
		mActivityView.hidden = NO;
	}
}

- (void) stopRequest
{
	if (mConnection)
	{
		[self cleanConnectionAndData];
		
		// Inform delegate
		[self informDelegate: @selector(dataProviderWasStopped:)];
	}
}


// Reset last request value, so no caching will be used
- (void) resetCaching
{
	[mLastRequest release];
	mLastRequest = nil;
}


- (BOOL) handleRawData: (NSData*) data
{	
	return YES;
}

#pragma mark -
#pragma mark activity view

- (void) setActivityView: (UIView *) aView
{
	if (mActivityView != nil) {
		[mActivityView removeFromSuperview];
	}
	
	[aView retain];
	[mActivityView release];
	mActivityView = aView;
	
	mActivityView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
									 UIViewAutoresizingFlexibleTopMargin  | UIViewAutoresizingFlexibleBottomMargin;
	mActivityView.hidden = YES;
}

- (void) useActivityViewOnView: (UIView*) view
{
	if (mActivityView == nil) {
		return;
	}
	
    mActivityView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin |
                                     UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
	mActivityView.center = CGPointMake(view.frameWidth/2.0, view.frameHeight/2.0);
	[view addSubview: mActivityView];
}


#pragma mark -
#pragma mark helper


- (void) informDelegate: (SEL) selector
{
	if (mDelegate != nil && [mDelegate respondsToSelector: selector])
	{
		[mDelegate performSelector: selector withObject: self];
	}
}

@end