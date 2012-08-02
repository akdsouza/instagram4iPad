//
//  Photo.m
//  instagram4iPad
//
//  Created by Markus Emrich on 01.05.12.
//  Copyright (c) 2012 Markus Emrich. All rights reserved.
//

#import "Photo.h"

@implementation Photo

@dynamic caption;
@dynamic location;
@dynamic likeCount;
@dynamic commentCount;
@dynamic formattedCommentsAndLikes;

@dynamic mediaID;
@dynamic link;

- (id)initWithDictionary: (NSDictionary*) photoDictionary
{
    self = [super init];
    if (self)
    {
        mData = photoDictionary;
    }
    return self;
}

- (void)dealloc
{
    mData = nil;
}

#pragma mark -
#pragma mark representation

- (NSString*) description
{
    return [NSString stringWithFormat: @"%@ Likes: %03d, Caption: %@…",
            [super description],
            self.likeCount,
            [self.caption substringToIndex: MIN(self.caption.length-1, 20)]];
}

#pragma mark -
#pragma mark getter

- (NSString*) caption
{
    return [[mData safeObjectForKey: @"caption"] safeObjectForKey: @"text"];
}

- (NSString*) location
{
    return [[mData safeObjectForKey: @"location"] safeObjectForKey: @"name"];
}

- (NSInteger) likeCount
{
    return [[[mData safeObjectForKey: @"likes"] safeObjectForKey: @"count"] intValue];
}

- (NSInteger) commentCount
{
    return [[[mData safeObjectForKey: @"comments"] safeObjectForKey: @"count"] intValue];
}

- (NSString*) formattedCommentsAndLikes
{
    return [NSString stringWithFormat: NSLocalizedString(@"keyCommentsAndLikesFormat", nil), self.likeCount, self.commentCount];
}

- (NSString*) mediaID
{
    return [mData safeObjectForKey: @"id"];
}

- (NSString*) link
{
    return [mData safeObjectForKey: @"link"];
}

- (NSString*) urlForPhotoType: (PhotoType) type
{
    NSString* key = nil;
    
    switch (type)
    {
        case ePhotoTypeLowResolution:
            key = @"low_resolution";
            break;
        case ePhotoTypeFullResolution:
            key = @"standard_resolution";
            break;
        case ePhotoTypeThumbnail:
        default:
            key = @"thumbnail";
            break;
    }

    return [[[mData safeObjectForKey: @"images"] safeObjectForKey: key] safeObjectForKey: @"url"];
}

- (CGSize) sizeForPhotoType: (PhotoType) type
{
    NSString* key = nil;
    
    switch (type)
    {
        case ePhotoTypeLowResolution:
            key = @"low_resolution";
            break;
        case ePhotoTypeFullResolution:
            key = @"standard_resolution";
            break;
        case ePhotoTypeThumbnail:
        default:
            key = @"thumbnail";
            break;
    }
    
    NSDictionary* sizeData = [[mData safeObjectForKey: @"images"] safeObjectForKey: key];
    CGSize size = CGSizeMake([[sizeData safeObjectForKey: @"width"] floatValue],
                             [[sizeData safeObjectForKey: @"height"] floatValue]);
    
    return size;
}

@end

/*
 
 EXAMPLE OF RECEIVED JSON
 
{
    "attribution": null,
    "tags": [],
    "type": "image",
    "location": {
        "latitude": 52.500859,
        "name": "Magnet",
        "longitude": 13.444599,
        "id": 304491
    },
    "comments": {
        "count": 1,
        "data": []
    },
    "filter": "Hudson",
    "created_time": "1334603996",
    "link": "http://instagr.am/p/JffWLtwL1j/",
    "likes": {
        "count": 7,
        "data": []
    },
    "images": {
        "low_resolution": {
            "url": "http://distilleryimage11.s3.amazonaws.com/26d473c887f911e1ab011231381052c0_6.jpg",
            "width": 306,
            "height": 306
        },
        "thumbnail": {
            "url": "http://distilleryimage11.s3.amazonaws.com/26d473c887f911e1ab011231381052c0_5.jpg",
            "width": 150,
            "height": 150
        },
        "standard_resolution": {
            "url": "http://distilleryimage11.s3.amazonaws.com/26d473c887f911e1ab011231381052c0_7.jpg",
            "width": 612,
            "height": 612
        }
    },
    "caption": {
        "created_time": "1334603999",
        "text": "Dinner.",
        "from": {
            "username": "jaydee3",
            "profile_picture": "http://images.instagram.com/profiles/profile_1114142_75sq_1319122753.jpg",
            "id": "1114142",
            "full_name": "Markus E. ⬇ follow =)"
        },
        "id": "170993200163503863"
    },
    "user_has_liked": false,
    "id": "170993174712466787_1114142",
    "user": {
        "username": "jaydee3",
        "website": "http://is.gd/stillwaitin",
        "bio": "Apple Fanboy. Loves the 4s camera!! yeees\r\n🇩🇪 Berlin 🇩🇪 All photos are taken with my iPhone. 📱Check out my own app:",
        "profile_picture": "http://images.instagram.com/profiles/profile_1114142_75sq_1319122753.jpg",
        "full_name": "Markus E. ⬇ follow =)",
        "id": "1114142"
    }
}
*/