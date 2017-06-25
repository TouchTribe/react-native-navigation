//
//  RNNNavigationController.m
//  ReactNativeNavigation
//
//  Created by Guido van Loon on 24/06/2017.
//  Copyright © 2017 Wix. All rights reserved.
//

#import "RNNNavigationController.h"

@interface RNNNavigationController ()

@end

@implementation RNNNavigationController

- (instancetype)init {
	self = [super init];
	if (self) {
		self.navigationBar.hidden = YES;
	}
	return self;
}

@end
