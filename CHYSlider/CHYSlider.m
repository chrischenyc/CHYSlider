//
//  CHYSlider.m
//  CHYSliderDemo
//
//  Created by Chen Chris on 8/16/12.
//  Copyright (c) 2012 ciderstudios.com. All rights reserved.
//

#import "CHYSlider.h"
#import <QuartzCore/QuartzCore.h>

@interface CHYSlider ()
- (void)commonInit;
- (float)xForValue:(float)value;
- (float)valueForX:(float)x;
- (float)stepMarkerXCloseToX:(float)x;
- (void)updateTrackHighlight;                  // set up track images overlay according to currernt value
- (NSString *)valueStringFormat;                // form value string format with given decimal places
@end

@implementation CHYSlider
@synthesize value = _value;
@synthesize minimumValue = _minimumValue;
@synthesize maximumValue = _maximumValue;
@synthesize continuous = _continuous;
@synthesize labelOnThumb = _labelOnThumb;
@synthesize labelAboveThumb = _labelAboveThumb;
@synthesize stepped = _stepped;
@synthesize decimalPlaces = _decimalPlaces;

#pragma mark - UIView methods
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
    _labelAboveThumb.frame = CGRectMake(_labelOnThumb.frame.origin.x, _labelOnThumb.frame.origin.y - _labelOnThumb.frame.size.height * 0.6f, _labelOnThumb.frame.size.width, _labelOnThumb.frame.size.height);
    
    // the track
    [self updateTrackHighlight];
}

- (void)drawRect:(CGRect)rect
{
    _labelOnThumb.center = _thumbImageView.center;
    _labelAboveThumb.center = CGPointMake(_thumbImageView.center.x, _thumbImageView.center.y - _labelAboveThumb.frame.size.height * 0.6f);
    
    [self updateTrackHighlight];
}

#pragma mark - Accessor Overriding

// use diffrent track background images accordingly
- (void)setStepped:(BOOL)stepped
{
    _stepped = stepped;
    NSString *trackImageNormal;
    NSString *trackImageHighlighted;
    if (_stepped) {
        trackImageNormal = @"stepped_track_grey.png";
        trackImageHighlighted = @"stepped_track_orange.png";
    }
    else {
        trackImageNormal = @"track_grey.png";
        trackImageHighlighted = @"track_orange.png";
    }
    _trackImageViewNormal.image = [UIImage imageNamed:trackImageNormal];
    _trackImageViewHighlighted.image = [UIImage imageNamed:trackImageHighlighted];
}

- (void)setValue:(float)value
{
    if (value < _minimumValue || value > _maximumValue) {
        return;
    }
    
    _value = value;
    
    _thumbImageView.center = CGPointMake([self xForValue:value], _thumbImageView.center.y);
    
    _labelOnThumb.text = [NSString stringWithFormat:[self valueStringFormat], _value];
    _labelAboveThumb.text = [NSString stringWithFormat:[self valueStringFormat], _value];
    
    [self setNeedsDisplay];
}

#pragma mark - Helpers
- (void)commonInit
{
    _value = 0.f;
    _minimumValue = 0.f;
    _maximumValue = 1.f;
    _continuous = YES;
    _thumbOn = NO;
    _stepped = NO;
    _decimalPlaces = 0;
    
    self.backgroundColor = [UIColor clearColor];
    
    // the track background images
    _trackImageViewNormal = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"track_grey.png"]];
    [self addSubview:_trackImageViewNormal];
    _trackImageViewHighlighted = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"track_orange.png"]];
    [self addSubview:_trackImageViewHighlighted];
    
    // thumb knob
    _thumbImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"thumb.png"]];
    [self addSubview:_thumbImageView];
    
    // value labels
    _labelOnThumb = [[UILabel alloc] init];
    _labelOnThumb.backgroundColor = [UIColor clearColor];
    _labelOnThumb.textAlignment = UITextAlignmentCenter;
    _labelOnThumb.text = [NSString stringWithFormat:[self valueStringFormat], _value];
    _labelOnThumb.textColor = [UIColor whiteColor];
    [self addSubview:_labelOnThumb];
    
    _labelAboveThumb = [[UILabel alloc] init];
    _labelAboveThumb.backgroundColor = [UIColor clearColor];
    _labelAboveThumb.textAlignment = UITextAlignmentCenter;
    _labelAboveThumb.text = [NSString stringWithFormat:[self valueStringFormat], _value];
    _labelAboveThumb.textColor = [UIColor colorWithRed:232.f/255.f green:151.f/255.f blue:79.f/255.f alpha:1.f];
    [self addSubview:_labelAboveThumb];
}

- (float)xForValue:(float)value
{
    return self.frame.size.width * (value - _minimumValue) / (_maximumValue - _minimumValue);
}

- (float)valueForX:(float)x
{
    return _minimumValue + x / self.frame.size.width * (_maximumValue - _minimumValue);
}

- (float)stepMarkerXCloseToX:(float)x
{
    float xPercent = MIN(MAX(x / self.frame.size.width, 0), 1);
    float stepPercent = 1.f / 5.f;
    float midStepPercent = stepPercent / 2.f;
    int stepIndex = 0;
    while (xPercent > midStepPercent) {
        stepIndex++;
        midStepPercent += stepPercent;
    }
    
    return stepPercent * (float)stepIndex * self.frame.size.width;
}

- (void)updateTrackHighlight
{
    // Create a mask layer and the frame to determine what will be visible in the view.
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    CGFloat thumbMidXInHighlightTrack = CGRectGetMidX([self convertRect:_thumbImageView.frame toView:_trackImageViewNormal]);
    CGRect maskRect = CGRectMake(0, 0, thumbMidXInHighlightTrack, _trackImageViewNormal.frame.size.height);
    
    // Create a path and add the rectangle in it.
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, nil, maskRect);
    
    // Set the path to the mask layer.
    [maskLayer setPath:path];
    
    // Release the path since it's not covered by ARC.
    CGPathRelease(path);
    
    // Set the mask of the view.
    _trackImageViewHighlighted.layer.mask = maskLayer;
}

- (NSString *)valueStringFormat
{
    return [NSString stringWithFormat:@"%%.%df", _decimalPlaces];
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
        if (_stepped) {
            _thumbImageView.center = CGPointMake( [self stepMarkerXCloseToX:[touch locationInView:self].x], _thumbImageView.center.y);
            [self setNeedsDisplay];
        }
        _value = [self valueForX:_thumbImageView.center.x];
        _labelOnThumb.text = [NSString stringWithFormat:[self valueStringFormat], _value];
        _labelAboveThumb.text = [NSString stringWithFormat:[self valueStringFormat], _value];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    _thumbOn = NO;
}

-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    if(!_thumbOn) return YES;
    
    CGPoint touchPoint = [touch locationInView:self];
    
    _thumbImageView.center = CGPointMake( MIN( MAX( [self xForValue:_minimumValue], touchPoint.x), [self xForValue:_maximumValue]), _thumbImageView.center.y);
    
    if (_continuous && !_stepped) {
        _value = [self valueForX:_thumbImageView.center.x];
        _labelOnThumb.text = [NSString stringWithFormat:[self valueStringFormat], _value];
        _labelAboveThumb.text = [NSString stringWithFormat:[self valueStringFormat], _value];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    
    [self setNeedsDisplay];
    return YES;
}

@end
