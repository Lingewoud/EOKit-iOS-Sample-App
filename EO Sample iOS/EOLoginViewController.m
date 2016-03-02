//
//  EOLoginViewController.m
//  EOSDK
//
//  Created by Andrew Kopanev on 1/10/15.
//  Copyright (c) 2015 Moqod. All rights reserved.
//

#import "EOLoginViewController.h"
#import "EOGLAccountsTableViewController.h"

#import "EOAPIProvider.h"

@interface EOLoginViewController ()

@property (nonatomic, strong) IBOutlet UIButton		*loginButton;
@property (nonatomic, strong) IBOutlet EOAuthorizationViewController *authView;

@end

@implementation EOLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Exact Online";
	[self.loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - actions

- (void)loginAction:(UIButton *)sender {
   
	NSString *clientId = @"b2314659-95c7-4bf6-8450-468db26abe8f";
	NSString *secret = @"AAtLBzurJ8B1";
	NSString *callbackURL = @"https://www.getpostman.com/oauth2/callback";
    
    
    _authView = [[EOAuthorizationViewController alloc] init];
	
	// Use your clientId, secret and callback URL here
	[[EOAPIProvider providerWithClientId:clientId secret:secret] authorizeWithCallbackURL:callbackURL authViewController:_authView completion:^(NSError *error) {
		if (!error) {
			[self.navigationController pushViewController:[EOGLAccountsTableViewController new] animated:YES];
		} else {
			NSLog(@"error == %@", error);
		}
	}];
}

@end
