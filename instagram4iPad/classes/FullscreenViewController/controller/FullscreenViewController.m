//
//  FullscreenViewController.m
//  instagram4iPad
//
//  Created by Markus Emrich on 28.04.12.
//  Copyright (c) 2012 Markus Emrich. All rights reserved.
//

#import "FullscreenViewController.h"
#import "WebViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface FullscreenViewController (hidden)
- (void) shareViaEmail;
- (void) showOnInstagramWebsite;
- (void) showInInstagramApp;
@end


@implementation FullscreenViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFormSheet;
        mLazyImage.delegate = self;
    }
    return self;
}

- (id) initWithPhoto: (Photo*) photoData
{
    self = [self init];
    if (self) {
        mPhoto = photoData;
    }
    return self;
}

- (void)dealloc
{
    mPhoto = nil;
}

#pragma mark -
#pragma mark lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    // style views
    [self.view viewWithTag: 99].layer.cornerRadius = 5;
    mLazyImage.imageView.contentMode = UIViewContentModeScaleAspectFill;
    mLazyImage.imageView.clipsToBounds = YES;
    
    // don't cache fullsize images
    mLazyImage.cacheEnabled = NO;
    
    if(mPhoto != nil) {
        [mLazyImage loadImageFromUrlString: [mPhoto urlForPhotoType: ePhotoTypeFullResolution]];
        
        // set description text
        mDescriptionLabel.text = mPhoto.caption;
        if(mPhoto.caption == nil) {
            mDescriptionLabel.text = NSLocalizedString(@"keyNoDescriptionInfo", nil);
        }
        [mDescriptionLabel alignTextVerticallyToTop];
        
        // set location text
        mLocationLabel.text = mPhoto.location;
        if(mPhoto.location == nil) {
            mLocationLabel.text = NSLocalizedString(@"keyNoLocationInfo", nil);
        }
    }
}

- (void)viewDidUnload
{
    mLazyImage = nil;
    mDescriptionLabel = nil;
    mLocationLabel = nil;
    [super viewDidUnload];
}

#pragma mark -
#pragma mark actions

- (IBAction) closeButtonTouched: (UIButton*)sender
{
    // dismiss self
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (IBAction) shareButtonTouched: (UIButton*)sender
{
    // check if mail can be sent
    NSString* mailKey = nil;
    if ([MFMailComposeViewController canSendMail]) {
        mailKey = NSLocalizedString(@"keyShareViaEmail", nil);
        mMailAvailable = YES;
    }
    
    // check if instagram is installed
    NSString* instagramAppKey = nil;
    if ([[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString: INSTAGRAM_URL_SCHEME]]) {
        instagramAppKey = NSLocalizedString(@"keyOpenInInstagramApp", nil);
    }
    
    // if mail isn't available, move instagram to second position
    if (mailKey == nil) {
        mailKey = instagramAppKey;
        instagramAppKey = nil;
    }
    
    // present action sheet with sharing options
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle: nil
                                                             delegate: self
                                                    cancelButtonTitle: NSLocalizedString(@"keyCancel", nil)
                                               destructiveButtonTitle: nil
                                                    otherButtonTitles: NSLocalizedString(@"keyOpenWebsite", nil),
                                                                       NSLocalizedString(@"keyCopyPhotoLink", nil),
                                                                       mailKey,
                                                                       instagramAppKey,
                                                                       nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showFromRect: sender.frame inView: self.view animated: YES];
}

#pragma mark -
#pragma mark action sheet delegate (sharing)

- (void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(actionSheet.cancelButtonIndex == buttonIndex)
        return;
    
    switch (buttonIndex) {
        case 0:
            [self showOnInstagramWebsite];
            break;
        case 1:
            [UIPasteboard generalPasteboard].string = mPhoto.link;
            break;
        case 2:
            // the third position can be mail OR instagram, so check it
            if (mMailAvailable) {
                [self shareViaEmail];
                break;
            }
        case 3:
            // if there are 4 buttons, it is the instagram key
            [self showInInstagramApp];
            break;
    }
}

- (void) shareViaEmail
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController* mailController = [[MFMailComposeViewController alloc] init];
        mailController.mailComposeDelegate = self;
        
        // set subject
        [mailController setSubject: [NSString stringWithFormat: NSLocalizedString(@"keyEmailSubjectFormat", nil), mPhoto.caption]];
        
        // attach image
        NSData* photoData = UIImageJPEGRepresentation(mLazyImage.imageView.image, 0.8);
        [mailController addAttachmentData: photoData mimeType: @"image/jpeg" fileName: @"photo.jpg"];
        
        // show mail composer
        [self presentModalViewController: mailController animated: YES];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissModalViewControllerAnimated: YES];
}

- (void) showOnInstagramWebsite
{
    WebViewController* webController = [[WebViewController alloc] initWithURLString: mPhoto.link];
    webController.modalPresentationStyle = UIModalPresentationPageSheet;
    [self presentModalViewController: webController animated: YES];
}

- (void) showInInstagramApp
{
    NSString* mediaID = mPhoto.mediaID;
    NSString* mediaUrl = [NSString stringWithFormat: INSTAGRAM_URL_SCHEME_MEDIA_FORMAT, mediaID];
    if ([[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString: mediaUrl]]) {
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: mediaUrl]];
    }
    
}

#pragma mark -
#pragma mark lazy image view delegate

- (void) lazyImageDidFailToLoadImageFromUrl:(NSString *)imageUrl
{
    // always retry loading
    [mLazyImage loadImageFromUrlString: imageUrl];
}

@end


