//
//  CoreDataStack.m
//  CoreDataDemo
//
//  Created by PeterLin on 16/8/29.
//  Copyright © 2016年 LinPeihuang. All rights reserved.
//

#import "CoreDataStack.h"

@interface CoreDataStack ()
@property (nonatomic, strong) NSPersistentStoreCoordinator *psc;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@end

@implementation CoreDataStack
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupCoreDataStack];
    }
    return self;
}

- (void)setupCoreDataStack {
    //1、获取Model (Model.xcdatamodeld)
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    //2、创建PersistentStoreCoordinator
    self.psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    //3、初始化mainContext
    self.mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.mainContext.persistentStoreCoordinator = self.psc;
    
    //4、添加PersistentStore
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Photos"];
    
    NSError *error = nil;
    NSPersistentStore *store = [self.psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
    if (!store || error) {
        NSLog(@"Error adding persistent store:%@",error);
        abort();
    }
}

/**
 *  You’re going to store the SQLite database in the documents directory. This is the 
 *  recommended place to store the user’s data, whether or not you’re using Core Data.
 */
- (NSURL *)applicationDocumentsDirectory {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *urls = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    return [urls firstObject];
}

- (void)saveContext {
    NSError *error = nil;
    if (self.mainContext.hasChanges && ![self.mainContext save:&error]) {
        NSLog(@"Could not save:%@",error);
    }
}
@end
