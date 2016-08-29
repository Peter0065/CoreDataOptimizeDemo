//
//  Rating+CoreDataProperties.h
//  CoreDataDemo
//
//  Created by PeterLin on 16/8/29.
//  Copyright © 2016年 LinPeihuang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Rating.h"

NS_ASSUME_NONNULL_BEGIN

@interface Rating (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *star;
@property (nullable, nonatomic, retain) NSDate *date;

@end

NS_ASSUME_NONNULL_END
