
#import "RNNCommandsHandler.h"

#import "RNNModalManager.h"
#import "RNNNavigationStackManager.h"
#import "RNNCreateInfo.h"

@implementation RNNCommandsHandler {
	RNNControllerFactory *_controllerFactory;
	RNNStore *_store;
	RNNNavigationStackManager* _navigationStackManager;
	RNNModalManager* _modalManager;
}

-(instancetype) initWithStore:(RNNStore*)store controllerFactory:(RNNControllerFactory*)controllerFactory {
	self = [super init];
	_store = store;
	_controllerFactory = controllerFactory;
	_navigationStackManager = [[RNNNavigationStackManager alloc] initWithStore:_store];
	_modalManager = [[RNNModalManager alloc] initWithStore:_store];
	return self;
}

#pragma mark - public

-(void) setRoot:(NSDictionary*)layout {
	[self assertReady];

	[_modalManager dismissAllModals];
	
	UIWindow *window = UIApplication.sharedApplication.delegate.window;
	
	RNNCreateInfo *info = [RNNCreateInfo new];
	info.isRoot = YES;
	
	UIViewController *toVC = [_controllerFactory createLayoutAndSaveToStore:layout withInfo:info];
	UIViewController *fromVC = window.rootViewController;
	
	if (fromVC) {
		UIView* toView = toVC.view;
		UIView* fromView = fromVC.view;
		toView.frame = window.bounds;
		[window addSubview:toView];
		
		CATransition* transition = [CATransition animation];
		transition.startProgress = 0;
		transition.endProgress = 1.0;
		transition.type = kCATransitionPush;
		transition.subtype = kCATransitionFromRight;
		transition.duration = 0.3;
		
		// Add the transition animation to both layers
		[fromView.layer addAnimation:transition forKey:@"transition"];
		[toView.layer addAnimation:transition forKey:@"transition"];
	}
	window.rootViewController = toVC;
}

-(void) push:(NSString*)containerId layout:(NSDictionary*)layout {
	[self assertReady];
	RNNCreateInfo *info = [RNNCreateInfo new];
	info.isRoot = NO;
	UIViewController *newVc = [_controllerFactory createLayoutAndSaveToStore:layout withInfo:info];
	[_navigationStackManager push:newVc onTop:containerId];
}

-(void) pop:(NSString*)containerId {
	[self assertReady];
	[_navigationStackManager pop:containerId];
}

-(void) popTo:(NSString*)containerId {
	[self assertReady];
	[_navigationStackManager popTo:containerId];
}

-(void) popToRoot:(NSString*)containerId {
	[self assertReady];
	[_navigationStackManager popToRoot:containerId];
}

-(void) showModal:(NSDictionary*)layout {
	[self assertReady];
	RNNCreateInfo *info = [RNNCreateInfo new];
	info.isRoot = YES;
	UIViewController *newVc = [_controllerFactory createLayoutAndSaveToStore:layout withInfo:info];
	[_modalManager showModal:newVc];
}

-(void) dismissModal:(NSString*)containerId {
	[self assertReady];
	[_modalManager dismissModal:containerId];
}

-(void) dismissAllModals {
	[self assertReady];
	[_modalManager dismissAllModals];
}

-(void) setupHeader:(NSString*)containerId withConfig:(NSDictionary *)config {
	[_navigationStackManager setupHeader:config forContainer:containerId];
}

#pragma mark - private

-(void) assertReady {
	if (!_store.isReadyToReceiveCommands) {
		@throw [NSException exceptionWithName:@"BridgeNotLoadedError" reason:@"Bridge not yet loaded! Send commands after Navigation.events().onAppLaunched() has been called." userInfo:nil];
	}
}

@end
