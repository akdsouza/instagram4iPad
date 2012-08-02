//
//  NSDictionary+safeObjectForKey.m
//  instagram4iPad
//
//  Created by Markus Emrich on 02.05.12.
//  Copyright (c) 2012 Markus Emrich. All rights reserved.
//

#import "NSDictionary+safeObjectForKey.h"

@implementation NSDictionary (SafeObjectForKey)

- (id) safeObjectForKey:(id)aKey
{
    id obj = [self objectForKey: aKey];
    if ([obj isKindOfClass: [NSNull class]]) {
        return nil;
    }
    
    return obj;
}

@end
