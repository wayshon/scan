//
//  CollectionViewLayout.h
//  scan
//
//  Created by 王旭 on 2019/4/9.
//  Copyright © 2019 王旭. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CollectionViewLayout;

@protocol MainCollectionViewDelegate <NSObject>

@required
- (CGFloat)waterflowLayout:(CollectionViewLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth;

@optional
- (NSInteger)columnCountInWaterflowLayout:(CollectionViewLayout *)waterflowLayout;
- (CGFloat)columnMarginInWaterflowLayout:(CollectionViewLayout *)waterflowLayout;
- (CGFloat)rowMarginInWaterflowLayout:(CollectionViewLayout *)waterflowLayout;
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(CollectionViewLayout *)waterflowLayout;

@end


@interface CollectionViewLayout : UICollectionViewLayout

@property (nonatomic, weak) id<MainCollectionViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
