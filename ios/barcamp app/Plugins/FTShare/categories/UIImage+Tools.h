//
//  UIImage+Tools.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 26/09/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tools)

// rotate UIImage to any angle
- (UIImage *)rotate:(UIImageOrientation)orient;

// rotate and scale image from iphone camera
- (UIImage *)rotateAndScaleFromCameraWithMaxSize:(CGFloat)maxSize;

// scale this image to a given maximum width and height
- (UIImage *)scaleWithMaxSize:(CGFloat)maxSize;
- (UIImage *)scaleWithMaxSize:(CGFloat)maxSize quality:(CGInterpolationQuality)quality;

#pragma mark conversion/detection

// converts UIImage to grayscale with 8bpp
+ (UIImage *)convertTo8bppGrayscaleFromImage:(UIImage *)uimage;

// maxSize = -1 when you don't want to scale the image
+ (UIImage *)convertTo8bppGrayscaleFromImage:(UIImage *)image scaleToMaximumSize:(NSInteger) maxSize;

//detects the skew of the UIImage passed, it converts image to grayscale if its not already in grayscale, than calculates the skew in range [degMinimum, degMaximum] with step check equal to degStep
+ (CGFloat)detectSkewOfTheImage:(UIImage *)image withDegreesRangeMinimum:(CGFloat) degMinimum andDegreesMaximum:(CGFloat) degMaximum degreesStep:(CGFloat) degStep;

#pragma mark rotation

// free rotate by given degrees, if degrees > 0 then rotation is ClockWise
+ (UIImage *)rotateImage:(UIImage *)image byDegrees:(CGFloat) degrees;
// rotation to given orientation, useful to change the image rotation after it was made with the camera, this rotates only by 90, -90, 
+ (UIImage *)rotateImage:(UIImage *)src andRotateAngle:(UIImageOrientation) orientation;

// if degrees < 0 than rotation is clockWise, otherwise CounterClockWise, degrees are in Deg
+ (CGPoint)rotatePoint:(CGPoint)point byDegrees:(CGFloat) degrees aroundOriginPoint:(CGPoint) origin;
// index 0 gives left-top point of rect, 2 gives right-top, 3 gives left-bottom, 4 gives right-bottom
+ (CGPoint)getPointAtIndex:(NSUInteger)index ofRect:(CGRect)rect;
// returns the size of the space that will use the new rotated image so that it will fit correctly in it
+ (CGSize)imageSizeForRect:(CGRect)rect rotatedByDegreees:(CGFloat)degrees;


@end
