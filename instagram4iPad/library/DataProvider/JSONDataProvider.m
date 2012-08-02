//
//  JSONDataProvider.m
//
//  Created by Markus Emrich on 24.11.10.
//  Copyright 2010 Markus Emrich. All rights reserved.
//

#import "JSONDataProvider.h"


@implementation JSONDataProvider



- (BOOL) handleRawData: (NSData*) data
{
	NSString* jsonString = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
	
	NSDictionary* parsedDictionary = [NSDictionary dictionaryWithJSONString: jsonString];
	
	if (parsedDictionary == nil)
	{
		NSLog(@"Error in parsing JSON: %@", jsonString);
		[jsonString release];
		return NO;
	}
	
	[jsonString release];
	
	return [self handleData: parsedDictionary];
}


- (BOOL) handleData: (NSDictionary*) dataDictionary { return YES; }


@end
