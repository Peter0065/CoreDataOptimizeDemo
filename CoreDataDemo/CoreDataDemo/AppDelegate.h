//
//  AppDelegate.h
//  CoreDataDemo
//
//  Created by LinPeihuang on 16/8/29.
//  Copyright © 2016年 LinPeihuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)importJSONSeedDataIfNeeded;

@end

