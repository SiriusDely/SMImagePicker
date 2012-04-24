
#import <UIKit/UIKit.h>

@class SMOverlayView;

@protocol SMOverlayViewDelegate <NSObject>
@optional
- (void)cameraTappedOnOverlayView:(SMOverlayView*)overlayView;
- (void)cancelTappedOnOverlayView:(SMOverlayView*)overlayView;
@end


@interface SMOverlayView : UIView {
	id <SMOverlayViewDelegate> _delegate;
}

@property (nonatomic, assign) id <SMOverlayViewDelegate> delegate;

@end
