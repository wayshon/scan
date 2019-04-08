//
//  WaterfallCollectionViewCell.m
//  tools
//
//  Created by jike1 on 2019/3/22.
//  Copyright © 2019 王旭. All rights reserved.
//

#import "WaterfallCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface WaterfallCollectionViewCell()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) BOOL isInited;

@end

@implementation WaterfallCollectionViewCell

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self initViews];
}

- (void) initViews {
    if (!_isInited) {
        _isInited = YES;
        
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.imgView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.label.textColor = [UIColor colorWithRed:0 green:255 blue:255 alpha:1];
        self.label.font = [UIFont fontWithName:@"Arial" size:18.0f];
        self.label.textAlignment = 1;
        self.label.numberOfLines = 0;
        
        [self setBackgroundColor:[UIColor colorWithRed:182 green:238 blue:238 alpha:1]];
    }
}

- (void)setModel:(WaterfallModel *)model {
    _model = model;
    
    [self updateViews];
    
    NSString *src = _model.src;
    NSString *title = _model.title;
    
    if ([src rangeOfString:@"https://"].location == NSNotFound && [src rangeOfString:@"http://"].location == NSNotFound) {
        [self.imgView setImage:[UIImage imageNamed:src]];
    } else {
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:src] placeholderImage:[self createImageWithColor: RandomRGBColor]];
    }
    
    [self addSubview:self.imgView];
    self.label.text = title;
    [self addSubview:self.label];
}

- (void)updateViews {
    CGSize size = self.bounds.size;
    [self.imgView setFrame:CGRectMake(0, 0, size.width, size.height - 28)];
    [self.label setFrame:CGRectMake(0, size.height - 23, size.width, 18)];
}

- (UIImage*)createImageWithColor: (UIColor*) color {
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
