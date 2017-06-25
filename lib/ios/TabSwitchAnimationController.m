//
//  TabSwitchAnimationController.m
//  ReactNativeNavigation
//
//  Created by Guido van Loon on 24/06/2017.
//  Copyright © 2017 Wix. All rights reserved.
//

#import "TabSwitchAnimationController.h"

@implementation TabSwitchAnimationController

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
	return 0.3;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
	UIViewController* fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
	UIViewController* toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
	UIView* toView = toVC.view;
	UIView* fromView = fromVC.view;
	
	UIView* containerView = [transitionContext containerView];
	[containerView addSubview:toView];
	CGRect targetToFrame = [transitionContext finalFrameForViewController:toVC];

	float offset;
	if (toVC.tabBarItem.tag > fromVC.tabBarItem.tag) {
		offset = targetToFrame.size.width;
	} else {
		offset = -targetToFrame.size.width;
	}
	toView.frame = CGRectMake(targetToFrame.origin.x + offset, targetToFrame.origin.y, targetToFrame.size.width, targetToFrame.size.height);
	CGRect targetFromFrame = CGRectMake(fromView.frame.origin.x - offset, fromView.frame.origin.y, fromView.frame.size.width, fromView.frame.size.height);
	[UIView animateWithDuration:[self transitionDuration:transitionContext]
						  delay:0.0
						options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction
					 animations:^{
						 toView.frame = targetToFrame;
						 fromView.frame = targetFromFrame;
					 }
					 completion:^(BOOL finished) {
						 toView.frame = targetToFrame;
						 fromView.frame = targetFromFrame;
						 [fromView removeFromSuperview];
						 [transitionContext completeTransition:YES];
					 }];
}

@end
