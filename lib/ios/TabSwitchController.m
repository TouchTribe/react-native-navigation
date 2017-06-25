//
//  TabSwitchController.m
//  ReactNativeNavigation
//
//  Created by Guido van Loon on 24/06/2017.
//  Copyright © 2017 Wix. All rights reserved.
//

#import "TabSwitchController.h"

@interface TabSwitchController ()

@end

@implementation TabSwitchController

- (id <UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController
			animationControllerForTransitionFromViewController:(UIViewController *)fromVC
											  toViewController:(UIViewController *)toVC
{
	return [[TabSwitchAnimationController alloc] init];
}

@end
