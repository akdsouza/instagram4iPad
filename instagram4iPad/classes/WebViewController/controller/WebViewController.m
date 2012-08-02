//
//  WebViewController.m
//  instagram4iPad
//
//  Created by Markus Emrich on 28.04.12.
//  Copyright (c) 2012 Markus Emrich. All rights reserved.
//

#import "WebViewController.h"
#import "SFHFKeychainUtils.h"
#import <QuartzCore/QuartzCore.h>


extern NSString* const INSTAGRAM_AUTH_WAS_SUCCESFULL_NOTIFICATION;


@interface WebViewController (hidden)
- (IBAction) closeButtonTouched: (UIButton*)sender;
- (NSString*) instagramAuthenticationURLString;

- (BOOL) checkRequestForCallbackURL: (NSURLRequest*) request;
- (void) handleAuth: (NSString*) authToken;
@end

@implementation WebViewController

@synthesize webView = mWebView;

- (id)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (id)initForInstagramAuthentification
{
    self = [self init];
    if (self) {
        mURLToLoad = [self instagramAuthenticationURLString];
    }
    return self;
}

- (id)initWithURLString: (NSString*) urlString
{
    self = [self init];
    if (self) {
        mURLToLoad = urlString;
    }
    return self;
}

- (void)dealloc
{
    mURLToLoad = nil;
}

#pragma mark -
#pragma mark lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    // style views
    [self.view viewWithTag: 99].layer.cornerRadius = 5;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    
    // load saved url
    if (mURLToLoad && !mWebView.isLoading) {
        [mWebView loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString: mURLToLoad]]];
        mURLToLoad = nil;
    }
}

#pragma mark -
#pragma mark delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    return [self checkRequestForCallbackURL: request];
}

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    [mIndicator startAnimating];
    [mWebView.layer removeAllAnimations];
    mWebView.userInteractionEnabled = NO;
    [UIView animateWithDuration: 0.3 animations:^{
        mWebView.alpha = 0.3;
    }];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [mIndicator stopAnimating];
    [mWebView.layer removeAllAnimations];
    mWebView.userInteractionEnabled = YES;
    [UIView animateWithDuration: 0.3 animations:^{
        mWebView.alpha = 1.0;
    }];
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self webViewDidFinishLoad: webView];
}

#pragma mark -
#pragma mark actions

- (IBAction) closeButtonTouched: (UIButton*)sender
{
    // dismiss self
    [self dismissViewControllerAnimated: YES completion: ^{
        if (mShouldSendNotification) {
            // send notification
            [[NSNotificationCenter defaultCenter] postNotificationName: INSTAGRAM_AUTH_WAS_SUCCESFULL_NOTIFICATION object: nil];
        }
    }];
}

#pragma mark -
#pragma mark auth logic

- (NSString*) instagramAuthenticationURLString
{
    // setup auth url
    NSString* baseURL = @"https://instagram.com/oauth/authorize/";
    NSString* scope   = @"likes+comments";
    NSString* authURL = [NSString stringWithFormat: @"%@?client_id=%@&redirect_uri=%@&response_type=token&scope=%@&DEBUG=True",
                         baseURL,
                         INSTAGRAM_CLIENT_ID,
                         INSTAGRAM_REDIRECT_URI,
                         scope];
    
    // return url string
    return authURL;
}

- (BOOL) checkRequestForCallbackURL: (NSURLRequest*) request
{
    NSString* urlString = [[request URL] absoluteString];
    
    // check, if auth was succesfull (check for redirect URL)
    if([urlString hasPrefix: INSTAGRAM_REDIRECT_URI])
    {
        // extract and handle access token
        NSRange range = [urlString rangeOfString: @"#access_token="];
        [self handleAuth: [urlString substringFromIndex: range.location+range.length]];
        return NO;
    }
    
    return YES;
}

- (void) handleAuth: (NSString*) authToken
{
    // save auth token
    BOOL success = [SFHFKeychainUtils storeAuthToken: authToken error: nil];
    
    // assert, if key isn't saved
    NSAssert(success, @"KEYCHAIN ERROR: Couldn't save auth token to keychain: %@", authToken);
    
    if (success) {
        // log success
        NSLog(@"received token and saved it to the keychain: %@", authToken);
        
        // send notification after modal animation finishes
        mShouldSendNotification = YES;
    }
    
    // close view after auth
    [self closeButtonTouched: nil];
}

@end


