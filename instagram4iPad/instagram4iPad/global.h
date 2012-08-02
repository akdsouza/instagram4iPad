//
//  global.h
//  instagram4iPad
//
//  Created by Markus Emrich on 28.04.12.
//  Copyright (c) 2012 Markus Emrich. All rights reserved.
//


// Instagram DATA

#error Error: YOU HAVE TO PUT YOUR CUSTOM CLIENT ID HERE FIRST!! Register here: http://instagram.com/developer/
#define INSTAGRAM_CLIENT_ID     @"YOUR-CLIENT-ID"
#define INSTAGRAM_REDIRECT_URI  @"nbtinsta://auth"

#define KEYCHAIN_AUTH_TOKEN_USER_KEY     @"KEYCHAIN_AUTH_TOKEN_USER_KEY"
#define KEYCHAIN_AUTH_TOKEN_SERVICE_KEY  @"KEYCHAIN_AUTH_TOKEN_SERVICE_KEY"


// Instagram API URLs

#define INSTAGRAM_URL_SCHEME              @"instagram://app"
#define INSTAGRAM_URL_SCHEME_MEDIA_FORMAT @"instagram://media?id=%@"

#define INSTAGRAM_API_POPULAR    @"https://api.instagram.com/v1/media/popular"
#define INSTAGRAM_API_USER_SELF  @"https://api.instagram.com/v1/users/self"
#define INSTAGRAM_API_MEDIA_SELF @"https://api.instagram.com/v1/users/self/media/recent"

// custom logging

#ifdef kDEBUG
    #define NSLog LOG
    #if __has_feature(objc_arc)
        #define LOG(s,...) CFShow((__bridge CFStringRef)[NSString stringWithFormat: @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__]] )
    #else
        #define LOG(s,...) CFShow([NSString stringWithFormat: @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__]] )
    #endif

#else
    #define NSLog LOG
    #define LOG(s,...)
#endif


// testing environment
#if kDEBUG
    // comment out, to stay logged in (even after logout - safari cookies will stay)
    #define DEBUG_DONT_DELETE_COOKIES 
#endif