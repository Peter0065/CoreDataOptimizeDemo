//
//  PhotoDetailViewController.m
//  CoreDataDemo
//
//  Created by PeterLin on 16/8/31.
//  Copyright © 2016年 LinPeihuang. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "Photo.h"
@interface PhotoDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation PhotoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.image = [UIImage imageWithData:self.photo.image];
}

@end
