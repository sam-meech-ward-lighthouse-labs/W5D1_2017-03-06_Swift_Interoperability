//
//  ViewController.m
//  Photos
//
//  Created by Sam Meech-Ward on 2017-03-04.
//  Copyright © 2017 Sam Meech-Ward. All rights reserved.
//

#import "ViewController.h"

#import "Photo.h"
#import "PhotoCollectionViewCell.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray<Photo *> *photos;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self performRequest];
    
}


- (void)performRequest {
    
    //    NSURL *url = [NSURL URLWithString:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=ee67416e0ab6d455026b90b4bfb1e5a1&has_geo=1&lat=49.282070&lon=123.108296&radius=20"]; // 1
    
    NSURL *url = [NSURL URLWithString:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&format=json&api_key=ee67416e0ab6d455026b90b4bfb1e5a1&tags=cat&nojsoncallback=1"];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url]; // 2
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration]; // 3
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration]; // 4
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) { // 1
            // Handle the error
            NSLog(@"error: %@", error.localizedDescription);
            return;
        }
        
        NSError *jsonError = nil;
        NSDictionary *jsonFlickrApi = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError]; // 2
        
        if (jsonError) { // 1
            // Handle the error
            NSLog(@"jsonError: %@", jsonError.localizedDescription);
            return;
        }
        
        NSDictionary *photosDictionary = jsonFlickrApi[@"photos"];
        NSArray *jsonPhotos = photosDictionary[@"photo"]; // 3
        
        NSLog(@"photo: %@", jsonPhotos[0]);
        
        self.photos = [self createPhotosFromJSON:jsonPhotos];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.collectionView reloadData];
        }];
        
    }];
    
    [dataTask resume]; // 7
    
}

- (NSArray<Photo *> *)createPhotosFromJSON:(NSArray *)jsonPhotos {
    NSMutableArray<Photo *> *photos = [NSMutableArray array];
    
    for (NSDictionary *jsonPhoto in jsonPhotos){
        
        Photo *photo = [[Photo alloc] initWithFlickrJSON:jsonPhoto];
        
        [photos addObject:photo];
    }
    
    return photos.copy;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Collection View

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photo-cell" forIndexPath:indexPath];
    
    Photo *photo = self.photos[indexPath.row];
    cell.label.text = photo.title;
    
    [self downloadImageForPhoto:photo forPhotoCell:cell];
    
    return cell;
}

- (void)downloadImageForPhoto:(Photo *)photo forPhotoCell:(PhotoCollectionViewCell *)cell {
    
    if (photo.cachedImage) {
        cell.imageView.image = photo.cachedImage;
        return;
    }
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration]; // 2
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration]; // 3
    
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:photo.photoURL completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) { // 1
            // Handle the error
            NSLog(@"error: %@", error.localizedDescription);
            return;
        }
        
        NSData *data = [NSData dataWithContentsOfURL:location]; // 2
        
        UIImage *image = [UIImage imageWithData:data]; // 3
        photo.cachedImage = image;
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // This will run on the main queue
            
            cell.imageView.image = image; // 4
        }];
        
    }];
    
    [downloadTask resume]; // 5
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Photo *photo = self.photos[indexPath.row];
    
    NSString *photoString = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&format=json&api_key=ee67416e0ab6d455026b90b4bfb1e5a1&tags=cat&nojsoncallback=1&photo_id=%@", photo.flickrId];
    NSURL *url = [NSURL URLWithString:photoString];
    NSLog(@"%@", photoString);
    
    //    NSURL *url = [NSURL URLWithString:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&format=json&api_key=ee67416e0ab6d455026b90b4bfb1e5a1&tags=cat&nojsoncallback=1"];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url]; // 2
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration]; // 3
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration]; // 4
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) { // 1
            // Handle the error
            NSLog(@"error: %@", error.localizedDescription);
            return;
        }
        
        NSError *jsonError = nil;
        NSDictionary *jsonFlickrApi = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError]; // 2
        
        if (jsonError) { // 1
            // Handle the error
            NSLog(@"jsonError: %@", jsonError.localizedDescription);
            return;
        }
        
        NSLog(@"flickr: %@", jsonFlickrApi);
        
    }];
    
    [dataTask resume]; // 7
    
}

@end

