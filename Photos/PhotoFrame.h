//
//  PhotoFrame.h
//  Photos
//
//  Created by Sam Meech-Ward on 2017-03-06.
//  Copyright © 2017 Sam Meech-Ward. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotoFrame : NSObject

@property (nonatomic, strong) NSString *color;
@property (nonatomic, strong) NSString *size;
@property (nonatomic, strong, nullable) NSString *pattern;

- (instancetype)initWithColor:(NSString *)color size:(NSString *)size pattern:(NSString * _Nullable)pattern NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
