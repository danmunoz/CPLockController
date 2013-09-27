//
//  SampleAppViewController.m
//  SampleApp
//
//  Created by Chris Purcell on 2/14/10.
//  Copyright  2010. All rights reserved.
//

#import "SampleAppViewController.h"


@implementation SampleAppViewController


- (IBAction)changePasscode:(id)sender {
	CPLockController *lockController = [[CPLockController alloc]initWithStyle:CPLockControllerTypeSet];
	
	lockController.delegate = self;
	lockController.modalPresentationStyle = UIModalPresentationFormSheet;
	[self presentModalViewController:lockController animated:YES];
}

- (IBAction)requirePasscode:(id)sender {
	CPLockController *lockController = [[CPLockController alloc]initWithStyle:CPLockControllerTypeAuth];
	lockController.passcode = @"1234";
	lockController.delegate = self;
	lockController.title = @"Passcode is 1234";
	lockController.modalPresentationStyle = UIModalPresentationFormSheet;
	[self presentModalViewController:lockController animated:YES];
}

#pragma mark CPLockControllerDelegate Methods

- (void)lockController:(CPLockController *)lockController didFinish:(NSString*)passcode {
	if(passcode){
		NSLog(@"new passcode: %@",passcode);
	} else {
		NSLog(@"passcode accepted!");
	}
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)lockControllerDidCancel:(CPLockController *)lockController {
	NSLog(@"user cancelled auth");
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark Mememory Management

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


- (void)dealloc {
    [super dealloc];
}

@end
