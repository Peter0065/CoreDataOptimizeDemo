//
//  Photo+CoreDataProperties.h
//  CoreDataDemo
//
//  Created by PeterLin on 16/9/3.
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
@property (nullable, nonatomic, retain) NSString *photoID;
@property (nullable, nonatomic, retain) NSData *image;
@property (nullable, nonatomic, retain) NSDate *uploadDate;
@property (nullable, nonatomic, retain) NSNumber *width;
@property (nullable, nonatomic, retain) NSSet<Usage *> *usage;
//<step_1>
@property (nullable, nonatomic, retain) NSData *thumb;

@end

@interface Photo (CoreDataGeneratedAccessors)

- (void)addUsageObject:(Usage *)value;
- (void)removeUsageObject:(Usage *)value;
- (void)addUsage:(NSSet<Usage *> *)values;
- (void)removeUsage:(NSSet<Usage *> *)values;

@end

NS_ASSUME_NONNULL_END
