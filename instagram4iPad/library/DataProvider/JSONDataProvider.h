//
//  JSONDataProvider.h
//
//  Created by Markus Emrich on 24.11.10.
//  Copyright 2010 Markus Emrich. All rights reserved.
//

#import "DataProvider.h"
#import "JSON.h"

@interface JSONDataProvider : DataProvider

/**
 * 
 * This method is called, when data transmission did finish.
 * Subclasses should override this method to handle the json data dictionary.
 * 
 * @param data
 * The json dictionary, which was received from the server
 * 
 * @return
 * If you return NO the DataProvider will send dataProviderDidFail
 * to its delegate, else it will send dataProviderHasDataReady;
 * 
 */
- (BOOL) handleData: (NSDictionary*) dataDictionary;

@end
