//
//  SampleAppAppDelegate.h
//  SampleApp
//
//  Created by Chris Purcell on 2/14/10.
//  Copyright  2010. All rights reserved.
//
//  Updated by Daniel Munoz on 09/26/13

#import <UIKit/UIKit.h>

@class SampleAppViewController;

@interface SampleAppAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    SampleAppViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SampleAppViewController *viewController;


@end

