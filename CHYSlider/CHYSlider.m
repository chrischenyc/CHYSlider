//
//  CHYSlider.m
//  CHYSliderDemo
//
//  Created by Chen Chris on 8/16/12.
//  Copyright (c) 2012 ciderstudios.com. All rights reserved.
//

#import "CHYSlider.h"

@interface CHYSlider ()
- (void)commonInit;
-(float)xForValue:(float)value;
@end

@implementation CHYSlider
@synthesize value = _value;
@synthesize minimumValue = _minimumValue;
@synthesize maximumValue = _maximumValue;
@synthesize continuous = _continuous;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;    
}

- (void)commonInit
{
    _value = 0.f;
    _minimumValue = 0.f;
    _maximumValue = 1.f;
    _continuous = YES;
    _thumbOn = NO;
    
    self.backgroundColor = [UIColor clearColor];
    
    _trackImageViewNormal = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"track_grey.png"]];
    [self addSubview:_trackImageViewNormal];
    
    _trackImageViewHighlighted = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"track_orange.png"]];
    [self addSubview:_trackImageViewHighlighted];
    
    _thumbImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"thumb.png"]];
    [self addSubview:_thumbImageView];
}

// re-layout subviews in case of first initialization and screen orientation changes
// track_grey.png and track_orange.png original size: 384x64
// thumb.png original size: 91x98
- (void)layoutSubviews
{
    _trackImageViewNormal.frame = self.bounds;
    _trackImageViewHighlighted.frame = self.bounds;
    CGFloat thumbHeight = 98.f *  _trackImageViewNormal.bounds.size.height / 64.f;   // thumb height is relative to track height
    CGFloat thumbWidth = 91.f * thumbHeight / 98.f; // thumb width and height keep the same ratio as the original image size
    _thumbImageView.frame = CGRectMake(0, 0, thumbWidth, thumbHeight);
    _thumbImageView.center = CGPointMake([self xForValue:_value], CGRectGetMidY(_trackImageViewNormal.frame));
    
}

-(float)xForValue:(float)value{
    return self.frame.size.width * (value - _minimumValue) / (_maximumValue - _minimumValue);
}

-(float) valueForX:(float)x{
    return _minimumValue + x / self.frame.size.width * (_maximumValue - _minimumValue);
}

#pragma mark - Touch events handling
-(BOOL) beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchPoint = [touch locationInView:self];
    if(CGRectContainsPoint(_thumbImageView.frame, touchPoint)){
        _thumbOn = YES;
    }else {
        _thumbOn = NO;
    }
    return YES;
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    if (_thumbOn) {
        _value = [self valueForX:_thumbImageView.center.x];
    }
    _thumbOn = NO;
}

-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    if(!_thumbOn) return YES;
    
    CGPoint touchPoint = [touch locationInView:self];
    _thumbImageView.center = CGPointMake( MIN( MAX( [self xForValue:_minimumValue], touchPoint.x), [self xForValue:_maximumValue]), _thumbImageView.center.y);
    
    if (_continuous) {
        _value = [self valueForX:_thumbImageView.center.x];
    }
    
    [self setNeedsDisplay];
    return YES;
}

@end
