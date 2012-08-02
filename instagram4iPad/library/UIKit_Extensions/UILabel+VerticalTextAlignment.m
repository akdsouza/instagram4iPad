//
//  UILabel+VerticalTopAlignment.m
//
//  Created by Markus Emrich on 02.11.10.
//  Copyright 2010 Markus Emrich. All rights reserved.
//

#import "UILabel+VerticalTextAlignment.h"


@implementation UILabel (VerticalTextAlignment)


- (CGSize) alignTextVerticallyToTop
{
	CGSize stringSize = [self.text sizeWithFont: self.font
							  constrainedToSize: CGSizeMake(self.frameWidth, 9999)
								  lineBreakMode: self.lineBreakMode];
	
	self.frameHeight = stringSize.height;
    
    return stringSize;
}


@end