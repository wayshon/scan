//
//  Fetch.h
//  tools
//
//  Created by jike1 on 2019/3/21.
//  Copyright © 2019 王旭. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Fetch : NSObject

/**
 block回调
 
 @param array 抓取的数组
 */
typedef void(^FetchDataBlock)(NSArray * _Nullable array);

typedef void(^FetchBlock)(NSArray * _Nullable array);

@property (nonatomic, strong) NSArray *list;

@property(nonatomic, copy) FetchDataBlock block;

+ (instancetype)sharedFetch;

- (void)refresh:(FetchBlock)block;
- (void)loadMore:(FetchBlock)block;

@end

NS_ASSUME_NONNULL_END
