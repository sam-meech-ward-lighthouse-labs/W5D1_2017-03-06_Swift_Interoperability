//
//  ViewController.m
//  Photos
//
//  Created by Sam Meech-Ward on 2017-03-04.
//  Copyright © 2017 Sam Meech-Ward. All rights reserved.
//

#import "ViewController.h"

//#import "Photo.h"
#import "PhotoCollectionViewCell.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray<NSDictionary *> *photos;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self performRequest];
    
}


- (void)performRequest {
    NSURL *url = [NSURL URLWithString:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&format=json&api_key=ee67416e0ab6d455026b90b4bfb1e5a1&tags=cat&nojsoncallback=1&extras=url_m"];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            // Handle the error
            NSLog(@"error: %@", error.localizedDescription);
            return;
        }
        
        NSError *jsonError = nil;
        NSDictionary *jsonFlickrApi = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (jsonError) {
            // Handle the error
            NSLog(@"jsonError: %@", jsonError.localizedDescription);
            return;
        }
        
        self.photos = [self convertJSONToPhotos:jsonFlickrApi];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.collectionView reloadData];
        }];
        
    }];
    
    [dataTask resume];
    
}

- (NSArray *)convertJSONToPhotos:(NSDictionary *)json {
    NSDictionary *photosDictionary = json[@"photos"];
    NSArray *photoDictionaries = photosDictionary[@"photo"];
    return photoDictionaries;
}

#pragma mark - Collection View

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photo-cell" forIndexPath:indexPath];
    
    NSDictionary *photo = self.photos[indexPath.row];
    cell.label.text = photo[@"title"];
    
    NSURL *url = [NSURL URLWithString:photo[@"url_m"]];
    [self downloadImageAtURL:url andPhotoCell:cell];
    
    return cell;
}

- (void)downloadImageAtURL:(NSURL *)url andPhotoCell:(PhotoCollectionViewCell *)cell {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration]; // 2
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration]; // 3
    
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            // Handle the error
            NSLog(@"error: %@", error.localizedDescription);
            return;
        }
        
        NSData *data = [NSData dataWithContentsOfURL:location];
        
        UIImage *image = [UIImage imageWithData:data];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            cell.imageView.image = image;
        }];
        
    }];
    
    [downloadTask resume];
}

@end

