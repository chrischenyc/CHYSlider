//
//  ViewController.m
//  CHYSliderDemo
//
//  Created by Chen Chris on 8/16/12.
//  Copyright (c) 2012 ciderstudios.com. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*    
     the CHYSlider shall be initiated with default settings out of XIB file
     nevertheless, we can still customzie it as we want
     */
    
    // the first slider is a continuous-value slider
    _continuousSlider.labelAboveThumb.font = [UIFont boldSystemFontOfSize:25.f];
    
    // the second slider is a stepped-value slider
    _steppedSlider.stepped = YES;
    _steppedSlider.minimumValue = 1;
    _steppedSlider.maximumValue = 6;
    _steppedSlider.value = 2;
    _steppedSlider.labelOnThumb.hidden = YES;
    _steppedSlider.labelAboveThumb.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:20.f];
    _steppedSlider.labelAboveThumb.textColor = [UIColor blueColor];
    
    // these two labels will be updated with an IBAction method which is linked to slider's UIControlEventValueChanged event
    _continuousValueLabel.text = [NSString stringWithFormat:@"%.2f", _continuousSlider.value];
    _steppedValueLabel.text = [NSString stringWithFormat:@"%.2f", _steppedSlider.value];
}

- (void)viewDidUnload
{
    _continuousValueLabel = nil;
    _continuousSlider = nil;
    _steppedValueLabel = nil;
    _steppedSlider = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (IBAction)sliderValueChanged:(id)sender {
    _continuousValueLabel.text = [NSString stringWithFormat:@"%.2f", _continuousSlider.value];
    _steppedValueLabel.text = [NSString stringWithFormat:@"%.2f", _steppedSlider.value];
}
@end
