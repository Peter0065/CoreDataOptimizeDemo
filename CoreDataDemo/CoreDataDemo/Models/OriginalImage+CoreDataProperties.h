//
//  OriginalImage+CoreDataProperties.h
//  CoreDataDemo
//
//  Created by LinPeihuang on 16/9/4.
//  Copyright © 2016年 LinPeihuang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "OriginalImage.h"

NS_ASSUME_NONNULL_BEGIN

@interface OriginalImage (CoreDataProperties)

@property (nullable, nonatomic, retain) NSData *image;
@property (nullable, nonatomic, retain) Photo *photo;

@end

NS_ASSUME_NONNULL_END
