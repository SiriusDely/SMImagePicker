//
//  SMImagePickerAppDelegate.h
//  SMImagePicker
//
//  Created by Sirius Dely on 4/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMImagePickerViewController;

@interface SMImagePickerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    SMImagePickerViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SMImagePickerViewController *viewController;

@end

