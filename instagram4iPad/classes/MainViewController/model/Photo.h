//
//  Photo.h
//  instagram4iPad
//
//  Created by Markus Emrich on 01.05.12.
//  Copyright (c) 2012 Markus Emrich. All rights reserved.
//

typedef enum {
    ePhotoTypeThumbnail,
    ePhotoTypeLowResolution,
    ePhotoTypeFullResolution,
} PhotoType;


@interface Photo : NSObject
{
    NSDictionary* mData;
}

@property (nonatomic, readonly) NSString* caption;
@property (nonatomic, readonly) NSString* location;
@property (nonatomic, readonly) NSInteger likeCount;
@property (nonatomic, readonly) NSInteger commentCount;
@property (nonatomic, readonly) NSString* formattedCommentsAndLikes;

@property (nonatomic, readonly) NSString* mediaID;
@property (nonatomic, readonly) NSString* link;

- (id) initWithDictionary: (NSDictionary*) photoDictionary;

- (NSString*) urlForPhotoType: (PhotoType) type;
- (CGSize) sizeForPhotoType: (PhotoType) type;

@end
