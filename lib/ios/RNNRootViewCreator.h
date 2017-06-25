
#import <UIKit/UIKit.h>
#import "RNNCreateInfo.h"

@protocol RNNRootViewCreator

-(UIView*)createRootView:(NSString*)name rootViewId:(NSString*)rootViewId createInfo:(RNNCreateInfo *)info;

@end

