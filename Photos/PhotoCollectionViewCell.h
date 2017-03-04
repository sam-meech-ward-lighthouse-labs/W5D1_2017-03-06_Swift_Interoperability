//
//  PhotoCollectionViewCell.h
//  FlickrSomething
//
//  Created by Sam Meech-Ward on 2016-11-21.
//  Copyright © 2016 Sam Meech-Ward. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end
