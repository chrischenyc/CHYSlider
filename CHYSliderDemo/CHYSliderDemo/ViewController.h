//
//  ViewController.h
//  CHYSliderDemo
//
//  Created by Chen Chris on 8/16/12.
//  Copyright (c) 2012 ciderstudios.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHYSlider.h"

@interface ViewController : UIViewController {
    __unsafe_unretained IBOutlet UILabel *_continuousValueLabel;
    __unsafe_unretained IBOutlet CHYSlider *_continuousSlider;
    __unsafe_unretained IBOutlet UILabel *_steppedValueLabel;
    __unsafe_unretained IBOutlet CHYSlider *_steppedSlider;
}

- (IBAction)sliderValueChanged:(id)sender;
@end
