//
//  CategoryTableViewController.h
//  CoreDataDemo
//
//  Created by PeterLin on 16/8/29.
//  Copyright © 2016年 LinPeihuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataStack.h"
@interface CategoryTableViewController : UITableViewController
@property (nonatomic, strong) CoreDataStack *coreDataStack;
@end
