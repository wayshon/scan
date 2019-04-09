//
//  MainCollectionViewCell.h
//  scan
//
//  Created by 王旭 on 2019/4/9.
//  Copyright © 2019 王旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^CellErrorBlock)(NSInteger index);
typedef void(^CellSuccessBlock)(NSInteger index, UIImage *image);

@interface MainCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) MainModel *model;
@property (nonatomic, copy) CellErrorBlock errorBlock;
@property (nonatomic, copy) CellSuccessBlock successBlock;

- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)setFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
