//
//  ViewLoadedFromNib.h
//
//  Created by Markus Emrich on 04.11.11.
//  Copyright (c) 2011 Markus Emrich. All rights reserved.
//


@interface ViewLoadedFromNib : UIView

// explicit initializer
- (id)initFromNibFile;
- (id)initFromNibFileNamed: (NSString*) nibFileName;

@end
