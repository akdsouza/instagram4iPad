//
//  WebViewController.h
//  instagram4iPad
//
//  Created by Markus Emrich on 28.04.12.
//  Copyright (c) 2012 Markus Emrich. All rights reserved.
//


#import "BaseViewController.h"

static NSString* const INSTAGRAM_AUTH_WAS_SUCCESFULL_NOTIFICATION = @"INSTAGRAM_AUTH_WAS_SUCCESFULL_NOTIFICATION";


@interface WebViewController : BaseViewController <UIWebViewDelegate>
{
    __weak IBOutlet UIWebView *mWebView;
    __weak IBOutlet UIActivityIndicatorView* mIndicator;
    
    NSString* mURLToLoad;
    BOOL mShouldSendNotification;
}

@property (nonatomic, readonly) __weak UIWebView* webView;

- (id)initForInstagramAuthentification;
- (id)initWithURLString: (NSString*) urlString;

@end