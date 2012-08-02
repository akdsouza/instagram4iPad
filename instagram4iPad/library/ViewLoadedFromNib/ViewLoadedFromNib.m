//
//  ViewLoadedFromNib.m
//
//  Created by Markus Emrich on 04.11.11.
//  Copyright (c) 2011 Markus Emrich. All rights reserved.
//

#import "ViewLoadedFromNib.h"

@implementation ViewLoadedFromNib

// override default initializer
- (id)init
{
    return [self initFromNibFile];
}

// override initializer withFrame
- (id) initWithFrame:(CGRect)frame
{
    self = [self init];
    if (self) {
        self.frame = frame;
    }
    return self;
}

// overwrite nib loading
- (id) initWithCoder:(NSCoder *)aDecoder
{
    return [self init];
}

// explicit initializer
- (id)initFromNibFile
{
	return [self initFromNibFileNamed: NSStringFromClass([self class])];
}

// explicit initializer & logic
- (id)initFromNibFileNamed: (NSString*) nibFileName
{
    self = [super initWithFrame: CGRectMake(0, 0, 300, 300)];
    if (self)
	{
		// load nib file
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:
								nibFileName owner: self options: nil];

		// make sure, a nib file is loaded
        NSAssert(nibContents != nil && [nibContents count] > 0, @"ViewLoadedFromNib: ERROR LOADING NIB FILE NAMED %@", nibFileName);
		
		UIView* mainView = (UIView*)[nibContents objectAtIndex: 0];
		
		// resize & color view to match nib file
		self.frame = mainView.frame;
		self.backgroundColor = mainView.backgroundColor;
		self.alpha = mainView.alpha;
		self.opaque = mainView.opaque;
		self.clipsToBounds = mainView.clipsToBounds;
		self.autoresizingMask = mainView.autoresizingMask;
		self.autoresizesSubviews = mainView.autoresizesSubviews;
        
		// add all views from nib file to this view
		for (UIView* subview in mainView.subviews)
		{
			[self addSubview: subview];
		}
	}
    return self;
}

@end
