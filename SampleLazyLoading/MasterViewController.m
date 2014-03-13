//
//  MasterViewController.m
//  SampleLazyLoading
//
//  Created by Raj Kumar S L on 26/02/14.
//  Copyright (c) 2014 Raj Kumar S L. All rights reserved.
//

#import "MasterViewController.h"
#import "AppRecord.h"
#import "DetailViewController.h"
#import "ImageDownloader.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
    NSMutableDictionary *imageDownloadsInProgress;
    
}
@end

@implementation MasterViewController
@synthesize entriesArray;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    imageDownloadsInProgress = [NSMutableDictionary dictionary];
    
	// Do any additional setup after loading the view, typically from a nib.
   // self.navigationItem.leftBarButtonItem = self.editButtonItem;

   // UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
   // self.navigationItem.rightBarButtonItem = addButton;
    
   // AppRecord *appRecord = [[AppRecord alloc]init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
    
    NSArray *allDownloades = [imageDownloadsInProgress allValues];
    
    //* As all the values are imgDownloader, cancel them to avoid memory issue...
    [allDownloades makeObjectsPerformSelector:@selector(cancelDownloads)];
    
    [imageDownloadsInProgress removeAllObjects];
    
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [entriesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    AppRecord *entry = [entriesArray objectAtIndex:indexPath.row];
    cell.textLabel.text = entry.title;
    
    
    if (!entry.appIcon) {
        
        //Dont download the images when table is scolling...
        if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
        {
            [self startDownloadingAppIcon:entry forindexPath:indexPath];
        }
        cell.imageView.image = [UIImage imageNamed:@"Placeholder.png"];

    }else{
        cell.imageView.image = entry.appIcon;
    }

    return cell;
}



//Download the image icons for entry...

-(void)startDownloadingAppIcon:(AppRecord*)record forindexPath:(NSIndexPath *)anIndexPath {

    //Check if image download is in progress...
    ImageDownloader *imgDownloader = [imageDownloadsInProgress objectForKey:anIndexPath];
    
    //If not in progress download the image...
    if (imgDownloader==nil) {
        imgDownloader = [[ImageDownloader alloc] init];
        imgDownloader.appRecord =record;
        
        //Completion block calls after the data is loaded...
        [imgDownloader setCompletionHander:^{
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:anIndexPath];
            cell.imageView.image = record.appIcon;
            
        }];
        
        //Remember the objects which are already in progerss to prevent repeated downloads...
        [imageDownloadsInProgress setObject:imgDownloader forKey:anIndexPath];
        
        //Call the download method..
        [imgDownloader startDownloading];
        

    }
}

//Load the images for the visible rows after scrolling stops...
-(void)loadImagesForOnscreenRows{
    
    if (entriesArray.count>0) {
        
        NSArray *visibleCells = [self.tableView indexPathsForVisibleRows];
        
        //Load images of visible cells
        for (NSIndexPath *indexPath in visibleCells) {
            
            AppRecord *record = [self.entriesArray objectAtIndex:indexPath.row];
            
            //if image exists, dont download..
            if (!record.appIcon) {
                [self startDownloadingAppIcon:record forindexPath:indexPath];
                
            }
        }
    }
}

//When scrolling is stopped, laod the images...
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
 
    if (!decelerate) {
        [self loadImagesForOnscreenRows];
    }
}

//When scrolling is stopped, laod the images...

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self loadImagesForOnscreenRows];
}



/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/





- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end
