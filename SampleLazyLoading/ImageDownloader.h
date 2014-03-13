//
//  ImageDownloader.h
//  SampleLazyLoading
//
//  Created by Raj Kumar S L on 04/03/14.
//  Copyright (c) 2014 Raj Kumar S L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppRecord.h"


//** No need to user protocal as we user completion handler block...
//@protocol ImageDownloaderDelegate <NSObject>
//
//-(void)loadImagesToTableAtIndex:(NSIndexPath*)indexPath appRecord:(AppRecord*)record;
//
//@end

@interface ImageDownloader : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, strong) AppRecord *appRecord;
//@property (nonatomic, weak) id <ImageDownloaderDelegate> delegate;

@property (nonatomic,copy) void (^completionHander)(void);


-(void)startDownloading;
- (void)cancelDownload;

@end
