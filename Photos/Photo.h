//
//  Photo.h
//  FlickrSomething
//
//  Created by Sam Meech-Ward on 2016-11-21.
//  Copyright © 2016 Sam Meech-Ward. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;

@interface Photo : NSObject

- (instancetype)initWithFlickrJSON:(NSDictionary *)json;

@property (nonatomic, strong) NSNumber *flickrFarm;
@property (nonatomic, copy, readonly) NSString *flickrId;
@property (nonatomic, copy, readonly) NSString *flickrSecret;
@property (nonatomic, copy, readonly) NSString *flickrServer;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSURL *photoURL;

@property (nonatomic, strong) UIImage *cachedImage;

@end
