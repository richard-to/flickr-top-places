//
//  PlacesTableViewController.m
//  FlickrTopPlaces
//
//  Created by Richard To on 1/6/13.
//  Copyright (c) 2013 Richard To. All rights reserved.
//

#import "PlacesTableViewController.h"
#import "RecentPhotosTableViewController.h"
#import "FlickrFetcher.h"
#import "PlacesMapViewController.h"
#import "FlickrPlacesAnnotation.h"

@interface PlacesTableViewController ()
@property(nonatomic, strong) NSArray *places;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *mapViewButton;
- (NSArray *)mapAnnotations;
@end

@implementation PlacesTableViewController

@synthesize places = _places;
@synthesize mapViewButton = _mapViewButton;

-(void)viewDidLoad
{
    self.navigationItem.hidesBackButton = YES;
    self.tabBarController.delegate = self;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UINavigationController *)viewController{
    [viewController popToRootViewControllerAnimated:NO];
}

- (NSArray *)places
{
    if (!_places) {
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner startAnimating];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
        
        dispatch_queue_t downloadQueue = dispatch_queue_create("flickr places", NULL);
        dispatch_async(downloadQueue, ^{
            NSArray *tempPlaces = [FlickrFetcher topPlaces];
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:FLICKR_PLACE_NAME ascending:YES];
            _places = [tempPlaces sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.navigationItem.rightBarButtonItem = self.mapViewButton;
                [self.tableView reloadData];
            });
        });
    }
    return _places;
}

- (NSArray *) mapAnnotations
{
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:self.places.count];
    for (NSDictionary* place in self.places) {
        [annotations addObject:[FlickrPlacesAnnotation annotationFromMeta:place]];
    }
    return annotations;
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


#pragma mark - Table view delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender 
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if ([segue.identifier isEqualToString:@"View Recent Photos"]) {
        [segue.destinationViewController setPlace: [self.places objectAtIndex:indexPath.row]];
    } else if ([segue.identifier isEqualToString:@"places map segue"]) {
        [segue.destinationViewController setAnnotations: self.mapAnnotations];
    }
}

@end
