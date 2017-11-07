//
//  PCStarRatingView.h
//  https://github.com/xiaopin/PCStarRatingView
//
//  Created by nhope on 2016/12/28.
//  Copyright © 2016年 xiaopin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PCStarRatingViewState) {
    PCStarRatingViewStateAccurate   = 0, //Follow sliding distance, default.
    PCStarRatingViewStateHalf       = 1, //Half stars.
    PCStarRatingViewStateWhole      = 2  //Whole stars.
};


typedef NS_ENUM(NSInteger, PCStarRatingViewRadiusType) {
    PCStarRatingViewRadiusTypeDefault   = 0,
    PCStarRatingViewRadiusTypeMidium    = 1,
    PCStarRatingViewRadiusTypeLarge     = 2
};


/*IB_DESIGNABLE*/
@interface PCStarRatingView : UIControl

/// star's color, default `tintColor`
@property (nonatomic, strong) UIColor *starTintColor;
/// default `5.0`. the current value may change if outside new max value
@property (nonatomic, assign) CGFloat maximumValue;
/// default `0.0`. the current value may change if outside new min value
@property (nonatomic, assign) CGFloat minimumValue;
/// default `0.0`. this value will be pinned to min/max
@property (nonatomic, assign) CGFloat value;
/// default `0.0`
@property (nonatomic, assign) CGFloat itemSpacing;
/// default `(5.0, 0.0)`
@property (nonatomic, assign) UIOffset offset;
/// stars border width, between 0.5 and 5.0, default `1.0`
@property (nonatomic, assign) CGFloat borderWidth;
/// default `PCStarRatingViewStateAccurate`
@property (nonatomic, assign) PCStarRatingViewState starState;
/// default `PCStarRatingViewRadiusTypeDefault`
@property (nonatomic, assign) PCStarRatingViewRadiusType radiusType;

@end
