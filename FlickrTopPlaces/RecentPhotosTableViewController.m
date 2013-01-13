//
//  RecentPhotosTableViewController.m
//  FlickrTopPlaces
//
//  Created by Richard To on 1/6/13.
//  Copyright (c) 2013 Richard To. All rights reserved.
//

#import "PhotosMapViewController.h"
#import "RecentPhotosTableViewController.h"
#import "PhotoViewerViewController.h"
#import "FlickrFetcher.h"

@interface RecentPhotosTableViewController ()
@property (nonatomic, strong) NSArray *photosList;
@end

@implementation RecentPhotosTableViewController

@synthesize place = _place;
@synthesize photosList = _photosList;


- (void)setPhotosList:(NSArray *)photosList
{
    _photosList = photosList;
    [self.tableView reloadData];
}

- (void)setPlace:(NSDictionary *)place
{
    if (_place != place) {
        _place = place;
    
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner startAnimating];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
        dispatch_queue_t downloadQueue = dispatch_queue_create("photos in place", NULL);
        dispatch_async(downloadQueue, ^{
            NSArray *photosInPLace = [FlickrFetcher photosInPlace:place maxResults:50];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.navigationItem.rightBarButtonItem = NULL;
                self.photosList = photosInPLace;
            });
        });
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.photosList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *cellPhoto = [self.photosList objectAtIndex:indexPath.row];
    NSString *title = cellPhoto[FLICKR_PHOTO_TITLE];
    NSString *desc = cellPhoto[@"description"][@"_content"];
    UITableViewCell *cell;
    
    if (title.length > 0 && desc.length > 0) {
        static NSString *CellIdentifier = @"Recent Photos Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = title;
        cell.detailTextLabel.text = desc;
    } else {
        static NSString *CellIdentifier = @"Recent Photos Cell No Sub";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (title.length > 0) {
            cell.textLabel.text = title;
        } else if (desc.length > 0) {
            cell.textLabel.text = desc;        
        } else {
            cell.textLabel.text = @"Unknown";       
        }
    }
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSDictionary *photoMeta = [self.photosList objectAtIndex:indexPath.row];
 
    if ([segue.identifier isEqualToString:@"Photo Viewer"] ||
        [segue.identifier isEqualToString:@"Photo Viewer 2"]) {
        NSURL *url = [FlickrFetcher urlForPhoto: photoMeta
                                         format:FlickrPhotoFormatLarge];
        [segue.destinationViewController setImageUrl: url];
        [segue.destinationViewController setPhotoTitle:photoMeta[FLICKR_PHOTO_TITLE]];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *viewedSet = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"viewedPhotos"] copyItems:YES];
    
        if (!viewedSet) {
            viewedSet = [[NSMutableArray alloc] init];
        }
        [viewedSet addObject:photoMeta];
        [[NSUserDefaults standardUserDefaults] setObject:[viewedSet copy]
                                                forKey:@"viewedPhotos"];
    } else if ([segue.identifier isEqualToString: @"recent photos to list"]) {
        [segue.destinationViewController setFlickrMeta: photoMeta];
    }
}

@end
