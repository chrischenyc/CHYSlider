CHYSlider
====================

CHYSlider is a drop-in iOS control that functions the same way `UISlider` does yet provides great look and feel. If you feel the official UISlider is a bit dull and are looking for something than can add a flavor to your iPhone/iPad apps, CHYSlider is what you want!

[![](https://dl.dropbox.com/u/12111329/github/CHYSlider/1.png)](https://dl.dropbox.com/u/12111329/github/CHYSlider/1.png)
[![](https://dl.dropbox.com/u/12111329/github/CHYSlider/2.png)](https://dl.dropbox.com/u/12111329/github/CHYSlider/2.png)

What the demo on Youtube: http://youtu.be/1NHyL-Mcn0E

Requirements
============

* iOS 5.0 and above
* Xcode 4.2 and above (CHYSlider uses ARC. non-ARC support is planned in future version)
* Frameworks: Foundation, UIKit, CoreGraphics

Adding CHYSlider to your project
====================================

The simplest way to add the CHYSlider to your project is to directly add the CHYSlider folder to your project.

1. Download the latest code version from the repository (you can simply use the Download Source button and get the zip or tar archive of the master branch).
2. Extract the archive.
3. Open your project in Xcode, than drag and drop `CHYSlider` folder to your classes group (in the Groups & Files view). 
4. Make sure to select Copy items when asked. 

If you have a git tracked project, you can add CHYSlider as a submodule to your project. 

1. Move inside your git tracked project.
2. Add CHYSlider as a submodule using `git submodule add git://github.com/chenyuan/CHYSlider.git CHYSlider` .
3. Open your project in Xcode, than drag and drop `CHYSlider` folder to your classes group (in the Groups & Files view). 
4. Don't select Copy items and select a suitable Reference type (relative to project should work fine most of the time). 

You can also add CHYSlider as a static library to your workspace. See [this article](http://blog.carbonfive.com/2011/04/04/using-open-source-static-libraries-in-xcode-4/#using_a_static_library) for details. 

Usage
=====

* For use with xib files, drop in a 'UIView' control and make it a `CHYSlider` class in the xib. You may want to add an IBAction method to observe the `UIControlEventValueChanged` event which is triggered when user moves the slider knob.
* Or you can instantialize a `CHYSlider` object the same way you work with `UIControl`.

UISlider-like Properties
========================
* `float value` - default 0.0. this value will be pinned to min/max.
* `float minimumValue` - default 0.0. the current value may change if outside new min value.
* `float maximumValue` - default 1.0. the current value may change if outside new max value.
* `BOOL continuous` - default YES. if set, value change events are generated any time the value changes due to dragging.

Customizable Properties
=======================
* `UILabel labelOnThumb` - overlayed above the thumb knob, moves along with the thumb. You may customize its `font`, `textColor` and other properties.
* `UILabel labelAboveThumb` - displayed on top fo the thumb, moves along with the thumb. You may customize its `font`, `textColor` and other properties.
* `int decimalPlaces` - determin how many decimal places are displayed in the value labels.
* `BOOL stepped` - default NO. if set, the slider is segmented by 6 values, and thumb only stays on these values. (Note: the stepped slider is not fully implemented, I'm considering adding a NSArray steppedValues property in next release)

License
=======

This code is distributed under the terms and conditions of the MIT license. 

Copyright (c) 2012 Yuan Chen (chris@ciderstudios.com)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Change-log
==========

**Version 0.1** @ Sept 3, 2012

- Initial release.