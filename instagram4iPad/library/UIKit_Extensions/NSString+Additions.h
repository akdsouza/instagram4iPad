//
//  NSString+Additions.h
//


/*
 * Extends the factory NSString class
 *
 */
@interface NSString (UtilsAdditions)

/*
 * Determines if the string is empty or contains only whitespace.
 *
 */
@property (nonatomic, readonly) BOOL isEmptyOrWhitespace;

/*
 * Escapes all occurences of chars '% '\"?=&+<>;:-' with percent escapes
 * so the string can be used as parameter in an url.
 *
 * @return encoded string
 *
 */
@property (nonatomic, readonly) NSString* urlEncoded;

/*
 * Case insensitive comparisation of two strings
 *
 * @return BOOL comparisationResult
 *
 */
- (BOOL) isEqualToStringCaseInsensitive: (NSString*) string;

- (NSString*) trimmedString;

@end
