//
//  UIColor+rgb.h
//
//  Created by Markus Emrich on 16.05.11.
//  Copyright 2011 Markus Emrich. All rights reserved.
//




@interface UIColor (rgb)

+ (UIColor*) colorFromHexColor: (NSUInteger) color;

+ (UIColor *)colorWithRedInt:(NSUInteger)red greenInt:(NSUInteger)green blueInt:(NSUInteger)blue;
+ (UIColor *)colorWithRedInt:(NSUInteger)red greenInt:(NSUInteger)green blueInt:(NSUInteger)blue alphaInt:(NSUInteger)alpha;

@end
