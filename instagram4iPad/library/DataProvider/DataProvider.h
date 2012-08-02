//
//  DataProvider.h
//
//  Created by Markus Emrich on 26.10.10.
//  Copyright 2010 Markus Emrich. All rights reserved.
//
//
//	A DataProvider holds an URLRequest, to load data from an URL asynchronous.
//  To use it, you have to use a subclass (which implements handleRawData)
//
//  The DataProvider supports "caching":
//	The Data wil be "cached", if cachingEnabled is set to YES (default is YES).
//	That means, if startRequest is called shortly after a previous call, no
//	new data will be fetched from the server. Anyway the delegate will be informed
//	with that new data is available (dataProviderHasDataReady:). The property
//	isDataCachedData can be used, to distinguish between these cases. 
// 
//  The DataProvider supports an activity view:
//  An activity view will be shown, while the DataProvider is loading
//	or handling	new data received from the given url. Use the property
//	activityView to set any view as activity view. Call useActivityViewOnView:
//	to define, where to show the activity view.
//
//
//

@class DataProvider;

#pragma mark Delegate

/**
 *
 *	@delegate DataProviderDelegate
 *
 *	The DataProviderDelegate can be used, to react on the state of the connection.
 *
 */
@protocol DataProviderDelegate <NSObject>

@optional

/**
 *	Will be called, if the connection did fail, or if handleRawData returns NO.
 *
 *	@param dataProvider
 *	The corresponding DataProvider
 */
- (void) dataProviderDidFail: (DataProvider*) dataProvider;

/**
 *	Will be called, if the connection was stopped by calling stop: on the DataProvider.
 *
 *	@param dataProvider
 *	The corresponding DataProvider
 */
- (void) dataProviderWasStopped: (DataProvider*) dataProvider;

/**
 *	Will be called, if the DataProvider is about to load new data.
 *
 *	@param dataProvider
 *	The corresponding DataProvider
 */
- (void) dataProviderWillLoadData: (DataProvider*) dataProvider;

/**
 *	Will be called, if the dataProvider has successfully handled the received data.
 *	This means, it will only be called, if handleRawData returns YES.
 *
 *	@param dataProvider
 *	The corresponding DataProvider
 */
- (void) dataProviderHasDataReady: (DataProvider*) dataProvider;

@end


#pragma mark -

/**
 *
 *	@class DataProvider
 *
 *	A DataProvider holds an URLRequest, to load data from an URL asynchronous.
 *  To use it, you have to use a subclass (which implements handleRawData)
 *
 *  The DataProvider supports "caching":
 *	The Data wil be "cached", if cachingEnabled is set to YES (default is YES).
 *	That means, if startRequest is called shortly after a previous call, no
 *	new data will be fetched from the server. Anyway the delegate will be informed
 *	with that new data is available (dataProviderHasDataReady:). The property
 *	isDataCachedData can be used, to distinguish between these cases. 
 *  
 *  The DataProvider supports an activity view:
 *  An activity view will be shown, while the DataProvider is loading
 *	or handling	new data received from the given url. Use the property
 *	activityView to set any view as activity view. Call useActivityViewOnView:
 *	to define, where to show the activity view.
 *
 */
@interface DataProvider : NSObject
{	
	NSDate* mLastRequest;
	BOOL mCachingEnabled;
	BOOL mIsDataCachedDated;
	NSInteger mCachingDuration;
	
	NSMutableURLRequest* mRequest;
	NSURLConnection* mConnection;
	NSMutableData* mURLConnectionData;
	
	id<DataProviderDelegate> mDelegate;
	
	UIView* mActivityView;
}

#pragma mark -
#pragma mark Properties

/**
 *	@property delegate
 *	The DataProviderDelegate, which will be informed about changes of the loading process.
 *	The delegate will only be assigned, you have to make sure, that it is alive as
 *  long, as the DataProvider is alive.
 */
@property (nonatomic, assign) id<DataProviderDelegate> delegate;

/**
 *	@property activityView
 *	This view will be used as activity view. That means, it shows up
 *	while the DataProvider is receiving or handling data.
 */
@property (nonatomic, retain) UIView* activityView;

/**
 *	@property cachingEnabled
 *	This property toggles caching. If no caching is active, every call of startRequest:
 *	will send a request to the URL. See details in class description.
 */
@property (nonatomic, assign)	BOOL cachingEnabled;

/**
 *	@property isDataCachedDated
 *	This property can be used to distinguish, if the current data is
 *  based on a new real request, or old/"cached".
 */
@property (nonatomic, readonly) BOOL isDataCachedDated;

/**
 *	@property cachingDuration
 *	This property defines the time in seconds, how often a new
 *  request is possible. If caching is disabled, this property
 *	has no effect. Otherwise it controls, if a new request will
 *	be sent, or not by calling startRequest:
 */
@property (nonatomic, assign)	NSInteger cachingDuration;

#pragma mark -
#pragma mark Initialization

/**
 *	Returns an initialized DataProvider with a connection timeout set to 60 seconds.
 *
 *	@param urlString
 *	The URL from where data should be loaded
 */
- (id) initWithUrl: (NSString*) urlString;

/**
 *	Returns an initialized DataProvider with a connection timeout set to timeInterval.
 *
 *	@param urlString
 *	The URL from where data should be loaded.
 *
 *	@param timeInterval
 *	The timeout in seconds, how long the DataProvider will try to load data at most.
 *	
 */
- (id) initWithUrl: (NSString*) urlString andTimeOutInterval: (NSTimeInterval) timeInterval;


#pragma mark -
#pragma mark Controlling the Request

/**
 *
 *	A new Request will be sent to the given URL. If data is received, the delegate
 *	will be informed, that new data is available (dataProviderHasDataReady:)
 *  If caching is enabled (it is enabled by default), a new request will only be sent,
 *	if the time of the last request was more than cachingDuration seconds ago.
 *	The delegate will be informed about new data anyway.
 *
 */
- (void) startRequest;

/**
 *
 *	A new Request will be sent to the given URL. If data is received, the delegate
 *	will be informed, that new data is available (dataProviderHasDataReady:)
 *	The caching setting will be ignored in this method.
 *
 */
- (void) startRequestWithoutCaching;

/**
 *
 *	If a request is running, it will be canceled. The delegate will be
 *	informed through dataProviderWasStopped:
 *
 */
- (void) stopRequest;

/**
 *
 *	The caching will be resetted. So the following call of startRequest:
 *	will sent a request to the server definitely. 
 *
 */
- (void) resetCaching;

#pragma mark -
#pragma mark Activity View

/**
 *
 *	This will set a view as activity view, which will always show up,
 *	while the DataProvider is loading or handling data from the server.
 *	You have to call useActivityViewOnView: to setup, where the view should
 *	show up.
 *
 */
- (void) setActivityView: (UIView *) aView;

/**
 *
 *	This will add the activityView to the center of the given view and hide it.
 *	It will only show up, while the DataProvider is loading or handling data from
 *	the server.
 *
 */
- (void) useActivityViewOnView: (UIView*) view;

#pragma mark -
#pragma mark protected methods

/**
 * 
 * This method is called, when data transmission did finish.
 * Subclasses should override this method to handle the data.
 * 
 * @param data
 * The data, which was received from the server
 * 
 * @return
 * If you return NO the DataProvider will send dataProviderDidFail
 * to its delegate, else it will send dataProviderHasDataReady;
 * 
 */
- (BOOL) handleRawData: (NSData*) data;


@end
