//
//  SMImagePickerViewController.m
//  SMImagePicker
//
//  Created by Sirius Dely on 4/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SMImagePickerViewController.h"
#import "UIImage+Extras.h"
//#import "UIImage+Resize.h"

@implementation SMImagePickerViewController

@synthesize imageView = _imageView;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)show {
	if (!_imagePickerController) {
		_imagePickerController = [[SMImagePickerController alloc] init];
		_imagePickerController.delegate = self;
	}
	[self presentModalViewController:_imagePickerController animated:YES];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
	[self dismissModalViewControllerAnimated:YES];
	//UIImage *img = [UIImage crop:image rect:CGRectMake(0, 0, 1000, 1000)];
	//UIImage *img = [image imageByScalingAndCroppingForSize:CGSizeMake(320, 320)];
	//UIImage *img = [UIImage imageWithImage:image scaledToSize:CGSizeMake(320, 320)];
	//UIImage *img = [UIImage scaleImage:image toSize:CGSizeMake(320, 320)];
	//UIImage *img = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill imageToScale:image bounds:CGSizeMake(320, 320) interpolationQuality:kCGInterpolationDefault];
	//UIImage *img = [image imageByCropping:image toRect:CGRectMake(0, 0, 320, 320)];

	//UIImage *img = [image imageByCroppingImage:image toRect:CGRectMake(0, 0, 1162, 1162)];
	//UIImage *img = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:image.size interpolationQuality:kCGInterpolationHigh];
	//img = [img croppedImage:CGRectMake((image.size.width-1162)/2, (image.size.height-1162)/2, 1162, 1162)];
	//UIImage *img = [image resizedImage:CGSizeMake(1162, 1162) interpolationQuality:kCGInterpolationHigh];
	UIImage *img = [image scaleAndCropToSize:CGSizeMake(image.size.width, image.size.width)];
	[_imageView setImage:img];
	//UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:finishedSavingWithError:contextInfo:), nil);
}

-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Save failed" message: [error localizedDescription] delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
	[_imageView release];
	if (!_imagePickerController) {
		_imagePickerController.delegate = nil;
		[_imagePickerController release];
	}
    [super dealloc];
}

@end
