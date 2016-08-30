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

static NSInteger amountToImport = 50;
static BOOL addUsageRecords = YES;

@interface PhotoTableViewController () <
    NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchResultsController;
@end

@implementation PhotoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Photos";
    [self configureView];
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

#pragma mark - Actions
- (IBAction)importData:(id)sender {
    [self importJSONSeedDataIfNeeded];
}

- (void)importJSONSeedDataIfNeeded {
    BOOL importRequire = NO;
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    NSError *error = nil;
    NSUInteger photoCount = [self.coreDataStack.mainContext countForFetchRequest:fetchRequest error:&error];
    if (photoCount < amountToImport) {
        importRequire = YES;
    }
    
    if (!importRequire && addUsageRecords) {
        NSFetchRequest *usageFetch = [NSFetchRequest fetchRequestWithEntityName:@"Rating"];
        NSError *ratingError = nil;
        NSUInteger usageCount = [self.coreDataStack.mainContext countForFetchRequest:usageFetch error:&ratingError];
        if (usageCount == 0) {
            importRequire = YES;
        }
    }
    
    if (importRequire) {
        NSError *fetchError = nil;
        NSArray *results = [self.coreDataStack.mainContext executeFetchRequest:fetchRequest error:&fetchError];
        for (Photo *photo in results) {
            [self.coreDataStack.mainContext deleteObject:photo];
        }
        
        [self.coreDataStack saveContext];
        NSInteger records = MAX(0, MIN(500, amountToImport));
        [self importJSONSeedData:records];
    }
}

- (void)importJSONSeedData:(NSInteger)records {
    NSURL *jsonURL = [[NSBundle mainBundle] URLForResource:@"seed" withExtension:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfURL:jsonURL];
    NSError *error = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if (error) {
        NSLog(@"JSONSerialization Error:%@",error);
    }
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Photo" inManagedObjectContext:self.coreDataStack.mainContext];

    NSInteger counter = 0;

    for (NSDictionary *jsonDict in jsonArray) {
        counter ++;
        NSString *city = jsonDict[@"city"];
        NSTimeInterval createDateStamp = [jsonDict[@"ori_time"] doubleValue];
        NSString *photoID = jsonDict[@"id"];
        NSString *image = [jsonDict valueForKeyPath:@"thumb.l"];
        NSString *thumb = [jsonDict valueForKeyPath:@"thumb.s2"];
        NSNumber *height = jsonDict[@"height"];
        NSNumber *width = jsonDict[@"width"];
        NSTimeInterval uploadDateStamp = [jsonDict[@"created_at"] doubleValue];
        
        Photo *photo = [[Photo alloc] initWithEntity:entity insertIntoManagedObjectContext:self.coreDataStack.mainContext];
        photo.photoID = photoID;
        photo.city = city;
        photo.createDate = [NSDate dateWithTimeIntervalSince1970:createDateStamp];
        photo.uploadDate = [NSDate dateWithTimeIntervalSince1970:uploadDateStamp];
        photo.image = image;
        photo.thumb = thumb;
        photo.height = height;
        photo.width = width;
        
        if (addUsageRecords) {
            [self addUsagesRecordsToPhoto:photo];
        }
        
        if (counter == records) {
            break;
        }
        
        if (counter % 20 == 0) {
            [self.coreDataStack saveContext];
            [self.coreDataStack.mainContext reset];
            NSLog(@"save %%20");
        }
    }
    NSLog(@"last save");
    [self.coreDataStack saveContext];
    [self.coreDataStack.mainContext reset];
}

- (void)addUsagesRecordsToPhoto:(Photo *)photo {
    NSInteger numberOfSales = 1000 + arc4random_uniform(5000);
    for (NSInteger i = 0; i < numberOfSales; i ++) {
        Usage *usage = [NSEntityDescription insertNewObjectForEntityForName:@"Usage" inManagedObjectContext:self.coreDataStack.mainContext];
        usage.photo = photo;
        usage.detail = [NSNumber numberWithUnsignedInteger:arc4random_uniform(5)];//@"Detail description of photo usage";
        usage.date = [NSDate date];
    }
    NSLog(@"added %ld usages",photo.usage.count);
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
