//
//  PhotoTableViewController.m
//  CoreDataDemo
//
//  Created by PeterLin on 16/8/29.
//  Copyright © 2016年 LinPeihuang. All rights reserved.
//

#import "PhotoTableViewController.h"
#import "Photo.h"
#import "Usage.h"
#import <CoreData/CoreData.h>
#import "UIImageView+WebCache.h"


@interface PhotoTableViewController () <
    NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchResultsController;
@end

@implementation PhotoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Photos";
    
    UIButton *headButton = [UIButton buttonWithType:UIButtonTypeCustom];
    headButton.frame = CGRectMake(0, 0, 320, 44);
    headButton.backgroundColor = [UIColor redColor];
    self.tableView.tableHeaderView = headButton;
    [headButton addTarget:self action:@selector(import) forControlEvents:UIControlEventTouchUpInside];
    [self configureView];
}

- (void)import {
    self.tableView.tableHeaderView = nil;
}

- (void)configureView {
     self.fetchResultsController = [self photoFetchedResultControllerFor:self.city];
}

- (NSFetchedResultsController *)photoFetchedResultControllerFor:(NSString *)city {
    if (!self.fetchResultsController) {
        self.fetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[self photoFetchRequest:city] managedObjectContext:self.coreDataStack.mainContext sectionNameKeyPath:nil cacheName:nil];
        self.fetchResultsController.delegate = self;
    }
    NSError *error = nil;
    if (![self.fetchResultsController performFetch:&error]) {
        NSLog(@"Error:%@",error);
        abort();
    }
    return  self.fetchResultsController;
}

- (NSFetchRequest *)photoFetchRequest:(NSString *)city {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"uploadDate" ascending:YES];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    if (city) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"city == %@",city];
        fetchRequest.predicate = predicate;
    }
    return fetchRequest;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.fetchResultsController.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fetchResultsController.sections[section] numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photoCell" forIndexPath:indexPath];
    
    Photo *photo = [self.fetchResultsController objectAtIndexPath:indexPath];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";

    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:photo.thumb]];
    cell.textLabel.text = [NSString stringWithFormat:@"Snap in %@ at %@",[dateFormatter stringFromDate:photo.createDate], photo.city];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Size: %@ * %@",[photo.width stringValue], [photo.height stringValue]];
    return cell;
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
