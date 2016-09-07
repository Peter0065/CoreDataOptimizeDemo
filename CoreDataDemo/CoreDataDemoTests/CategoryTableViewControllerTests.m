//
//  CategoryTableViewControllerTests.m
//  CoreDataDemo
//
//  Created by LinPeihuang on 16/9/5.
//  Copyright © 2016年 LinPeihuang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CategoryTableViewController.h"
#import "CoreDataStack.h"
@interface CategoryTableViewControllerTests : XCTestCase

@end

@implementation CategoryTableViewControllerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testTotalPhotosPerCity {
    [self measureMetrics:@[XCTPerformanceMetric_WallClockTime] automaticallyStartMeasuring:NO forBlock:^{
        CategoryTableViewController *categoryList = [[CategoryTableViewController alloc] init];
        categoryList.coreDataStack = [[CoreDataStack alloc] init];
        [self startMeasuring];
        [categoryList totalPhotosPerCity];
        [self stopMeasuring];
    }];
}

- (void)testTotalPhotosPerCityFast {
    [self measureMetrics:@[XCTPerformanceMetric_WallClockTime] automaticallyStartMeasuring:NO forBlock:^{
        CategoryTableViewController *categoryList = [[CategoryTableViewController alloc] init];
        categoryList.coreDataStack = [[CoreDataStack alloc] init];
        [self startMeasuring];
        [categoryList totalPhotosPerCityFast];
        [self stopMeasuring];
    }];
}


- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
