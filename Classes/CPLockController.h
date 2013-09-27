//
//  CPPassCodeView.h
//  SampleApp
//
//  Created by Chris Purcell on 2/14/10.
//  Copyright 2010 . All rights reserved.
//

#import <UIKit/UIKit.h>

#define IS_IPAD ([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)] && [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

typedef enum {
    CPLockControllerTypeAuth,
    CPLockControllerTypeForceAuth,
    CPLockControllerTypeSet,
    CPLockControllerTypeForceSet
} CPLockControllerStyle;

@class CPLockController;

@protocol CPLockControllerDelegate

@required
- (void)lockController:(CPLockController *)lockController didFinish:(NSString*)passcode;
- (void)lockControllerDidCancel:(CPLockController *)lockController;

@optional
- (BOOL)lockController:(CPLockController *)lockController shouldAcceptPasscode:(NSString *)passcode;

@end


@interface CPLockController : UIViewController <UITextFieldDelegate> {
	//Public vars
	CPLockControllerStyle style;
	NSString *passcode;
	NSString *prompt;
	NSString *title;
	id <CPLockControllerDelegate, NSObject> delegate;
	BOOL hideCode;
	//Private vars
	BOOL retry;
	NSMutableString *tempString;
	//UI Elements
	UITextField *hiddenField;
	UINavigationItem *navigationItem;
	UILabel *promptLabel;
	UILabel *subPromptLabel;
	UITextField *field1;
	UITextField *field2;
	UITextField *field3;
	UITextField *field4;
}

@property (nonatomic, assign) id <CPLockControllerDelegate, NSObject> delegate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic) CPLockControllerStyle style;
@property (nonatomic, retain) NSString *passcode;
@property (nonatomic, retain) NSString *prompt;
@property (nonatomic) BOOL hideCode;

- (void)setTitle:(NSString *)title;
- (id)initWithStyle:(CPLockControllerStyle)theStyle;

@end
