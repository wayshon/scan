//
//  ScanCollectionViewCell.h
//  tools
//
//  Created by 王旭 on 2019/3/25.
//  Copyright © 2019 王旭. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ScanCellErrorBlock)(NSInteger index);
typedef void(^ScanCellSuccessBlock)(NSInteger index, UIImage *image);

@interface ScanCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSDictionary *dic;
@property (nonatomic, copy) ScanCellErrorBlock errorBlock;
@property (nonatomic, copy) ScanCellSuccessBlock successBlock;

- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)setFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
