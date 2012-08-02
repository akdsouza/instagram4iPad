//
//  MainViewController.m
//  instagram4iPad
//
//  Created by Markus Emrich on 28.04.12.
//  Copyright (c) 2012 Markus Emrich. All rights reserved.
//

#import "MainViewController.h"
#import "WebViewController.h"
#import "FullscreenViewController.h"
#import "SFHFKeychainUtils.h"

@interface MainViewController (hidden)
- (BOOL) loginSuccessfull;
@end

@implementation MainViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        // register for notifications
        [[NSNotificationCenter defaultCenter] addObserverForName: INSTAGRAM_AUTH_WAS_SUCCESFULL_NOTIFICATION
                                                          object: nil
                                                           queue: nil
                                                      usingBlock:^(NSNotification *note) {
                                                          [self loginSuccessfull];
                                                      }];
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(didSelectThumbnail:) 
                                                     name: DID_SELECT_THUMBNAIL_NOTIFICATION
                                                   object: nil];
        
        // init image data provider
        mImageListDataProvider = [[ImageListDataProvider alloc] init];
        mImageListDataProvider.delegate = self;
    }
    return self;
}

- (void)dealloc
{
    // remove notification observer
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    
    mUserInfoDataProvider  = nil;
    mImageListDataProvider = nil;
}

#pragma mark -
#pragma mark lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    // connect button actions
    [mHeaderView.connectButton   addTarget: self action: @selector(connectToInstagram:) forControlEvents: UIControlEventTouchUpInside];
    [mHeaderView.logoutButton    addTarget: self action: @selector(logout:)             forControlEvents: UIControlEventTouchUpInside];
    [mContentView.loadMoreButton addTarget: self action: @selector(loadMoreImages:)     forControlEvents: UIControlEventTouchUpInside];
    
    // setup activity view
    [mImageListDataProvider useActivityViewOnView: mActivityIndicatorView];
    
    // if auth token is already available, go on with succesfull login
    BOOL loggedIn = [self loginSuccessfull];
    
    if (!loggedIn) {
        // setup initial content insets
        [mContentView updateInsetsForHeaderHeight: mHeaderView.frameHeight];
        // start public photos request
        [mImageListDataProvider switchToPopularPhotos];
        [mImageListDataProvider startRequest];
    }
}

- (void)viewDidUnload
{
    mHeaderView = nil;
    mContentView = nil;
    
    mActivityIndicatorView = nil;
    [super viewDidUnload];
}

#pragma mark -
#pragma mark actions

- (void) connectToInstagram: (UIButton*)sender
{
    // show oauth login website
    WebViewController* webViewController = [[WebViewController alloc] initForInstagramAuthentification];
    [self presentViewController: webViewController animated: YES completion: nil];
}

- (BOOL) loginSuccessfull
{
    // check, if auth token was received
    NSString* savedAuthToken = [SFHFKeychainUtils authTokenWithError: nil];
    if (savedAuthToken == nil || [savedAuthToken isEmptyOrWhitespace]) {
        return NO;
    }
    
    // disable connect button
    mHeaderView.connectButton.enabled = NO;
    mHeaderView.connectButton.alpha = 0.5;
    
    // create user info dataprovider, if needed
    if (mUserInfoDataProvider == nil) {
        mUserInfoDataProvider = [[UserInfoDataProvider alloc] initWithAuthToken: savedAuthToken];
        mUserInfoDataProvider.delegate = self;
    }
    
    // prepare image dataProvider
    [mImageListDataProvider useActivityViewOnView: mActivityIndicatorView];
    [mImageListDataProvider switchToCurrentUserWithAuthToken: savedAuthToken];
    
    // start user info request
    [mUserInfoDataProvider startRequest];
    
    // remove public photos
    [mContentView clear];
    
    // remove cached images from memory
    [LazyImageView clearImageCache];
    
    return YES;
}

- (void) logout: (UIButton*) sender
{
    // remove saved auth token
    BOOL deleted = [SFHFKeychainUtils deleteAuthTokenWithError: nil];
    if (deleted) {
        
        // remove cached images from memory
        [LazyImageView clearImageCache];
        
        // remove saved cookies, so a new user can login
        #ifndef DEBUG_DONT_DELETE_COOKIES
            NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            for (NSHTTPCookie *cookie in [storage cookies]) {
                [storage deleteCookie:cookie];
            }
        #endif
        
        // enable connect button
        mHeaderView.connectButton.enabled = YES;
        mHeaderView.connectButton.alpha = 1.0;

        // display new state
        [mHeaderView setLoggedOutWithCompletion: ^(BOOL finished){
            [mContentView updateInsetsForHeaderHeight: mHeaderView.frameHeight];
            [mContentView clear];
            
            // start public photos request
            [mImageListDataProvider useActivityViewOnView: mActivityIndicatorView];
            [mImageListDataProvider switchToPopularPhotos];
            [mImageListDataProvider startRequest];
        }];
    }
}

- (void) loadMoreImages: (UIButton*) sender
{
    mContentView.loadMoreButton.enabled = NO;
    [mImageListDataProvider useActivityViewOnView: mContentView.loadMoreButton];
    [mImageListDataProvider loadNext];
}

#pragma mark -
#pragma mark thumbnail selection

- (void) didSelectThumbnail: (NSNotification*) notification
{
    Photo* photoData = [[notification userInfo] objectForKey: @"data"];
    
    FullscreenViewController* fullscreenController = [[FullscreenViewController alloc] initWithPhoto: photoData];
    [self presentViewController: fullscreenController animated: YES completion: nil];
}

#pragma mark -
#pragma mark dataProvider delegate

- (void) dataProviderHasDataReady:(DataProvider *)dataProvider
{
    if(dataProvider == mUserInfoDataProvider)
    {
        NSLog(@"Did read user info for %@", mUserInfoDataProvider.username);

        NSString* name       = mUserInfoDataProvider.username;
        NSInteger photoCount = mUserInfoDataProvider.photoCount;
        
        // display new state (logged in)
        NSString* loggedInInfo = [NSString stringWithFormat: NSLocalizedString(@"keyConnectWelcomeMessageFormat", nil), name, photoCount];
        [mHeaderView setLoggedInWithText: loggedInInfo withCompletion: ^(BOOL finished){
            [mContentView updateInsetsForHeaderHeight: mHeaderView.frameHeight];
            
            // start photos request
            [mImageListDataProvider startRequest];
        }];
    }
    
    else if(dataProvider == mImageListDataProvider)
    {
        NSLog(@"Received %d photos.", [mImageListDataProvider.photos count]);
        [mContentView showPhotos: mImageListDataProvider.photos];
        
        // enable load more button, in case more photos are available 
        mContentView.loadMoreButton.enabled = mImageListDataProvider.moreImagesAvailable;
        
        // update button state
        if(mImageListDataProvider.moreImagesAvailable) {
            [mContentView setButtonStateLoading];
        } else {
            [mContentView setButtonStateFinished];
        }
    }
}

- (void) dataProviderDidFail:(DataProvider *)dataProvider
{
    // TODO: notify user about error.
    
    if (dataProvider == mUserInfoDataProvider) {
        // retry request
        [mUserInfoDataProvider startRequestWithoutCaching];
    }
    
    else if (dataProvider == mImageListDataProvider) {
        mContentView.loadMoreButton.enabled = YES;
    }
}

#pragma mark -
#pragma mark rotation

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [UIView animateWithDuration: 0.3 animations:^{
        [mContentView relayout];
    }];
}

#pragma mark -
#pragma mark memory warning

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // remove cached images from memory
    [LazyImageView clearImageCache];
}

@end
