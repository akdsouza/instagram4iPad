//
//  UserInfoDataProvider.h
//  instagram4iPad
//
//  Created by Markus Emrich on 28.04.12.
//  Copyright (c) 2012 Markus Emrich. All rights reserved.
//

#import "JSONDataProvider.h"


@interface UserInfoDataProvider : JSONDataProvider
{
    __strong NSDictionary* mData;
}

@property (nonatomic, readonly) NSString* username;
@property (nonatomic, readonly) NSInteger photoCount;

- (id) initWithAuthToken: (NSString*) authToken;

@end
