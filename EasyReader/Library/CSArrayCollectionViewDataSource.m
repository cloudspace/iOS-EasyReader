//
//  CSArrayCollectionViewDataSource.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/15/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "CSArrayCollectionViewDataSource.h"

@implementation CSArrayCollectionViewDataSource

+ (CSArrayCollectionViewDataSource *)dataSourceWithArray:(NSArray *)array
                                 reusableCellIdentifier:(NSString*)reusableCellIdentifier
                                         configureBlock:(void (^)(UICollectionViewCell *cell, id item))configureBlock
{
    CSArrayCollectionViewDataSource *dataSource = [[CSArrayCollectionViewDataSource alloc] init];
    dataSource.source = array;
    dataSource.reusableCellIdentifier = reusableCellIdentifier;
    dataSource.configureCell = configureBlock;
    
    return dataSource;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.source count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.reusableCellIdentifier forIndexPath:indexPath];
    
    id item = self.source[indexPath.row];
    
    self.configureCell(cell, item);
    
    return cell;
}


@end
