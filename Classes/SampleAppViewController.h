//
//  SampleAppViewController.h
//  SampleApp
//
//  Created by Chris Purcell on 2/14/10.
//  Copyright  2010. All rights reserved.
//
//  Updated by Daniel Munoz on 09/26/13

#import <UIKit/UIKit.h>
#import "CPLockController.h"

@interface SampleAppViewController : UIViewController <CPLockControllerDelegate> {

}

- (IBAction)requirePasscode:(id)sender;
- (IBAction)changePasscode:(id)sender;

@end

