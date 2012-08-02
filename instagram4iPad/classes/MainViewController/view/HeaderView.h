//
//  HeaderView.h
//  instagram4iPad
//
//  Created by Markus Emrich on 01.05.12.
//  Copyright (c) 2012 Markus Emrich. All rights reserved.
//

#import "ViewLoadedFromNib.h"

typedef void (^AnimationsBlock) (BOOL);

@interface HeaderView : ViewLoadedFromNib
{
    __weak IBOutlet UIButton *mConnectButton;
    __weak IBOutlet UILabel  *mLabel;
    __weak IBOutlet UIImageView *mIcon;
    
    __weak IBOutlet UIView *mLogoutButtonBackground;
    __weak IBOutlet UIButton *mLogoutButton;
    
    NSInteger mOriginalHeight;
    NSInteger mOriginalLabelWidth;
}

@property (nonatomic, readonly) __weak UIButton* connectButton;
@property (nonatomic, readonly) __weak UIButton* logoutButton;

- (void) setLoggedInWithText: (NSString*) text withCompletion: (AnimationsBlock) completion;
- (void) setLoggedOutWithCompletion: (AnimationsBlock) completion;

- (void) setLabelText: (NSString*) text;

@end
