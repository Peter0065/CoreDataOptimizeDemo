//
//  Usage+CoreDataProperties.h
//  CoreDataDemo
//
//  Created by LinPeihuang on 16/8/30.
//  Copyright © 2016年 LinPeihuang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Usage.h"

NS_ASSUME_NONNULL_BEGIN

@interface Usage (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSNumber *detail;
@property (nullable, nonatomic, retain) Photo *photo;

@end

NS_ASSUME_NONNULL_END
