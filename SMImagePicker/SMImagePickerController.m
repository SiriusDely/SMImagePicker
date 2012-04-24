//
//  SMImagePickerController.m
//  SMImagePicker
//
//  Created by Sirius Dely on 4/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SMImagePickerController.h"

// Transform values for full screen support:
#define CAMERA_TRANSFORM_X 1
#define CAMERA_TRANSFORM_Y 1.12412 // this was for iOS 3.x
//#define CAMERA_TRANSFORM_Y 1.24299 // this works for iOS 4.x

// iPhone screen dimensions:
#define SCREEN_WIDTH  320
#define SCREEN_HEIGTH 480

@implementation SMImagePickerController


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		
    }
    return self;
}
*/

- (id)init {
    if (self = [super init]) {
		self.sourceType = UIImagePickerControllerSourceTypeCamera;
		//self.navigationBarHidden = YES;
		//self.wantsFullScreenLayout = YES;
		self.showsCameraControls = NO;
		self.cameraViewTransform = CGAffineTransformScale(self.cameraViewTransform, CAMERA_TRANSFORM_X, CAMERA_TRANSFORM_Y);
		SMOverlayView *overlayView = [[SMOverlayView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGTH)];
		overlayView.delegate = self;
		self.cameraOverlayView = overlayView;
		[overlayView release];
	}
	return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void) cameraTappedOnOverlayView:(SMOverlayView *)overlayView {
	[self takePicture];
}

- (void) cancelTappedOnOverlayView:(SMOverlayView *)overlayView {
	[self.delegate imagePickerControllerDidCancel:self];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
