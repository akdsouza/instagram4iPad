//
//  MainViewController.h
//  instagram4iPad
//
//  Created by Markus Emrich on 28.04.12.
//  Copyright (c) 2012 Markus Emrich. All rights reserved.
//

#import "BaseViewController.h"
#import "UserInfoDataProvider.h"
#import "ImageListDataProvider.h"
#import "HeaderView.h"
#import "ContentView.h"

@interface MainViewController : BaseViewController <DataProviderDelegate>
{
    __weak IBOutlet HeaderView *mHeaderView;
    __weak IBOutlet ContentView *mContentView;
    __weak IBOutlet UIView *mActivityIndicatorView;
    
    UserInfoDataProvider* mUserInfoDataProvider;
    ImageListDataProvider* mImageListDataProvider;
}

- (void) connectToInstagram: (UIButton*) sender;
- (void) logout: (UIButton*) sender;
- (void) loadMoreImages: (UIButton*) sender;

@end
