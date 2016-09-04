//
//  PhotoViewCell.m
//  CoreDataDemo
//
//  Created by PeterLin on 16/8/31.
//  Copyright © 2016年 LinPeihuang. All rights reserved.
//

#import "PhotoViewCell.h"
#import "Photo.h"

@interface PhotoViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *thumb;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (nonatomic, strong) UIImage *defaultImage;
@end

@implementation PhotoViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.thumb.clipsToBounds = YES;
    // Initialization code
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)setPhoto:(Photo *)photo {
    _photo = photo;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //should reuse
    dateFormatter.dateFormat = @"yyyy-MM-dd";

//<step_1>
//    self.thumb.image = [UIImage imageWithData:photo.image];
    self.thumb.image = [UIImage imageWithData:photo.thumb];
    self.infoLabel.text = [NSString stringWithFormat:@"Snap in %@ at %@",[dateFormatter stringFromDate:photo.createDate], photo.city];
    self.sizeLabel.text = [NSString stringWithFormat:@"Size: %@ * %@",[photo.width stringValue], [photo.height stringValue]];
    
//<step_2>
//    NSLog(@"photo.original is fault? %@",[photo.originalImage isFault]?@"YES":@"NO");
}

- (UIImage *)defaultImage {
    return [UIImage imageNamed:@"icon_asset_default"];
}

@end
