//
//  AppDelegate.m
//  SampleLazyLoading
//
//  Created by Raj Kumar S L on 26/02/14.
//  Copyright (c) 2014 Raj Kumar S L. All rights reserved.
//

#import "AppDelegate.h"
#import "ParseOperation.h"
#import "MasterViewController.h"

static NSString *const topPaidAppsFeed = @"http://phobos.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/toppaidapplications/limit=75/xml";

@interface AppDelegate ()
@property (nonatomic,strong) NSURLConnection *urlConnection;
@property (nonatomic,strong) NSMutableData *appData;
@property (nonatomic,strong) NSOperationQueue *queue;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:topPaidAppsFeed]];
    self.urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    
    // Override point for customization after application launch.
    return YES;
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    self.appData = [NSMutableData data];
    
}


-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.appData appendData:data];
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSString *dataString = [[NSString alloc] initWithData:self.appData encoding:NSUTF8StringEncoding];
    NSLog(@"data Str..%@",dataString);
    
    self.queue = [[NSOperationQueue alloc] init];
    
    
    //Parser the data.. 
    ParseOperation *parser = [[ParseOperation alloc] initWithData:self.appData];
    
    NSLog(@"parsed results..%@",parser.appRecordList);

    if (parser.appRecordList) {
        MasterViewController *mvc = (MasterViewController*)[(UINavigationController*)self.window .rootViewController topViewController];
        mvc.entriesArray = parser.appRecordList;
        [mvc.tableView reloadData];
    }
    
    
//   __weak ParseOperation *weekParser = parser;
    
//    parser.completionBlock = ^(void){
//        NSLog(@"parsed results..%@",weekParser.appRecordList);
//        NSLog(@"Parsing Done");
//    };
//    
    
    self.queue = nil;

    [self.queue addOperation:parser];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
