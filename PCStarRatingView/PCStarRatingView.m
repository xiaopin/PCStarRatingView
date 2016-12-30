//
//  PCStarRatingView.m
//  https://github.com/xiaopin/PCStarRatingView
//
//  Created by nhope on 2016/12/28.
//  Copyright © 2016年 xiaopin. All rights reserved.
//

#import "PCStarRatingView.h"

@implementation PCStarRatingView
{
    CGFloat _starsWidth; //stars container width
}

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)drawRect:(CGRect)rect {
    int number = (int)ceil(_maximumValue);
    int index = (int)floor(_value);
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat starDiameter = MIN((width-2*_offset.horizontal-(number-1)*_itemSpacing)/number, height-2*_offset.vertical);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set star's color
    [self.starTintColor setFill];
    [self.starTintColor setStroke];
    
    // draw stars
    for (int i=0; i<number; i++) {
        CGFloat x = i*starDiameter + _offset.horizontal + i*_itemSpacing;
        CGFloat y = (height-starDiameter-2*_offset.vertical)/2+_offset.vertical;
        UIBezierPath *starPath = [self starBezierPathWithX:x y:y diameter:starDiameter];
        
        // fill stars background
        if (i == index) {
            CGFloat fillWidth = (_value-index)*starDiameter;
            UIBezierPath *clipPath = [UIBezierPath bezierPathWithRect:CGRectInfinite];
            [clipPath appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(x+fillWidth, y, starDiameter-fillWidth, starDiameter)]];
            [clipPath setUsesEvenOddFillRule:YES];
            CGContextSaveGState(context);
            [clipPath addClip];
            [starPath fill];
            CGContextRestoreGState(context);
        } else if (i < index) {
            [starPath fill];
        } else {
            // do nothing.
        }

        // fill stars border
        [starPath setLineWidth:_borderWidth];
        [starPath stroke];
    }
    _starsWidth = starDiameter*number + _itemSpacing*(number-1);
}

#pragma mark - Touch Tracking

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super beginTrackingWithTouch:touch withEvent:event];
    [self updateValueWithTouch:touch];
    return [self isEnabled] && _maximumValue>0.0;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super continueTrackingWithTouch:touch withEvent:event];
    [self updateValueWithTouch:touch];
    return [self isEnabled];
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];
    [self updateValueWithTouch:touch];
}

#pragma mark - Actions

- (void)deviceOrientationDidChangeNotificationAction:(NSNotification *)sender {
    // redraw stars
    [self setNeedsDisplay];
}

#pragma mark - Private

- (void)setup {
    _maximumValue = 5.0;
    _minimumValue = 0.0;
    _value = 0.0;
    _starTintColor = [self tintColor];
    _offset = UIOffsetMake(5.0, 0.0);
    _itemSpacing = 0.0;
    _borderWidth = 1.0;
    _starState = PCStarRatingViewStateAccurate;
    _radiusType = PCStarRatingViewRadiusTypeDefault;
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(deviceOrientationDidChangeNotificationAction:)
                   name:UIDeviceOrientationDidChangeNotification
                 object:nil];
}

- (void)updateValueWithTouch:(UITouch *)touch {
    CGFloat x = [touch locationInView:self].x;
    int number = (int)ceilf(_maximumValue);
    if (0==number || 0.0==_starsWidth) {
        return;
    }
    if (x < _offset.horizontal) {
        if (_value == _minimumValue) {
            return;
        }
        _value = _minimumValue;
    } else if (x >= _offset.horizontal+_starsWidth) {
        if (_value == _maximumValue) {
            return;
        }
        _value = _maximumValue;
    } else {
        int index = (int)floor((x-_offset.horizontal)/_starsWidth);
        CGFloat width = _starsWidth/number;
        CGFloat overstep = x-index*(width+_itemSpacing)-_offset.horizontal;
        CGFloat aValue = MIN(_maximumValue, MAX(_minimumValue, index+overstep/width));
        aValue = [self reviseValueWithValue:aValue];
        if (aValue == _value) return;
        _value = aValue;
    }
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    [self setNeedsDisplay];
}

- (CGFloat)reviseValueWithValue:(CGFloat)value {
    CGFloat result = 0.0;
    switch (_starState) {
        case PCStarRatingViewStateWhole:
            result = MIN(_maximumValue, ceilf(value));
            break;
        case PCStarRatingViewStateHalf: {
            float tmp;
            float f = modff(value, &tmp);
            if (f > 0.5) {
                result = MIN(_maximumValue, ceilf(value));
            } else if (f > 0.0) {
                result = floorf(value)+0.5;
            } else {
                result = value;
            }
        }
            break;
        case PCStarRatingViewStateAccurate:
        default:
            result = value;
            break;
    }
    return result;
}

- (UIBezierPath *)starBezierPathWithX:(CGFloat)x y:(CGFloat)y diameter:(CGFloat)diameter {
    UIBezierPath* starPath = [UIBezierPath bezierPath];
    [starPath moveToPoint:CGPointMake(x+diameter*0.50000, y+diameter*0.02500)];
    switch (_radiusType) {
        case PCStarRatingViewRadiusTypeLarge:
            [starPath addLineToPoint:CGPointMake(x+diameter*0.31292, y+diameter*0.31309)];
            [starPath addLineToPoint:CGPointMake(x+diameter*0.02500, y+diameter*0.39112)];
            [starPath addLineToPoint:CGPointMake(x+diameter*0.24504, y+diameter*0.68908)];
            [starPath addLineToPoint:CGPointMake(x+diameter*0.20642, y+diameter*0.97500)];
            [starPath addLineToPoint:CGPointMake(x+diameter*0.50000, y+diameter*0.84265)];
            [starPath addLineToPoint:CGPointMake(x+diameter*0.79358, y+diameter*0.97500)];
            [starPath addLineToPoint:CGPointMake(x+diameter*0.75501, y+diameter*0.68908)];
            [starPath addLineToPoint:CGPointMake(x+diameter*0.97500, y+diameter*0.39112)];
            [starPath addLineToPoint:CGPointMake(x+diameter*0.68723, y+diameter*0.31309)];
            break;
        case PCStarRatingViewRadiusTypeMidium:
            [starPath addLineToPoint:CGPointMake(x+diameter*0.34292, y+diameter*0.34309)];
            [starPath addLineToPoint:CGPointMake(x+diameter*0.02500, y+diameter*0.39112)];
            [starPath addLineToPoint:CGPointMake(x+diameter*0.27504, y+diameter*0.65908)];
            [starPath addLineToPoint:CGPointMake(x+diameter*0.20642, y+diameter*0.97500)];
            [starPath addLineToPoint:CGPointMake(x+diameter*0.50000, y+diameter*0.81265)];
            [starPath addLineToPoint:CGPointMake(x+diameter*0.79358, y+diameter*0.97500)];
            [starPath addLineToPoint:CGPointMake(x+diameter*0.72501, y+diameter*0.65908)];
            [starPath addLineToPoint:CGPointMake(x+diameter*0.97500, y+diameter*0.39112)];
            [starPath addLineToPoint:CGPointMake(x+diameter*0.65723, y+diameter*0.34309)];
            break;
        case PCStarRatingViewRadiusTypeDefault:
        default:
            [starPath addLineToPoint:CGPointMake(x+diameter*0.37292, y+diameter*0.37309)];
            [starPath addLineToPoint:CGPointMake(x+diameter*0.02500, y+diameter*0.39112)];
            [starPath addLineToPoint:CGPointMake(x+diameter*0.30504, y+diameter*0.62908)];
            [starPath addLineToPoint:CGPointMake(x+diameter*0.20642, y+diameter*0.97500)];
            [starPath addLineToPoint:CGPointMake(x+diameter*0.50000, y+diameter*0.78265)];
            [starPath addLineToPoint:CGPointMake(x+diameter*0.79358, y+diameter*0.97500)];
            [starPath addLineToPoint:CGPointMake(x+diameter*0.69501, y+diameter*0.62908)];
            [starPath addLineToPoint:CGPointMake(x+diameter*0.97500, y+diameter*0.39112)];
            [starPath addLineToPoint:CGPointMake(x+diameter*0.62723, y+diameter*0.37309)];
            break;
    }
    [starPath closePath];
    return starPath;
}

#pragma mark - setter & getter

- (void)setMaximumValue:(CGFloat)maximumValue {
    if (_maximumValue == maximumValue) {
        return;
    }
    _maximumValue = MAX(1, maximumValue);
    if (_maximumValue < _value) {
        [self setValue:_maximumValue];
    }
    [self setNeedsDisplay];
}

- (void)setMinimumValue:(CGFloat)minimumValue {
    if (_minimumValue == minimumValue) {
        return;
    }
    _minimumValue = MAX(0, minimumValue);
    if (_minimumValue > _value) {
        [self setValue:_minimumValue];
    }
    [self setNeedsDisplay];
}

- (void)setValue:(CGFloat)value {
    CGFloat aValue = MIN(_maximumValue, MAX(_minimumValue, value));
    if (aValue == _value) {
        return;
    }
    _value = [self reviseValueWithValue:aValue];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    [self setNeedsDisplay];
}

- (void)setStarTintColor:(UIColor *)starTintColor {
    _starTintColor = starTintColor;
    [self setNeedsDisplay];
}

- (void)setItemSpacing:(CGFloat)itemSpacing {
    if (itemSpacing != _itemSpacing) {
        _itemSpacing = MAX(itemSpacing, 0.0);
        [self setNeedsDisplay];
    }
}

- (void)setOffset:(UIOffset)offset {
    _offset = UIOffsetMake(ABS(offset.horizontal), ABS(offset.vertical));
    [self setNeedsDisplay];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    if (borderWidth != _borderWidth) {
        _borderWidth = MIN(5.0, MAX(0.5, borderWidth));
        [self setNeedsDisplay];
    }
}

- (void)setStarState:(PCStarRatingViewState)starState {
    _starState = starState;
    [self setNeedsDisplay];
}

- (void)setRadiusType:(PCStarRatingViewRadiusType)radiusType {
    _radiusType = radiusType;
    [self setNeedsDisplay];
}

@end
