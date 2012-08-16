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
@synthesize labelOnThumb = _labelOnThumb;
@synthesize labelAboveThumb = _labelAboveThumb;

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
    
    _labelOnThumb = [[UILabel alloc] init];
    _labelOnThumb.backgroundColor = [UIColor clearColor];
    _labelOnThumb.textAlignment = UITextAlignmentCenter;
    _labelOnThumb.text = [NSString stringWithFormat:@"%.1f", _value];
    [self addSubview:_labelOnThumb];
    
    _labelAboveThumb = [[UILabel alloc] init];
    _labelAboveThumb.backgroundColor = [UIColor clearColor];
    _labelAboveThumb.textAlignment = UITextAlignmentCenter;
    _labelAboveThumb.text = [NSString stringWithFormat:@"%.1f", _value];
    [self addSubview:_labelAboveThumb];
}

// re-layout subviews in case of first initialization and screen orientation changes
// track_grey.png and track_orange.png original size: 384x64
// thumb.png original size: 91x98
- (void)layoutSubviews
{
    // the track background
    _trackImageViewNormal.frame = self.bounds;
    _trackImageViewHighlighted.frame = self.bounds;
    
    // the thumb
    CGFloat thumbHeight = 98.f *  _trackImageViewNormal.bounds.size.height / 64.f;   // thumb height is relative to track height
    CGFloat thumbWidth = 91.f * thumbHeight / 98.f; // thumb width and height keep the same ratio as the original image size
    _thumbImageView.frame = CGRectMake(0, 0, thumbWidth, thumbHeight);
    _thumbImageView.center = CGPointMake([self xForValue:_value], CGRectGetMidY(_trackImageViewNormal.frame));
    
    // the labels
    _labelOnThumb.frame = _thumbImageView.frame;
    _labelAboveThumb.frame = CGRectMake(_labelOnThumb.frame.origin.x, _labelOnThumb.frame.origin.y - _labelOnThumb.frame.size.height * 0.75f, _labelOnThumb.frame.size.width, _labelOnThumb.frame.size.height);
}

- (void)drawRect:(CGRect)rect
{
    _labelOnThumb.center = _thumbImageView.center;
    _labelAboveThumb.center = CGPointMake(_thumbImageView.center.x, _thumbImageView.center.y - _labelAboveThumb.frame.size.height * 0.75f);
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
        _labelOnThumb.text = [NSString stringWithFormat:@"%.1f", _value];
        _labelAboveThumb.text = [NSString stringWithFormat:@"%.1f", _value];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    _thumbOn = NO;
}

-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    if(!_thumbOn) return YES;
    
    CGPoint touchPoint = [touch locationInView:self];
    _thumbImageView.center = CGPointMake( MIN( MAX( [self xForValue:_minimumValue], touchPoint.x), [self xForValue:_maximumValue]), _thumbImageView.center.y);
    
    if (_continuous) {
        _value = [self valueForX:_thumbImageView.center.x];
        _labelOnThumb.text = [NSString stringWithFormat:@"%.1f", _value];
        _labelAboveThumb.text = [NSString stringWithFormat:@"%.1f", _value];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    
    [self setNeedsDisplay];
    return YES;
}

@end
