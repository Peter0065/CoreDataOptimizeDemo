//
//  AppDelegate.m
//  CoreDataDemo
//
//  Created by LinPeihuang on 16/8/29.
//  Copyright © 2016年 LinPeihuang. All rights reserved.
//

#import "AppDelegate.h"
#import "CoreDataStack.h"
#import "Photo.h"
#import "Usage.h"
#import "PhotoTableViewController.h"
#import "CategoryTableViewController.h"

static NSInteger amountToImport = 50;
static BOOL addUsageRecords = NO;

@interface AppDelegate ()
@property (nonatomic, strong) CoreDataStack *coreDataStack;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.coreDataStack = [[CoreDataStack alloc] init];
    
    [self importJSONSeedDataIfNeeded];
    
    UITabBarController *tabController = (UITabBarController *)self.window.rootViewController;
    UINavigationController *employeeListNavigationController = tabController.viewControllers[0];
    PhotoTableViewController *photoTableViewController = (PhotoTableViewController *)employeeListNavigationController.topViewController;
    photoTableViewController.coreDataStack = self.coreDataStack;
    
    UINavigationController *departmentListNavigationController = tabController.viewControllers[1];
    CategoryTableViewController *categoryTableViewController = (CategoryTableViewController *)departmentListNavigationController.topViewController;
    categoryTableViewController.coreDataStack = self.coreDataStack;
    
    return YES;
}

- (void)importJSONSeedDataIfNeeded {
    BOOL importRequire = NO;
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    NSError *error = nil;
    NSUInteger photoCount = [self.coreDataStack.mainContext countForFetchRequest:fetchRequest error:&error];
    if (photoCount != amountToImport) {
        importRequire = YES;
    }
    
    if (!importRequire && addUsageRecords) {
        NSFetchRequest *usageFetch = [NSFetchRequest fetchRequestWithEntityName:@"Usage"];
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
        NSInteger records = MAX(0, MIN(600, amountToImport));
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
        NSNumber *height = jsonDict[@"height"];
        NSNumber *width = jsonDict[@"width"];
        NSTimeInterval uploadDateStamp = [jsonDict[@"created_at"] doubleValue];
        
        Photo *photo = [[Photo alloc] initWithEntity:entity insertIntoManagedObjectContext:self.coreDataStack.mainContext];
        photo.photoID = photoID;
        photo.city = city;
        photo.createDate = [NSDate dateWithTimeIntervalSince1970:createDateStamp];
        photo.uploadDate = [NSDate dateWithTimeIntervalSince1970:uploadDateStamp];
        photo.height = height;
        photo.width = width;
        
        NSString *imageName = [NSString stringWithFormat:@"scenery_%.2d",arc4random_uniform(10) + 1];
        NSURL *imageURL = [[NSBundle mainBundle] URLForResource:imageName withExtension:@"jpg"];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        photo.image = imageData;

//        photo.image = [self imageData:imageData scaledToWidth:60.f];

//        NSEntityDescription *originalImageEntity = [NSEntityDescription entityForName:@"Image" inManagedObjectContext:self.coreDataStack.mainContext];
//        OriginalImage *originalImage = [[OriginalImage alloc] initWithEntity:originalImageEntity insertIntoManagedObjectContext:self.coreDataStack.mainContext];
//        originalImage.image = imageData;
//        photo.originalImage = originalImage;

        
        if (addUsageRecords) {
            [self addUsagesRecordsToPhoto:photo];
        }
        
        if (counter == records) {
            break;
        }
        
        if (counter % 20 == 0) {
            [self.coreDataStack saveContext];
            [self.coreDataStack.mainContext reset];
//            NSLog(@"save %%20");
        }
    }
    NSLog(@"last save");
    [self.coreDataStack saveContext];
    [self.coreDataStack.mainContext reset];
}

- (void)addUsagesRecordsToPhoto:(Photo *)photo {
    NSInteger numberOfUsages = 10 + arc4random_uniform(20);
    for (NSInteger i = 0; i < numberOfUsages; i ++) {
        Usage *usage = [NSEntityDescription insertNewObjectForEntityForName:@"Usage" inManagedObjectContext:self.coreDataStack.mainContext];
        usage.photo = photo;
        usage.detail = [NSNumber numberWithUnsignedInteger:arc4random_uniform(5)];//@"Detail description of photo usage";
        usage.date = [NSDate date];
    }
}

- (NSData *)imageData:(NSData *)imageData scaledToWidth:(CGFloat)width {
    UIImage *image = [UIImage imageWithData:imageData];
    CGFloat oldWidth = image.size.width;
    CGFloat scaleFactor = width / oldWidth;
    CGFloat newHight = image.size.width * scaleFactor;
    CGSize newSize = CGSizeMake(width, newHight);
    CGRect newRect = CGRectMake(0, 0, width, newHight);
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:newRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *newImageData = UIImageJPEGRepresentation(newImage, 0.8);
    return newImageData;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
