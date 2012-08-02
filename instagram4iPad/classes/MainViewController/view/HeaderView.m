//
//  HeaderView.m
//  instagram4iPad
//
//  Created by Markus Emrich on 01.05.12.
//  Copyright (c) 2012 Markus Emrich. All rights reserved.
//

#import "HeaderView.h"
#import <QuartzCore/QuartzCore.h>

#define ICON_MARIGN 30
#define RESIZE_AMOUNT 30
#define ANIMATION_DURATION 0.3

@implementation HeaderView

@synthesize connectButton = mConnectButton;
@synthesize logoutButton  = mLogoutButton;

- (id)init
{
    self = [super init];
    if (self)
    {   
        // localize interface
        mLabel.text = NSLocalizedString(@"keyConnectToInstagramTitle", nil);
        [mConnectButton setTitle: NSLocalizedString(@"keyConnectToInstagramButtonTitle", nil) forState: UIControlStateNormal];
        
        // style views
        mLogoutButtonBackground.layer.cornerRadius = 5.0;
        
        // save frameHeight and labelwidth
        mOriginalHeight = self.frameHeight;
        mOriginalLabelWidth = mLabel.frameWidth;
    }
    return self;
}

- (void) setLoggedInWithText:(NSString *)text withCompletion: (AnimationsBlock) completion
{
    // animate framesize and fade out label & button
    [UIView animateWithDuration: 0.3 animations:^{
        self.frameHeight = mOriginalHeight - RESIZE_AMOUNT;
        mConnectButton.alpha = 0;
        mLabel.alpha = 0;
    } completion:^(BOOL finished) {
        
        // hide connect button completely
        mConnectButton.hidden = YES;
        
        // prepare fade in for logout button
        mLogoutButtonBackground.alpha = 0;
        mLogoutButtonBackground.hidden = NO;
        
        // update header label text & size
        [self setLabelText: text];
        
        // start next animation
        [UIView animateWithDuration: 0.3 animations:^{ 
            
            // reposition icon and fade in label with new text
            mIcon.frameX = mLabel.frameWidth + mLabel.frameX + ICON_MARIGN;
            mLabel.alpha = 1.0;
            
            mLogoutButtonBackground.alpha = 1.0;
        } completion: completion];
    }];
}

- (void) setLoggedOutWithCompletion: (AnimationsBlock) completion
{
    // animate framesize and fade out label
    [UIView animateWithDuration: ANIMATION_DURATION animations:^{
        self.frameHeight = mOriginalHeight;
        mLabel.alpha = 0;
        mLogoutButtonBackground.alpha = 0.0;
    } completion:^(BOOL finished) {
        
        // prepare fade in for connect button
        mConnectButton.alpha = 0;
        mConnectButton.hidden = NO;
        mLogoutButtonBackground.hidden = YES;
        
        // update header label text & size
        [self setLabelText: NSLocalizedString(@"keyConnectToInstagramTitle", nil)];
        
        // start next animation
        [UIView animateWithDuration: ANIMATION_DURATION animations:^{ 
            
            // reposition icon and fade in label with new text
            mIcon.frameX = mLabel.frameWidth + mLabel.frameX + ICON_MARIGN;
            mLabel.alpha = 1.0;
            mConnectButton.alpha = 1.0;
        } completion: completion];
    }];
}

- (void) setLabelText: (NSString*) text
{
    // remember orginal center
    CGFloat centerX = mLabel.centerX;
    
    // update text
    mLabel.text = text;
    
    // reset label width
    mLabel.frameWidth = mOriginalLabelWidth;
    
    // resize, to stay aligned to the top
    [mLabel alignTextVerticallyToTop];
    
    // stay centered horizontally and match text size
    [mLabel sizeToFit];
    
    // center again
    mLabel.centerX = centerX;
    
    // round changed values
    mLabel.frameHeight = floor(mLabel.frameHeight);
    mLabel.frameX      = floor(mLabel.frameX);
}

@end
