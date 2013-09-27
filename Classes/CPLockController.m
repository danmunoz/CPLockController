//
//  CPPassCodeView.m
//  SampleApp
//
//  Created by Chris Purcell on 2/14/10.
//  Copyright 2010 . All rights reserved.
//
//  Updated by Daniel Munoz on 09/26/13

#import "CPLockController.h"

#define kCPLCDefaultSetPrompt			@"Enter your new passcode"
#define kCPLCDefaultAuthPrompt			@"Enter your passcode"
#define kCPLCDefaultSetTitle			@"Set Passcode"
#define kCPLCDefaultConfirmTitle		@"Confirm Passcode"
#define kCPLCDefaultAuthTitle			@"Enter Passcode"
#define kCPLCDefaultSetError			@"Passcodes did not match. Try again."
#define kCPLCDefaultAuthError			@"Passcode incorrect. Try again."

//private methods
@interface CPLockController()

- (void)setupSubviews;
- (void)setupNavigationBar;
- (void)setupTextFields;
- (void)resetFields;
- (void)passcodeDidNotMatch;

@property (nonatomic, retain) NSMutableString *tempString;
@property (nonatomic) BOOL retry;
@property (nonatomic, retain) UILabel *promptLabel;
@property (nonatomic, retain) UILabel *subPromptLabel;
@property (nonatomic, retain) UITextField *hiddenField;
@property (nonatomic, retain) UINavigationItem *navigationItem;

@end

@implementation CPLockController
@synthesize delegate,style,passcode,prompt,hiddenField,navigationItem,promptLabel,subPromptLabel,tempString,retry,title,hideCode;

- (id)initWithStyle:(CPLockControllerStyle)theStyle {
	if(self = [super init]){
		self.style = theStyle;
		self.retry = NO;
		self.tempString = [NSMutableString string];
		self.hideCode = YES;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardDidHide) name:UIKeyboardWillHideNotification object:nil];
	//needs a delegate
	assert(delegate != nil);
	//check if passcode is set for CPLockControllerTypeAuth or CPLockControllerTypeForceAuth
	if(style == CPLockControllerTypeAuth || self.style == CPLockControllerTypeForceAuth){
		assert(passcode != nil);
	}
	[self setupSubviews];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	if (IS_IPAD) {
		return YES;
	} else {
		return (interfaceOrientation == UIInterfaceOrientationPortrait);
	}
}

- (void)setupSubviews {
    isLeaving = NO;
	self.view.backgroundColor = [UIColor whiteColor];
	//prompt
	if (IS_IPAD) {
		promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 85, 540, 25)];
	} else {
		promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 85, 320, 25)];
	}
	if(prompt == nil){
		if(self.style == CPLockControllerTypeSet || self.style == CPLockControllerTypeForceSet){
			prompt = kCPLCDefaultSetPrompt;
		} else if(self.style == CPLockControllerTypeAuth || self.style == CPLockControllerTypeForceAuth){
			prompt = kCPLCDefaultAuthPrompt;
		}
	}
	//main prompt
	promptLabel.text = prompt;
	promptLabel.textAlignment = NSTextAlignmentCenter;
	promptLabel.backgroundColor = [UIColor clearColor];
	promptLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
	promptLabel.textColor = [UIColor colorWithRed:0.318 green:0.345 blue:0.416 alpha:1.000];
	[self.view addSubview:promptLabel];
	//sub prompt- used for errors
	if (IS_IPAD) {
		subPromptLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 190, 540, 25)];
	} else {
		subPromptLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 190, 320, 25)];
	}
	subPromptLabel.textAlignment = NSTextAlignmentCenter;
	subPromptLabel.backgroundColor = [UIColor clearColor];
	subPromptLabel.textColor = [UIColor colorWithRed:0.318 green:0.345 blue:0.416 alpha:1.000];;
	subPromptLabel.font = [UIFont systemFontOfSize:14];
	[self.view addSubview:subPromptLabel];
	//bar
	[self setupNavigationBar];
	//text fields
	[self setupTextFields];
}

- (void)setupNavigationBar {
	UINavigationBar *navBar;
	if (IS_IPAD) {
		navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0,0,540,50)];
	} else {
		navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0,0,320,50)];
	}
    [navBar setTranslucent:YES];
	[self.view addSubview:navBar];
	[navBar release];
	navigationItem = [[UINavigationItem alloc]init];
    if (self.style != CPLockControllerTypeForceAuth && self.style != CPLockControllerTypeForceSet) {
        [navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self
                                                                                            action:@selector(userDidCancel:)] autorelease]
                                     animated:NO];
    }
	
	[navBar pushNavigationItem:navigationItem animated:NO];
	if(self.title == nil){
		if(self.style == CPLockControllerTypeSet || self.style == CPLockControllerTypeForceSet){
			//[self setTitle:kCPLCDefaultSetTitle];
			navigationItem.title = kCPLCDefaultSetTitle;
		} else if(self.style == CPLockControllerTypeAuth || self.style == CPLockControllerTypeForceAuth){
			[self setTitle:kCPLCDefaultAuthTitle];
			navigationItem.title = kCPLCDefaultAuthTitle;
		}
	} else {
		navigationItem.title = title;
	}
}

- (void)setupTextFields {
	int toppadding = 125;
	int leftpadding = 15;
	int width = 61;
	int height = 52;
	int padding = 15;
	CGFloat fontsize = 32;
	if (IS_IPAD) {
		leftpadding = 120;
	}
	//create four textfields
	field1 = [[UITextField alloc]initWithFrame:CGRectMake(leftpadding,toppadding,width,height)];
	field1.backgroundColor = [UIColor whiteColor];
	field1.borderStyle = UITextBorderStyleLine;
	field1.enabled = NO;
	field1.secureTextEntry = self.hideCode;
	field1.font = [UIFont systemFontOfSize:fontsize];
	field1.textAlignment = NSTextAlignmentCenter;
	field1.tag = 0;
	[self.view addSubview:field1];
	field2 = [[UITextField alloc]initWithFrame:CGRectMake(leftpadding+width+padding,toppadding,61,height)];
	field2.backgroundColor = [UIColor whiteColor];
	field2.borderStyle = UITextBorderStyleLine;
	field2.enabled = NO;
	field2.secureTextEntry = self.hideCode;
	field2.font = [UIFont systemFontOfSize:fontsize];
	field2.textAlignment = NSTextAlignmentCenter;
	field2.tag = 2;
	[self.view addSubview:field2];
	field3 = [[UITextField alloc]initWithFrame:CGRectMake(leftpadding+width*2+padding*2,toppadding,61,height)];
	field3.backgroundColor = [UIColor whiteColor];
	field3.borderStyle = UITextBorderStyleLine;
	field3.enabled = NO;
	field3.secureTextEntry = self.hideCode;
	field3.font = [UIFont systemFontOfSize:fontsize];
	field3.textAlignment = NSTextAlignmentCenter;
	field3.tag = 3;
	[self.view addSubview:field3];
	field4 = [[UITextField alloc]initWithFrame:CGRectMake(leftpadding+width*3+padding*3,toppadding,61,height)];
	field4.backgroundColor = [UIColor whiteColor];
	field4.borderStyle = UITextBorderStyleLine;
	field4.enabled = NO;
	field4.secureTextEntry = self.hideCode;
	field4.font = [UIFont systemFontOfSize:fontsize];
	field4.textAlignment = NSTextAlignmentCenter;
	field4.tag = 4;
	[self.view addSubview:field4];
	//this is the hidden field the passcode is put into
	hiddenField = [[UITextField alloc]initWithFrame:CGRectMake(-3000,-3000,0,0)];
	hiddenField.text = @"";
	hiddenField.keyboardType = UIKeyboardTypeNumberPad;
	[hiddenField becomeFirstResponder];
	hiddenField.delegate = self;
	[self.view addSubview:hiddenField];
}

#pragma mark -
#pragma mark UITextFieldDelegate Method
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	int charcount = [textField.text length];
	if(([string isEqualToString:@""] && charcount > 0) && [tempString length] > 0){
		charcount-=1;
	}
	if(charcount == 0){
		field1.text = string;
	} else if(charcount == 1){
		field2.text = string;
	} else if(charcount == 2){
		field3.text = string;
	} else if(charcount == 3){
		field4.text = string;
	}
	[self.tempString appendString:string];
    
    if(([string isEqualToString:@""] && charcount >= 0) && [tempString length] > 0){
        NSRange r;
        r.location = [self.tempString length]-1;
        r.length = 1;
        [self.tempString deleteCharactersInRange:r];
	}
	//we've reached 4 chars
	if(charcount == 3){
		if(self.style == CPLockControllerTypeSet || self.style == CPLockControllerTypeForceSet){
			if(passcode == nil){
				//empty tempstring to passcode string
				passcode = [self.tempString copy];
				self.tempString = [NSMutableString string];
				//reset visible/hidden fields
                //has delay in order to show the last input for a moment3
                [self performSelector:@selector(resetFields) withObject:nil afterDelay:0.3f];
				promptLabel.text = kCPLCDefaultConfirmTitle;
				return NO;
			} else {
				//check if confirm matches first
				if([passcode isEqualToString:self.tempString]){
                    isLeaving = YES;
					[delegate lockController:self didFinish:passcode];
					return NO;
                    //confirm passcode doesn't match
				} else {
                    passcode = nil;
					[self passcodeDidNotMatch];
                    return NO;
				}
			}
		} else if(self.style == CPLockControllerTypeAuth || self.style == CPLockControllerTypeForceAuth){
			// check to see if delegate wants to verify first
			if ([delegate respondsToSelector:@selector(lockControllerShouldAcceptPasscode:)]) {
				if ([delegate lockController:self shouldAcceptPasscode:self.tempString]) {
                    isLeaving = YES;
					[delegate lockController:self didFinish:nil];
				} else {
					// delegate rejected passcode
					[self passcodeDidNotMatch];
                    return NO;
				}
			} else {
				if([passcode isEqualToString:self.tempString]){
                    isLeaving = YES;
					[delegate lockController:self didFinish:nil];
				} else {
					[self passcodeDidNotMatch];
					return NO;
				}
			}
		}
	}
	return YES;
}

- (void)passcodeDidNotMatch {
	self.tempString = [NSMutableString string];
	if(self.style == CPLockControllerTypeSet || self.style == CPLockControllerTypeForceSet){
		subPromptLabel.text = kCPLCDefaultSetError;
	} else if(self.style == CPLockControllerTypeAuth || self.style == CPLockControllerTypeForceAuth){
		subPromptLabel.text = kCPLCDefaultAuthError;
	}
	self.retry = YES;
	[self performSelector:@selector(resetFields) withObject:nil afterDelay:0.3f];
    [self performSelector:@selector(resetTextAnimating) withObject:nil afterDelay:0.7f];
}

- (void)resetTextAnimating{
    //    tempString = nil;
    [UIView animateWithDuration:0.6f animations:^{
        [self.subPromptLabel setAlpha:0.0f];
    } completion:^(BOOL finished){
        [self.subPromptLabel setText:@""];
        [self.subPromptLabel setAlpha:1.0f];
        if (style == CPLockControllerTypeSet || style == CPLockControllerTypeForceSet) {
            [UIView animateWithDuration:0.25f animations:^{
                [self.promptLabel setAlpha:0.0f];
            } completion:^(BOOL finished){
                [self.promptLabel setText:prompt];
                [UIView animateWithDuration:0.25f animations:^{
                    [self.promptLabel setAlpha:1.0f];
                } completion:^(BOOL finished){
                    
                }];
            }];
        }
    }];
}

- (void)resetFields {
    field1.text = @"";
    field2.text = @"";
    field3.text = @"";
    field4.text = @"";
    hiddenField.text = @"";
}

- (void)keyboardDidHide{
    if (!isLeaving) {
        [self performSelector:@selector(showKeyboard) withObject:nil afterDelay:0.3];
    }
}

- (void)showKeyboard{
    [self.hiddenField becomeFirstResponder];
}

- (void)userDidCancel:(id)sender {
    isLeaving = YES;
	[delegate lockControllerDidCancel:self];
    /* user must implement
     * [self dismissViewControllerAnimated:YES completion:nil];
     * on the delegate
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
	[navigationItem release];
	[tempString release];
    [super dealloc];
}

@end
