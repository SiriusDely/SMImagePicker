
#import "SMOverlayView.h"

@interface SMOverlayView()
- (void)camera;
- (void)cancel;
@end

@implementation SMOverlayView

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		// Clear the background of the overlay:
		self.opaque = NO;
		self.backgroundColor = [UIColor clearColor];
		
		// Load the image to show in the overlay:
		UIImage *overlayImage = [UIImage imageNamed:@"overlay.png"];
		UIImageView *overlayImageView = [[UIImageView alloc] initWithImage:overlayImage];
		overlayImageView.frame = CGRectMake(0, 0, 320, 480);
		[self addSubview:overlayImageView];
		[overlayImageView release];
		
		UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
		cameraButton.frame = CGRectMake(130, 445, 0, 0);
		[cameraButton setImage:[UIImage imageNamed:@"camera-normal.png"] forState:UIControlStateNormal];
		[cameraButton setImage:[UIImage imageNamed:@"camera-press.png"] forState:UIControlStateHighlighted];
		[cameraButton sizeToFit];
		[cameraButton addTarget:self action:@selector(camera) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:cameraButton];
		UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
		cancelButton.frame = CGRectMake(6, 5, 0, 0);
		[cancelButton setImage:[UIImage imageNamed:@"cancel-normal.png"] forState:UIControlStateNormal];
		[cancelButton setImage:[UIImage imageNamed:@"cancel-press.png"] forState:UIControlStateHighlighted];
		[cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
		[cancelButton sizeToFit];
		[self addSubview:cancelButton];
    }
    return self;
}

- (void)camera {
	if ([_delegate respondsToSelector:@selector(cameraTappedOnOverlayView:)]) {
		[_delegate cameraTappedOnOverlayView:self];
	}
}

- (void)cancel {
	if ([_delegate respondsToSelector:@selector(cancelTappedOnOverlayView:)]) {
		[_delegate cancelTappedOnOverlayView:self];
	}
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (void)dealloc {
    [super dealloc];
}


@end
