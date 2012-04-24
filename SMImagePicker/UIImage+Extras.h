//
//  UIImage+Extras.h
//  SMImagePicker
//
//  Created by Sirius Dely on 4/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (Extras)

+ (UIImage*)cropImage:(UIImage *)image toRect:(CGRect)rect;
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)size;
+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size;
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)size;
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode imageToScale:(UIImage*)image bounds:(CGSize)bounds interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage*)scaleAndCropToSize:(CGSize)size;
- (UIImage*)imageByCroppingImage:(UIImage *)image toRect:(CGRect)rect;

UIImage* resizedImage(UIImage *inImage, CGRect thumbRect);

- (UIImage*)resizedImage:(UIImage*)image inRect:(CGRect)rect;
- (UIImage*)resizeImage:(UIImage*)image inRect:(CGRect)rect;

- (void)scaleAndRotateImage:(UIImage *)image;

UIImage *scaleAndRotateImage(UIImage *image);

- (UIImage *)makeResizedImage:(CGSize)size quality:(CGInterpolationQuality)interpolationQuality;

@end
