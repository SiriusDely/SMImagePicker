//
//  SMIMagePickerController.h
//  SMImagePicker
//
//  Created by Sirius Dely on 4/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMOverlayView.h"

@protocol SMImagePickerControllerDelegate <UIImagePickerControllerDelegate>

@end

@interface SMImagePickerController : UIImagePickerController <SMOverlayViewDelegate> {

}

@end
