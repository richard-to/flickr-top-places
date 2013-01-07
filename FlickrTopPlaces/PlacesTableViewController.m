//
//  PlacesTableViewController.m
//  FlickrTopPlaces
//
//  Created by Richard To on 1/6/13.
//  Copyright (c) 2013 Richard To. All rights reserved.
//

#import "PlacesTableViewController.h"
#import "FlickrFetcher.h"

@interface PlacesTableViewController ()
@property(nonatomic, strong) NSArray *places;
@end

@implementation PlacesTableViewController

@synthesize places = _places;

- (NSArray *)places
{
    if (!_places) {
        NSArray *tempPlaces = [FlickrFetcher topPlaces];
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:FLICKR_PLACE_NAME
                                                               ascending:YES];
        _places = [tempPlaces sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    }
    return _places;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.places.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Places Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *cellPlace = [self.places objectAtIndex: indexPath.row];
    NSArray *placeChunks = [[cellPlace objectForKey:FLICKR_PLACE_NAME]
                            componentsSeparatedByString:@", "];
    cell.textLabel.text = placeChunks[0];
    if (placeChunks.count == 3) {
        cell.detailTextLabel.text = [[NSString alloc] initWithFormat:
                                 @"%@, %@", placeChunks[1], placeChunks[2]];
    } else {
        cell.detailTextLabel.text = placeChunks[1];
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

@end
