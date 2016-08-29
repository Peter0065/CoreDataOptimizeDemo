//
//  CoreDataStack.h
//  CoreDataDemo
//
//  Created by PeterLin on 16/8/29.
//  Copyright © 2016年 LinPeihuang. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;

@interface CoreDataStack : NSObject

/**< 主线程Context */
@property (nonatomic, strong) NSManagedObjectContext *mainContext;

/**
 *  保存Context
 */
- (void)saveContext;
@end
