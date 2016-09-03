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
#import "PhotoViewCell.h"
#import "PhotoDetailViewController.h"

@interface PhotoTableViewController () <
    NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchResultsController;
@end

@implementation PhotoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Photos List";
    
//    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
//    NSError *error = nil;
//    NSUInteger photoCount = [self.coreDataStack.mainContext countForFetchRequest:fetchRequest error:&error];
//    if (!(photoCount > 0)) {
//        UIButton *headButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        headButton.frame = CGRectMake(0, 0, 320, 30);
//        [headButton setTitle:@"Improt Data" forState:UIControlStateNormal];
//        headButton.backgroundColor = [UIColor redColor];
//        self.tableView.tableHeaderView = headButton;
//        [headButton addTarget:self action:@selector(import) forControlEvents:UIControlEventTouchUpInside];
//    }


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
    PhotoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photoCell" forIndexPath:indexPath];
    
    Photo *photo = [self.fetchResultsController objectAtIndexPath:indexPath];

    cell.photo = photo;
    
    return cell;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SeguePhotoListToPhotoDetail"]) {
        PhotoDetailViewController *detailVC = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        detailVC.photo = [self.fetchResultsController objectAtIndexPath:indexPath];
    }
}


@end
