//
//  UIImage+Extras.m
//  SMImagePicker
//
//  Created by Sirius Dely on 4/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "UIImage+Extras.h"


@implementation UIImage (Extras)

+ (UIImage*)cropImage:(UIImage *)image toRect:(CGRect)rect {
	CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
	UIImage* crop = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);
	return crop;
}

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)size {
	UIGraphicsBeginImageContext(size);
	[image drawInRect:CGRectMake(0,0,size.width,size.height)];
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}

+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size {
    //If scaleFactor is not touched, no scaling will occur      
    CGFloat scaleFactor = 1.0;
	
    //Deciding which factor to use to scale the image (factor = targetSize / imageSize)
    if (image.size.width > size.width || image.size.height > size.height)
        if (!((scaleFactor = (size.width / image.size.width)) > (size.height / image.size.height))) //scale to fit width, or
            scaleFactor = size.height / image.size.height; // scale to fit heigth.
	
    UIGraphicsBeginImageContext(size); 
	
    //Creating the rect where the scaled image is drawn in
    CGRect rect = CGRectMake((size.width - image.size.width * scaleFactor) / 2,
                             (size.height -  image.size.height * scaleFactor) / 2,
                             image.size.width * scaleFactor, image.size.height * scaleFactor);
	
    //Draw the image into the rect
    [image drawInRect:rect];
	
    //Saving the image, ending image context
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return scaledImage;
}

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)size {
	UIImage *sourceImage = self;
	UIImage *newImage = nil;        
	CGSize imageSize = sourceImage.size;
	CGFloat width = imageSize.width;
	CGFloat height = imageSize.height;
	CGFloat targetWidth = size.width;
	CGFloat targetHeight = size.height;
	CGFloat scaleFactor = 0.0;
	CGFloat scaledWidth = targetWidth;
	CGFloat scaledHeight = targetHeight;
	CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
	
	if (CGSizeEqualToSize(imageSize, size) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
		
        if (widthFactor > heightFactor) 
			scaleFactor = widthFactor; // scale to fit height
        else
			scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
		
        // center the image
        if (widthFactor > heightFactor) {
			thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5; 
		} else if (widthFactor < heightFactor) {
			thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
		}
	}       
	
	UIGraphicsBeginImageContext(size); // this will crop
	
	CGRect thumbnailRect = CGRectZero;
	thumbnailRect.origin = thumbnailPoint;
	thumbnailRect.size.width  = scaledWidth;
	thumbnailRect.size.height = scaledHeight;
	
	[sourceImage drawInRect:thumbnailRect];
	
	newImage = UIGraphicsGetImageFromCurrentImageContext();
	if(newImage == nil) 
        NSLog(@"could not scale image");
	
	//pop the context to get back to the default
	UIGraphicsEndImageContext();
	return newImage;
}

// Resizes the image according to the given content mode, taking into account the image's orientation
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode imageToScale:(UIImage*)image bounds:(CGSize)bounds interpolationQuality:(CGInterpolationQuality)quality {
    //Get the size we want to scale it to
    CGFloat horizontalRatio = bounds.width / image.size.width;
    CGFloat verticalRatio = bounds.height / image.size.height;
    CGFloat ratio;
	
    switch (contentMode) {
        case UIViewContentModeScaleAspectFill:
            ratio = MAX(horizontalRatio, verticalRatio);
            break;
			
        case UIViewContentModeScaleAspectFit:
            ratio = MIN(horizontalRatio, verticalRatio);
            break;
			
        default:
            [NSException raise:NSInvalidArgumentException format:@"Unsupported content mode: %d", contentMode];
    }
	
    //...and here it is
    CGSize newSize = CGSizeMake(image.size.width * ratio, image.size.height * ratio);
	
	
    //start scaling it
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGImageRef imageRef = image.CGImage;
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                CGImageGetBitsPerComponent(imageRef),
                                                0,
                                                CGImageGetColorSpace(imageRef),
                                                CGImageGetBitmapInfo(imageRef));
	
    CGContextSetInterpolationQuality(bitmap, quality);
	
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, newRect, imageRef);
	
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
	
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
	
    return newImage;
}

-(UIImage*) scaleAndCropToSize:(CGSize)size
{
    float ratio = self.size.width / self.size.height;
	
    UIGraphicsBeginImageContext(size);
	
    if (ratio > 1) {
        CGFloat newWidth = ratio * size.width;
        CGFloat newHeight = size.height;
        CGFloat leftMargin = (newWidth - newHeight) / 2;
        [self drawInRect:CGRectMake(-leftMargin, 0, newWidth, newHeight)];
    }
    else {
        CGFloat newWidth = size.width;
        CGFloat newHeight = size.height / ratio;
        CGFloat topMargin = (newHeight - newWidth) / 2;
        [self drawInRect:CGRectMake(0, -topMargin, size.width, size.height/ratio)];
    }
	
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return newImage;
}

- (UIImage*)imageByCroppingImage:(UIImage *)image toRect:(CGRect)rect
{
	//create a context to do our clipping in
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef currentContext = UIGraphicsGetCurrentContext();
	
	//create a rect with the size we want to crop the image to
	//the X and Y here are zero so we start at the beginning of our
	//newly created context
	CGRect clippedRect = CGRectMake(0, 0, rect.size.width, rect.size.height);
	CGContextClipToRect( currentContext, clippedRect);
	
	//create a rect equivalent to the full size of the image
	//offset the rect by the X and Y we want to start the crop
	//from in order to cut off anything before them
	CGRect drawRect = CGRectMake(rect.origin.x * -1,
								 rect.origin.y * -1,
								 image.size.width,
								 image.size.height);
	
	//draw the image to our clipped context using our offset rect
	CGContextDrawImage(currentContext, drawRect, image.CGImage);
	
	//pull the image from our cropped context
	UIImage *cropped = UIGraphicsGetImageFromCurrentImageContext();
	
	//pop the context to get back to the default
	UIGraphicsEndImageContext();
	
	//Note: this is autoreleased
	return cropped;
}

UIImage* resizedImage(UIImage *image, CGRect rect)
{
	CGImageRef			imageRef = [image CGImage];
	CGImageAlphaInfo	alphaInfo = CGImageGetAlphaInfo(imageRef);
	
	// There's a wierdness with kCGImageAlphaNone and CGBitmapContextCreate
	// see Supported Pixel Formats in the Quartz 2D Programming Guide
	// Creating a Bitmap Graphics Context section
	// only RGB 8 bit images with alpha of kCGImageAlphaNoneSkipFirst, kCGImageAlphaNoneSkipLast, kCGImageAlphaPremultipliedFirst,
	// and kCGImageAlphaPremultipliedLast, with a few other oddball image kinds are supported
	// The images on input here are likely to be png or jpeg files
	if (alphaInfo == kCGImageAlphaNone)
		alphaInfo = kCGImageAlphaNoneSkipLast;
	
	// Build a bitmap context that's the size of the thumbRect
	CGContextRef bitmap = CGBitmapContextCreate(
												NULL,
												rect.size.width,		// width
												rect.size.height,		// height
												CGImageGetBitsPerComponent(imageRef),	// really needs to always be 8
												4 * rect.size.width,	// rowbytes
												CGImageGetColorSpace(imageRef),
												alphaInfo
												);
	
	// Draw into the context, this scales the image
	CGContextDrawImage(bitmap, rect, imageRef);
	
	// Get an image from the context and a UIImage
	CGImageRef	ref = CGBitmapContextCreateImage(bitmap);
	UIImage*	result = [UIImage imageWithCGImage:ref];
	
	CGContextRelease(bitmap);	// ok if NULL
	CGImageRelease(ref);
	
	return result;
}

- (UIImage*)resizedImage:(UIImage*)image inRect:(CGRect)rect {
	// Creates a bitmap-based graphics context and makes it the current context.
	UIGraphicsBeginImageContext(rect.size);
	[image drawInRect:rect];
	
	return UIGraphicsGetImageFromCurrentImageContext();
}

- (UIImage*)resizeImage:(UIImage*)image inRect:(CGRect)rect { 
	
	CGImageRef			imageRef = [image CGImage];
	CGImageAlphaInfo	alphaInfo = CGImageGetAlphaInfo(imageRef);
	
	// There's a wierdness with kCGImageAlphaNone and CGBitmapContextCreate
	// see Supported Pixel Formats in the Quartz 2D Programming Guide
	// Creating a Bitmap Graphics Context section
	// only RGB 8 bit images with alpha of kCGImageAlphaNoneSkipFirst, kCGImageAlphaNoneSkipLast, kCGImageAlphaPremultipliedFirst,
	// and kCGImageAlphaPremultipliedLast, with a few other oddball image kinds are supported
	// The images on input here are likely to be png or jpeg files
	if (alphaInfo == kCGImageAlphaNone)
		alphaInfo = kCGImageAlphaNoneSkipLast;
	
	// Build a bitmap context that's the size of the thumbRect
	CGFloat bytesPerRow;
	
	if( rect.size.width > rect.size.height ) {
		bytesPerRow = 4 * rect.size.width;
	} else {
		bytesPerRow = 4 * rect.size.height;
	}
	
	CGContextRef bitmap = CGBitmapContextCreate(	
												NULL,
												rect.size.width,		// width
												rect.size.height,		// height
												8, //CGImageGetBitsPerComponent(imageRef),	// really needs to always be 8
												bytesPerRow, //4 * thumbRect.size.width,	// rowbytes
												CGImageGetColorSpace(imageRef),
												alphaInfo
												);
	
	// Draw into the context, this scales the image
	CGContextDrawImage(bitmap, rect, imageRef);
	
	// Get an image from the context and a UIImage
	CGImageRef	ref = CGBitmapContextCreateImage(bitmap);
	UIImage*	result = [UIImage imageWithCGImage:ref];
	
	CGContextRelease(bitmap);	// ok if NULL
	CGImageRelease(ref);
	
	return result;
}

- (void)scaleAndRotateImage:(UIImage *)image
{
	int kMaxResolution = 320; // Or whatever
	
	CGImageRef imgRef = image.CGImage;
	
	CGFloat width = CGImageGetWidth(imgRef);
	CGFloat height = CGImageGetHeight(imgRef);
	
	CGAffineTransform transform = CGAffineTransformIdentity;
	CGRect bounds = CGRectMake(0, 0, width, height);
	if (width > kMaxResolution || height > kMaxResolution) {
		CGFloat ratio = width/height;
		if (ratio > 1) {
			bounds.size.width = kMaxResolution;
			bounds.size.height = bounds.size.width / ratio;
		}
		else {
			bounds.size.height = kMaxResolution;
			bounds.size.width = bounds.size.height * ratio;
		}
	}
	
	CGFloat scaleRatio = bounds.size.width / width;
	CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
	CGFloat boundHeight;
	UIImageOrientation orient = image.imageOrientation;
	switch(orient) {
			
		case UIImageOrientationUp: //EXIF = 1
			transform = CGAffineTransformIdentity;
			break;
			
		case UIImageOrientationUpMirrored: //EXIF = 2
			transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			break;
			
		case UIImageOrientationDown: //EXIF = 3
			transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
			transform = CGAffineTransformRotate(transform, M_PI);
			break;
			
		case UIImageOrientationDownMirrored: //EXIF = 4
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
			transform = CGAffineTransformScale(transform, 1.0, -1.0);
			break;
			
		case UIImageOrientationLeftMirrored: //EXIF = 5
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
			
		case UIImageOrientationLeft: //EXIF = 6
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
			
		case UIImageOrientationRightMirrored: //EXIF = 7
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeScale(-1.0, 1.0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
			
		case UIImageOrientationRight: //EXIF = 8
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
			
		default:
			[NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
			
	}
	
	UIGraphicsBeginImageContext(bounds.size);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
		CGContextScaleCTM(context, -scaleRatio, scaleRatio);
		CGContextTranslateCTM(context, -height, 0);
	}
	else {
		CGContextScaleCTM(context, scaleRatio, -scaleRatio);
		CGContextTranslateCTM(context, 0, -height);
	}
	
	CGContextConcatCTM(context, transform);
	
	CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
	//UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	//[self setRotatedImage:imageCopy];
	//return imageCopy;
}

UIImage *scaleAndRotateImage(UIImage *image)
{
	int kMaxResolution = 320; // Or whatever
	
	CGImageRef imgRef = image.CGImage;
	
	CGFloat width = CGImageGetWidth(imgRef);
	CGFloat height = CGImageGetHeight(imgRef);
	
	CGAffineTransform transform = CGAffineTransformIdentity;
	CGRect bounds = CGRectMake(0, 0, width, height);
	if (width > kMaxResolution || height > kMaxResolution) {
		CGFloat ratio = width/height;
		if (ratio > 1) {
			bounds.size.width = kMaxResolution;
			bounds.size.height = bounds.size.width / ratio;
		} else {
			bounds.size.height = kMaxResolution;
			bounds.size.width = bounds.size.height * ratio;
		}
	}	
	CGFloat scaleRatio = bounds.size.width / width;
	CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
	CGFloat boundHeight;
	UIImageOrientation orient = image.imageOrientation;
	switch(orient) {
	
		case UIImageOrientationUp: //EXIF = 1
			transform = CGAffineTransformIdentity;
			break;
		
		case UIImageOrientationUpMirrored: //EXIF = 2
			transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			break;
		
		case UIImageOrientationDown: //EXIF = 3
			transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
			transform = CGAffineTransformRotate(transform, M_PI);
			break;
		
		case UIImageOrientationDownMirrored: //EXIF = 4
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
			transform = CGAffineTransformScale(transform, 1.0, -1.0);
			break;
		
		case UIImageOrientationLeftMirrored: //EXIF = 5
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
		
		case UIImageOrientationLeft: //EXIF = 6
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
		
		case UIImageOrientationRightMirrored: //EXIF = 7
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeScale(-1.0, 1.0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
		
		case UIImageOrientationRight: //EXIF = 8
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
		
		default:
			[NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
		
	}
	
	UIGraphicsBeginImageContext(bounds.size);

	CGContextRef context = UIGraphicsGetCurrentContext();
	if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
		CGContextScaleCTM(context, -scaleRatio, scaleRatio);
		CGContextTranslateCTM(context, -height, 0);
	} else {
		CGContextScaleCTM(context, scaleRatio, -scaleRatio);
		CGContextTranslateCTM(context, 0, -height);
	}
	CGContextConcatCTM(context, transform);
	CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
	UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	return imageCopy;
}

// Returns a rescaled copy of the image; its imageOrientation will be UIImageOrientationUp
// If the new size is not integral, it will be rounded up
- (UIImage *)makeResizedImage:(CGSize)size quality:(CGInterpolationQuality)interpolationQuality {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, size.width, size.height));
    CGImageRef imageRef = self.CGImage;
	
    // Compute the bytes per row of the new image
    size_t bytesPerRow = CGImageGetBitsPerPixel(imageRef) / CGImageGetBitsPerComponent(imageRef) * newRect.size.width;
    bytesPerRow = (bytesPerRow + 15) & ~15;  // Make it 16-byte aligned
    
    // Build a bitmap context that's the same dimensions as the new size
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                CGImageGetBitsPerComponent(imageRef),
                                                bytesPerRow,
                                                CGImageGetColorSpace(imageRef),
                                                CGImageGetBitmapInfo(imageRef));
    
    CGContextSetInterpolationQuality(bitmap, interpolationQuality);
	
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef resizedImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *resizedImage = [UIImage imageWithCGImage:resizedImageRef];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(resizedImageRef);
    
    return resizedImage;
}

@end
