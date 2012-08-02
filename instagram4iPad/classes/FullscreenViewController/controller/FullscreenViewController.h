//
//  FullscreenViewController.h
//  instagram4iPad
//
//  Created by Markus Emrich on 28.04.12.
//  Copyright (c) 2012 Markus Emrich. All rights reserved.
//


#import "BaseViewController.h"
#import "LazyImageView.h"
#import "Photo.h"
#import <MessageUI/MessageUI.h>

@interface FullscreenViewController : BaseViewController <LazyImageViewDelegate,
                                                          UIActionSheetDelegate,
                                                          MFMailComposeViewControllerDelegate>
{
    __weak IBOutlet LazyImageView *mLazyImage;
    __weak IBOutlet UILabel *mDescriptionLabel;
    __weak IBOutlet UILabel *mLocationLabel;
    
    Photo* mPhoto;
    
    BOOL mMailAvailable;
}

- (id) initWithPhoto: (Photo*) photoData;

- (IBAction) closeButtonTouched: (UIButton*)sender;
- (IBAction) shareButtonTouched: (UIButton*)sender;

@end