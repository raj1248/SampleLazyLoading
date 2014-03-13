//
//  ParseOperation.m
//  SampleLazyLoading
//
//  Created by Raj Kumar S L on 03/03/14.
//  Copyright (c) 2014 Raj Kumar S L. All rights reserved.
//

#import "ParseOperation.h"
#import "AppRecord.h"

// string contants found in the RSS feed
static NSString *kIDStr     = @"id";
static NSString *kNameStr   = @"im:name";
static NSString *kImageStr  = @"im:image";
static NSString *kArtistStr = @"im:artist";
static NSString *kEntryStr  = @"entry";

@interface ParseOperation () <NSXMLParserDelegate>
@property (nonatomic, strong) NSArray *appRecordList;
@property (nonatomic,strong) NSData *dataToParse;
@property (nonatomic,strong) NSArray *elementsToParse;
@property (nonatomic, strong) NSMutableArray *workingArray;
@property (nonatomic, strong) AppRecord *workingEntry;
@property (nonatomic,readwrite) BOOL storingCharacterData;
@property (nonatomic,strong) NSMutableString *workingPropertyStr;

@end

@implementation ParseOperation

// *** Note for some reasons, Main is not called. so I initialixed the objects in below initdata method..

-(id)initWithData:(NSData*)data{
    
    self = [super init];
    
    if (self != nil) {
        self.dataToParse = data;
        self.elementsToParse = [[NSArray alloc] initWithObjects:kIDStr,kNameStr,kImageStr,kArtistStr, nil];

        self.workingArray = [[NSMutableArray alloc] init];
        self.workingPropertyStr = [NSMutableString string];

        
        NSXMLParser *XMLparser = [[NSXMLParser alloc] initWithData:self.dataToParse];
        XMLparser.delegate=self;
        [XMLparser parse];
        
        
        if (![self isCancelled]) {
            self.appRecordList = [NSArray arrayWithArray:self.workingArray];
            NSLog(@"parsed data..%@",self.appRecordList);
    
        }
    }
    return self;
}

// ** For some reasons Main is not called **//
//- (void)main{
//    NSXMLParser *XMLparser = [[NSXMLParser alloc] initWithData:self.dataToParse];
//    XMLparser.delegate=self;
//    [XMLparser parse];
//    
//}


-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    if ([elementName isEqualToString:kEntryStr]) {
        self.workingEntry = [[AppRecord alloc] init];
    }
    
    self.storingCharacterData = [self.elementsToParse containsObject:elementName];
    
    //NSLog(@"elementName..%@",elementName);
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{

    if (self.workingEntry) {
        if (self.storingCharacterData) {
            
            NSString *trimmedStr = [self.workingPropertyStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [self.workingPropertyStr setString:@""]; // Clear the string
            
            NSLog(@"tmd str..%@",trimmedStr);

            if ([elementName isEqualToString:kIDStr])
                self.workingEntry.id = trimmedStr;
            else if ([elementName isEqualToString:kImageStr])
                self.workingEntry.imageURLString = trimmedStr;
            else if ([elementName isEqualToString:kNameStr])
                self.workingEntry.title = trimmedStr;
        }else if ([elementName isEqualToString:kEntryStr]){
            [self.workingArray addObject:self.workingEntry];
            self.workingEntry = nil;
        }
            
    }
    
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if (self.storingCharacterData) {
        [self.workingPropertyStr appendString:string];
    }
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    NSLog(@"Parser Error..%@",parseError);
}


@end
