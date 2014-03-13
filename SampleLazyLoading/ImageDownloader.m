//
//  ImageDownloader.m
//  SampleLazyLoading
//
//  Created by Raj Kumar S L on 04/03/14.
//  Copyright (c) 2014 Raj Kumar S L. All rights reserved.
//

#import "ImageDownloader.h"

@interface ImageDownloader ()
@property (nonatomic,strong) NSMutableData *connectionData;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) NSURLConnection *imageConnection;

@end

#define kAppIconSize 48

@implementation ImageDownloader
@synthesize connectionData;


-(void)startDownloading{
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.appRecord.imageURLString]];
    NSURLConnection *conn =[[NSURLConnection alloc] initWithRequest:request delegate:self];

    self.imageConnection = conn;
    
}

- (void)cancelDownload
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
//    self.activeDownload = nil;
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    connectionData = [NSMutableData data];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [connectionData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{

    UIImage *iconImg = [UIImage imageWithData:connectionData];
    
    //Decrease the size of the images as needed...
    if (iconImg.size.width != kAppIconSize || iconImg.size.height != kAppIconSize) {
        CGSize imgSize = CGSizeMake(kAppIconSize, kAppIconSize);
        UIGraphicsBeginImageContextWithOptions(imgSize, NO, 0.0f);
        
        CGRect imageRect = CGRectMake(0.0, 0.0, imgSize.width, imgSize.height);
        [iconImg drawInRect:imageRect];
        
        self.appRecord.appIcon = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }else{
        self.appRecord.appIcon = iconImg;
    }
    
    self.imageConnection = nil;
    
    
    //Send the response to root class...
    if (self.completionHander) {
        self.completionHander();
    }
    
//    [self.delegate loadImagesToTableAtIndex:self.indexPath appRecord:self.appRecord];
}


@end
