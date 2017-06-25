
#import "RNNControllerFactory.h"
#import "RNNLayoutNode.h"
#import "RNNRootViewController.h"
#import "RNNSideMenuController.h"
#import "RNNSideMenuChildVC.h"
#import "RNNTabController.h"
#import "RNNNavigationController.h"


@implementation RNNControllerFactory {
	id<RNNRootViewCreator> _creator;
	RNNStore *_store;
	RNNEventEmitter *_eventEmitter;
}

# pragma mark public


- (instancetype)initWithRootViewCreator:(id <RNNRootViewCreator>)creator
								  store:(RNNStore *)store
						   eventEmitter:(RNNEventEmitter*)eventEmitter {
	
	self = [super init];
	_creator = creator;
	_store = store;
	_eventEmitter = eventEmitter;
	
	return self;
}

- (UIViewController*)createLayoutAndSaveToStore:(NSDictionary*)layout withInfo:(RNNCreateInfo *)info {
	return [self fromTree:layout info:info];
}

# pragma mark private

- (UIViewController*)fromTree:(NSDictionary*)json info:(RNNCreateInfo *)info {
	RNNLayoutNode* node = [RNNLayoutNode create:json];
	
	UIViewController* result;
	
	if ( node.isContainer) {
		result = [self createContainer:node info:info];
	}
	
	else if (node.isContainerStack)	{
		result = [self createContainerStack:node info:info];
	}
	
	else if (node.isTabs) {
		result = [self createTabs:node info:info];
	}
	
	else if (node.isSideMenuRoot) {
		result = [self createSideMenu:node info:info];
	}
	
	else if (node.isSideMenuCenter) {
		result = [self createSideMenuChild:node type:RNNSideMenuChildTypeCenter];
	}
	
	else if (node.isSideMenuLeft) {
		result = [self createSideMenuChild:node type:RNNSideMenuChildTypeLeft];
	}
	else if (node.isSideMenuRight) {
		result = [self createSideMenuChild:node type:RNNSideMenuChildTypeRight];
	}
	
	if (!result) {
		@throw [NSException exceptionWithName:@"UnknownControllerType" reason:[@"Unknown controller type " stringByAppendingString:node.type] userInfo:nil];
	}

	[_store setContainer:result containerId:node.nodeId];
	
	return result;
}

- (RNNRootViewController*)createContainer:(RNNLayoutNode*)node info:(RNNCreateInfo *)info {
	return [[RNNRootViewController alloc] initWithNode:node createInfo:info rootViewCreator:_creator eventEmitter:_eventEmitter];
}

- (UINavigationController*)createContainerStack:(RNNLayoutNode*)node info:(RNNCreateInfo *)info {
	UINavigationController* vc = [[RNNNavigationController alloc] init];
	[vc.navigationBar setBackgroundImage:[UIImage new]
												  forBarMetrics:UIBarMetricsDefault];
	vc.navigationBar.shadowImage = [UIImage new];
	vc.navigationBar.translucent = YES;
	vc.view.backgroundColor = [UIColor clearColor];
	vc.navigationBar.backgroundColor = [UIColor clearColor];
	
	NSMutableArray* controllers = [NSMutableArray new];
	int i=0;
	for (NSDictionary* child in node.children) {
		RNNCreateInfo *info = [RNNCreateInfo new];
		info.isRoot = i==0;
		[controllers addObject:[self fromTree:child info:info]];
		i++;
	}
	[vc setViewControllers:controllers];
	
	return vc;
}

-(UITabBarController*)createTabs:(RNNLayoutNode*)node info:(RNNCreateInfo *)info {
	UITabBarController* vc = [[RNNTabController alloc] init];
	
	NSMutableArray* controllers = [NSMutableArray new];
	int i=0;
	for (NSDictionary *child in node.children) {
		RNNCreateInfo *info = [RNNCreateInfo new];
		info.isRoot = YES;
		UIViewController* childVc = [self fromTree:child info:info];
		NSString *title = @"";
		UIImage *image = nil;
		UIImage *selectedImage = nil;
		NSArray *children = child[@"children"];
		if (children && children.count) {
			id data = children[0][@"data"];
			if (data) {
				if (data[@"title"]) {
					title = data[@"title"];
				}
				if (data[@"iconNormal"]) {
					image = [UIImage imageNamed:data[@"iconNormal"]];
				}
				if (data[@"iconActive"]) {
					selectedImage = [UIImage imageNamed:data[@"iconActive"]];
				}
			}
		}
		UITabBarItem* item = [[UITabBarItem alloc] initWithTitle:title image:image selectedImage:selectedImage];
		item.tag = i++;
		[childVc setTabBarItem:item];
		[controllers addObject:childVc];
	}
//	[[UITabBar appearance] setTintColor:[TAStyleKit tintColor]];
	vc.tabBar.tintColor = [UIColor colorWithRed:95/255.f green:95/255.f blue:95/255.f alpha:1.f];
	[vc setViewControllers:controllers];
	
	return vc;
}

- (UIViewController*)createSideMenu:(RNNLayoutNode*)node info:(RNNCreateInfo *)info {
	NSMutableArray* childrenVCs = [NSMutableArray new];
	
	for (NSDictionary *child in node.children) {
		RNNCreateInfo *info = [RNNCreateInfo new];
		info.isRoot = YES;
		UIViewController *vc = [self fromTree:child info:info];
		[childrenVCs addObject:vc];
	}
	
	RNNSideMenuController *sideMenu = [[RNNSideMenuController alloc] initWithControllers:childrenVCs];
	return sideMenu;
}


- (UIViewController*)createSideMenuChild:(RNNLayoutNode*)node type:(RNNSideMenuChildType)type {
	RNNCreateInfo *info = [RNNCreateInfo new];
	info.isRoot = YES;
	UIViewController* child = [self fromTree:node.children[0] info:info];
	RNNSideMenuChildVC *sideMenuChild = [[RNNSideMenuChildVC alloc] initWithChild: child type:type];
	
	return sideMenuChild;
}



@end
