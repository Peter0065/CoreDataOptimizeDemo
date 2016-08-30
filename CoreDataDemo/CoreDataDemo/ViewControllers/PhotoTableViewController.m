//
//  AssetsTableViewController.m
//  CoreDataDemo
//
//  Created by PeterLin on 16/8/29.
//  Copyright © 2016年 LinPeihuang. All rights reserved.
//

#import "PhotoTableViewController.h"
#import "Photo.h"

static NSInteger amountToImport = 200;
static BOOL addRatingRecords = YES;

@interface PhotoTableViewController ()

@end

@implementation PhotoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    
    if (!importRequire && addRatingRecords) {
        NSFetchRequest *ratingFetch = [NSFetchRequest fetchRequestWithEntityName:@"Rating"];
        NSError *ratingError = nil;
        NSUInteger ratingCount = [self.coreDataStack.mainContext countForFetchRequest:ratingFetch error:&ratingError];
        if (ratingCount == 0) {
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
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";

    NSInteger counter = 0;
    
    
    
 
    
    
//    @property (nullable, nonatomic, retain) NSDate *uploadDate;
//    @property (nullable, nonatomic, retain) NSNumber *width;
//    @property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *usage;

    for (NSDictionary *jsonDict in jsonArray) {
        counter ++;
        NSString *city = jsonDict[@"city"];
        NSTimeInterval startDateStamp = [jsonDict[@"ori_time"] doubleValue];
        NSString *photoID = jsonDict[@"id"];
        NSString *imageURL = [jsonDict valueForKeyPath:@"thumb.l"];
        NSString *thumbURL = [jsonDict valueForKey:@"thumb.s2"];
        CGFloat height = [jsonDict[@"height"] floatValue];
        CGFloat width = [jsonDict[@"width"] floatValue];
        NSTimeInterval uploadDateStamp = [jsonDict[@"created_at"] doubleValue];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
