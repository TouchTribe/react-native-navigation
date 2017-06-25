
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RNNLayoutNode.h"
#import "RNNRootViewCreator.h"
#import "RNNEventEmitter.h"
#import "RNNCreateInfo.h"

@interface RNNRootViewController : UIViewController

-(instancetype)initWithNode:(RNNLayoutNode*)node
				 createInfo:(RNNCreateInfo*)info
			rootViewCreator:(id<RNNRootViewCreator>)creator
			   eventEmitter:(RNNEventEmitter*)eventEmitter;

@end
