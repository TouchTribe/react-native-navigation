#import "RNNNavigationStackManager.h"

@implementation RNNNavigationStackManager {
	RNNStore *_store;
}

-(instancetype)initWithStore:(RNNStore*)store {
	self = [super init];
	_store = store;
	return self;
}

-(void)push:(UIViewController *)newTop onTop:(NSString *)containerId {
	UIViewController *vc = [_store findContainerForId:containerId];
	[[vc navigationController] pushViewController:newTop animated:YES];
}

-(void)pop:(NSString *)containerId {
	UIViewController* vc = [_store findContainerForId:containerId];
	UINavigationController* nvc = [vc navigationController];
	if ([nvc topViewController] == vc) {
		[nvc popViewControllerAnimated:YES];
	} else {
		NSMutableArray * vcs = nvc.viewControllers.mutableCopy;
		[vcs removeObject:vc];
		[nvc setViewControllers:vcs animated:YES];
	}
	[_store removeContainer:containerId];
}

-(void)popTo:(NSString*)containerId {
	UIViewController *vc = [_store findContainerForId:containerId];
	
	if (vc) {
		UINavigationController *nvc = [vc navigationController];
		if(nvc) {
			NSArray *poppedVCs = [nvc popToViewController:vc animated:YES];
			[self removePopedViewControllers:poppedVCs];
		}
	}
}

-(void) popToRoot:(NSString*)containerId {
	UIViewController* vc = [_store findContainerForId:containerId];
	UINavigationController* nvc = [vc navigationController];
	NSArray* poppedVCs = [nvc popToRootViewControllerAnimated:YES];
	[self removePopedViewControllers:poppedVCs];
}

-(void)setupHeader:(NSDictionary *)config forContainer:containerId {
	UIViewController* vc = [_store findContainerForId:containerId];
	if (vc) {
		NSString *title = config[@"title"];
		NSString *theme = config[@"theme"];
		vc.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:nil action:nil];
		if ([theme isEqualToString:@"dark"]) {
			vc.navigationController.navigationBar.tintColor = [UIColor blackColor];
		} else {
			vc.navigationController.navigationBar.tintColor = [UIColor whiteColor];
		}
	}
}

-(void)removePopedViewControllers:(NSArray*)viewControllers {
	for (UIViewController *popedVC in viewControllers) {
		[_store removeContainerByViewControllerInstance:popedVC];
	}
}

@end
