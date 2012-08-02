//
//  UserInfoDataProvider.m
//  instagram4iPad
//
//  Created by Markus Emrich on 28.04.12.
//  Copyright (c) 2012 Markus Emrich. All rights reserved.
//

#import "UserInfoDataProvider.h"

@implementation UserInfoDataProvider

@dynamic username;
@dynamic photoCount;

- (id) initWithAuthToken: (NSString*) authToken
{
    if (!authToken) {
        return nil;
    }
    
    return [super initWithUrl: [NSString stringWithFormat: @"%@?access_token=%@", INSTAGRAM_API_USER_SELF, authToken]];
}

- (void)dealloc
{
    mData = nil;
}

#pragma mark -
#pragma mark parsing

- (BOOL) handleData:(NSDictionary *)dataDictionary
{
    NSInteger status = [[[dataDictionary objectForKey: @"meta"] objectForKey: @"code"] intValue];
    if (status >= 200 && status <= 299)
    {
        mData = dataDictionary;
        return YES;
    }
    
    return NO;
}

#pragma mark -
#pragma mark access

- (NSString*) username
{
    if (!mData) {
        return nil;
    }
    
    return [[mData objectForKey: @"data"] objectForKey: @"full_name"];
}

- (NSInteger) photoCount
{
    if (!mData) {
        return 0;
    }
    
    return [[[[mData objectForKey: @"data"] objectForKey: @"counts"] objectForKey: @"media"] intValue];
}

@end
