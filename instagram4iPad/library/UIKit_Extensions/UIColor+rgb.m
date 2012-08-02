//
//  UIColor+rgb.m
//
//  Created by Markus Emrich on 16.05.11.
//  Copyright 2011 Markus Emrich. All rights reserved.
//

#import "UIColor+rgb.h"


@implementation UIColor (rgb)

+ (UIColor*) colorFromHexColor: (NSUInteger) color
{
	CGFloat red   = ((float)((color & 0xFF0000) >> 16))	/ 255.0;
	CGFloat green = ((float)((color & 0xFF00) >> 8))	/ 255.0;
	CGFloat blue  = ((float) (color & 0xFF))			/ 255.0;
	
	return [UIColor colorWithRed: red green: green blue: blue alpha:1.0];
}

+ (UIColor *)colorWithRedInt:(NSUInteger)red greenInt:(NSUInteger)green blueInt:(NSUInteger)blue
{
	return [UIColor colorWithRedInt: red greenInt: green blueInt: blue alphaInt: 255];
}

+ (UIColor *)colorWithRedInt:(NSUInteger)red greenInt:(NSUInteger)green blueInt:(NSUInteger)blue alphaInt:(NSUInteger)alpha
{
	CGFloat floatRed   = red   / 255.0;
	CGFloat floatGreen = green / 255.0;
	CGFloat floatBlue  = blue  / 255.0;
	CGFloat floatAlpha = alpha / 255.0;
	
	return [UIColor colorWithRed: floatRed green: floatGreen blue: floatBlue alpha: floatAlpha];
}

@end
