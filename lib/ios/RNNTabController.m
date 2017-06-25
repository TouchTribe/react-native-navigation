//
//  RNNTabController.m
//  ReactNativeNavigation
//
//  Created by Guido van Loon on 24/06/2017.
//  Copyright © 2017 Wix. All rights reserved.
//

#import "RNNTabController.h"
#import "TabSwitchAnimationController.h"

@implementation RNNTabController

- (instancetype)init {
	self = [super init];
	if (self) {
		self.delegate = self;
	}
	return self;
}

- (id <UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController
			animationControllerForTransitionFromViewController:(UIViewController *)fromVC
											  toViewController:(UIViewController *)toVC
{
	return [[TabSwitchAnimationController alloc] init];
}


@end
