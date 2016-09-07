//
//  CategoryTableViewController.m
//  CoreDataDemo
//
//  Created by PeterLin on 16/8/29.
//  Copyright © 2016年 LinPeihuang. All rights reserved.
//

#import "CategoryTableViewController.h"
#import "Photo.h"
#import "PhotoTableViewController.h"

@interface CategoryTableViewController ()
@property (nonatomic, copy) NSArray *items;
@end

@implementation CategoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Category List";
    NSDate *loadStartTime = [NSDate date];
    self.items = [self totalPhotosPerCityFast];
    NSTimeInterval secondsLoad = [[NSDate date] timeIntervalSinceDate:loadStartTime];
    NSLog(@"%f seconds for load", secondsLoad);
}

- (NSArray *)totalPhotosPerCity {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    NSError *error = nil;
    //获取所有Photo对象
    NSArray *fetchObjects = [self.coreDataStack.mainContext executeFetchRequest:fetchRequest error:&error];
    
    if (!error) {
        NSMutableDictionary *cityPhotoDict = [NSMutableDictionary dictionary];
        for (Photo *photo in fetchObjects) {
            //使用字典@[{photo.city : count},...] 统计地点和相关图片数量信息
            NSInteger photoCityCount = [cityPhotoDict[photo.city] integerValue];
            if (photoCityCount > 0) {
                [cityPhotoDict setValue:@(photoCityCount + 1) forKey:photo.city];
            } else {
                [cityPhotoDict setValue:@1 forKey:photo.city];
            }
        }
        
        NSMutableArray *results = [NSMutableArray array];
        //拆分每组键值对放出数据源数组
        [cityPhotoDict enumerateKeysAndObjectsUsingBlock:^(NSString *city , NSNumber *photoCount, BOOL * _Nonnull stop) {
            NSDictionary *dict = @{@"city" : city , @"photoCount" : [photoCount stringValue]};
            [results addObject:dict];
        }];
        return results;
    } else {
        NSLog(@"ERROR :%@",error);
        return [NSArray array];
    }
}

- (NSArray *)totalPhotosPerCityFast {
    
    //1、实例一个NSExpressionDescription并命名为photoCount
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    expressionDescription.name = @"photoCount";
    
    //2、创建一个获取city数量count的NSExpression并赋给NSExpressionDescription
    expressionDescription.expression = [NSExpression expressionForFunction:@"count:" arguments:@[[NSExpression expressionForKeyPath:@"city"]]];
    
    //3、创建fetchRequest，设置propertiesToFetch未city 和expressionDescription（获取含该城市的数量）
    //   设置propertiesToGroupBy(使用该属性返回类型必须是NSDictionaryResultType)根据city来分组，由于这次我们并不关心具体的实体对象所以
    //   设置resultType = NSDictionaryResultType 它将返回一组包含城市名和相关数量的字段@[{photo.city : count},...]
    NSFetchRequest *fetchRequeset = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    fetchRequeset.propertiesToFetch = @[@"city",expressionDescription];
    fetchRequeset.propertiesToGroupBy = @[@"city"];
    fetchRequeset.resultType = NSDictionaryResultType;
    
    NSError *error = nil;
    //4、执行查询操作
    NSArray *fetchResults = [self.coreDataStack.mainContext executeFetchRequest:fetchRequeset error:&error];
    if (fetchResults && !error) {
        return fetchResults;
    } else {
        NSLog(@"ERROR:%@",error);
        return @[];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categoryCell" forIndexPath:indexPath];
    
    NSDictionary *cityDict = self.items[indexPath.row];
    
    cell.textLabel.text = cityDict[@"city"];
    cell.detailTextLabel.text = cityDict[@"photoCount"];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SegueCategoryListToPhotoList"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *cityDictionary = self.items[indexPath.row];
        NSString *city = cityDictionary[@"city"];
        PhotoTableViewController *viewController = [segue destinationViewController];
        viewController.coreDataStack = self.coreDataStack;
        viewController.city = city;
    }
}

@end
