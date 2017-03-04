//
//  Photo.m
//  FlickrSomething
//
//  Created by Sam Meech-Ward on 2016-11-21.
//  Copyright © 2016 Sam Meech-Ward. All rights reserved.
//

#import "Photo.h"

@interface Photo()

@property (nonatomic, copy, readwrite) NSString *flickrId;
@property (nonatomic, copy, readwrite) NSString *flickrSecret;
@property (nonatomic, copy, readwrite) NSString *flickrServer;
@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) NSURL *photoURL;

@end

@implementation Photo


- (instancetype)initWithFlickrJSON:(NSDictionary *)json {
    self = [super init];
    if (self) {
        _flickrId = json[@"id"];
        _flickrFarm = json[@"farm"];
        _flickrSecret = json[@"secret"];
        _flickrServer = json[@"server"];
        _title = json[@"title"];
        
        [self constructPhotoURL];
    }
    return self;
}

- (void)constructPhotoURL {
    NSString *urlString = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg", self.flickrFarm, self.flickrServer, self.flickrId, self.flickrSecret];
    
    self.photoURL = [NSURL URLWithString:urlString];
}

@end
