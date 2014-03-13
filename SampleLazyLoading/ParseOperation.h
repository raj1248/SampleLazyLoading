//
//  ParseOperation.h
//  SampleLazyLoading
//
//  Created by Raj Kumar S L on 03/03/14.
//  Copyright (c) 2014 Raj Kumar S L. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParseOperation : NSOperation

// A block to call when an error is encountered during parsing.
@property (nonatomic, copy) void (^errorHandler)(NSError *error);

@property (nonatomic, strong, readonly) NSArray *appRecordList;


-(id)initWithData:(NSData*)data;

@end
