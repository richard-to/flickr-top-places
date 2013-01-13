//
//  ViewedPhotosTableViewController.m
//  FlickrTopPlaces
//
//  Created by Richard To on 1/6/13.
//  Copyright (c) 2013 Richard To. All rights reserved.
//

#import "ViewedPhotosTableViewController.h"
#import "PhotoViewerViewController.h"
#import "FlickrFetcher.h"

@interface ViewedPhotosTableViewController ()
@end

@implementation ViewedPhotosTableViewController

@synthesize photoList = _photoList;

-(void)viewDidAppear:(BOOL)animated
{
    self.photoList = [[NSUserDefaults standardUserDefaults] objectForKey:@"viewedPhotos"];
    [self.tableView reloadData];
}

-(NSArray *)photoList
{
    if (!_photoList) {
        self.photoList = [[NSUserDefaults standardUserDefaults] objectForKey:@"viewedPhotos"];
    }
    return _photoList;
}

-(void)setPhotoList:(NSArray *)photoList
{
    _photoList = photoList;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.photoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *cellPhoto = [self.photoList objectAtIndex: indexPath.row];

    UITableViewCell *cell;
    NSString *title = cellPhoto[FLICKR_PHOTO_TITLE];
    NSString *desc = cellPhoto[@"description"][@"_content"];
    
    if (title.length > 0 && desc.length > 0) {
        static NSString *CellIdentifier = @"Viewed Photos Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = title;
        cell.detailTextLabel.text = desc;
    } else {
        static NSString *CellIdentifier = @"Viewed Photos Cell No Sub";
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

- (id <SplitViewBarButtonItemPresenter>)splitViewBarButtonItemPresenter
{
    id detailVC = [self.splitViewController.viewControllers lastObject];
    if (![detailVC conformsToProtocol:@protocol(SplitViewBarButtonItemPresenter)]) {
        detailVC = nil;
    }
    return detailVC;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id detailVC = [self splitViewBarButtonItemPresenter];
    if (detailVC) {
        NSDictionary *photoMeta = [self.photoList objectAtIndex:indexPath.row];
        
        NSURL *url = [FlickrFetcher urlForPhoto: photoMeta
                                         format:FlickrPhotoFormatLarge];
        [detailVC setImageUrl: url];
        [detailVC setPhotoTitle:photoMeta[FLICKR_PHOTO_TITLE]];
        [detailVC updateImage];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSDictionary *photoMeta = [self.photoList objectAtIndex: indexPath.row];
    if ([segue.identifier isEqualToString:@"Photo Viewer"] ||
        [segue.identifier isEqualToString:@"Photo Viewer 2"]) {
        NSURL *url = [FlickrFetcher urlForPhoto: photoMeta
                                         format:FlickrPhotoFormatLarge];
        [segue.destinationViewController setImageUrl: url];
        [segue.destinationViewController setPhotoTitle:photoMeta[FLICKR_PHOTO_TITLE]];
    }
}
@end
