//
//  Photo+CoreDataProperties.h
//  CoreDataDemo
//
//  Created by LinPeihuang on 16/9/4.
//  Copyright © 2016年 LinPeihuang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Photo.h"
#import "OriginalImage.h"
NS_ASSUME_NONNULL_BEGIN

@interface Photo (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *city;
@property (nullable, nonatomic, retain) NSDate *createDate;
@property (nullable, nonatomic, retain) NSNumber *height;
@property (nullable, nonatomic, retain) NSString *photoID;
@property (nullable, nonatomic, retain) NSData *thumb;
@property (nullable, nonatomic, retain) NSDate *uploadDate;
@property (nullable, nonatomic, retain) NSNumber *width;
//<step_2>
@property (nullable, nonatomic, retain) OriginalImage *originalImage;
@property (nullable, nonatomic, retain) NSSet<Usage *> *usages;

@end

@interface Photo (CoreDataGeneratedAccessors)

- (void)addUsageObject:(Usage *)value;
- (void)removeUsageObject:(Usage *)value;
- (void)addUsage:(NSSet<Usage *> *)values;
- (void)removeUsage:(NSSet<Usage *> *)values;

@end

NS_ASSUME_NONNULL_END
