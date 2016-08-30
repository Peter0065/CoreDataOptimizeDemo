//
//  Photo+CoreDataProperties.h
//  CoreDataDemo
//
//  Created by LinPeihuang on 16/8/30.
//  Copyright © 2016年 LinPeihuang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Photo.h"

NS_ASSUME_NONNULL_BEGIN

@interface Photo (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *city;
@property (nullable, nonatomic, retain) NSDate *createDate;
@property (nullable, nonatomic, retain) NSNumber *height;
@property (nullable, nonatomic, retain) NSString *image;
@property (nullable, nonatomic, retain) NSString *photoID;
@property (nullable, nonatomic, retain) NSString *thumb;
@property (nullable, nonatomic, retain) NSDate *uploadDate;
@property (nullable, nonatomic, retain) NSNumber *width;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *usage;

@end

@interface Photo (CoreDataGeneratedAccessors)

- (void)addUsageObject:(NSManagedObject *)value;
- (void)removeUsageObject:(NSManagedObject *)value;
- (void)addUsage:(NSSet<NSManagedObject *> *)values;
- (void)removeUsage:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
