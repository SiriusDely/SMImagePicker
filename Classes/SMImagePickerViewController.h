//
//  SMImagePickerViewController.h
//  SMImagePicker
//
//  Created by Sirius Dely on 4/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMImagePickerController.h"

@interface SMImagePickerViewController : UIViewController <UINavigationControllerDelegate, SMImagePickerControllerDelegate> {
	SMImagePickerController *	_imagePickerController;
	UIImageView *	_imageView;
}

@property (nonatomic, retain) IBOutlet UIImageView *	imageView;

- (IBAction)show;

@end

