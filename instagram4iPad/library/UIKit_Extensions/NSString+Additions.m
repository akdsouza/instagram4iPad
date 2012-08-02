//
// NSString+Additions.m
//

#import "NSString+Additions.h"


@implementation NSString (UtilsAdditions)

- (BOOL) isEmptyOrWhitespace
{
	return !self.length ||
	![self trimmedString].length;
}

- (NSString*) urlEncoded
{
    NSString* result = (__bridge_transfer NSString*) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)self, NULL, CFSTR("% '\"?=&+<>;:-"), kCFStringEncodingUTF8);
    return result;
}

- (BOOL) isEqualToStringCaseInsensitive: (NSString*) string
{
	return [[self lowercaseString] isEqualToString: [string lowercaseString]];
}

- (NSString*) trimmedString
{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end