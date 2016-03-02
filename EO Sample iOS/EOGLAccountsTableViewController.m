//
//  EOGLAccountsTableViewController.m
//  EOSDK
//
//  Created by Andrew Kopanev on 1/10/15.
//  Copyright (c) 2015 Moqod. All rights reserved.
//

#import "EOGLAccountsTableViewController.h"
#import "EOAPIProvider.h"

@interface EOGLAccountsTableViewController ()

@property (nonatomic, strong) NSArray		*glAccountsList;

@end

@implementation EOGLAccountsTableViewController

#pragma mark -

- (void)handleError:(NSError *)error {
	NSLog(@"%s error == %@", __PRETTY_FUNCTION__, error);
}

- (void)requestMe {
	[[EOAPIProvider anyProvider] restGetAPI:@"current/Me" completion:^(NSArray *results, NSError *error) {
		if (!error) {
			[self requestAccounts];
		} else {
			[self handleError:error];
		}
	}];
}

- (void)requestAccounts {
	if (![EOAPIProvider anyProvider].currentDivision) {
		[self requestMe];
	} else {
		[[EOAPIProvider anyProvider] restGetAPI:@"financial/GLAccounts" division:[EOAPIProvider anyProvider].currentDivision odataParams:@{ @"$orderby" : @"Description" } grabAllItems:YES completion:^(NSArray *results, NSError *error) {
			if (!error) {
				self.glAccountsList = results;
				[self.tableView reloadData];
			} else {
				[self handleError:error];
			}
		}];
	}
}

#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"GLAccounts";
	[self requestAccounts];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.glAccountsList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
	}
	
	NSDictionary *glAccountDict = self.glAccountsList[indexPath.row];
	cell.textLabel.text = glAccountDict[@"Description"];
	cell.detailTextLabel.text = glAccountDict[@"TypeDescription"];
    return cell;
}

@end
