//
//  CompanyWebViewController.m
//  BuyBackYourVote3
//
//  Created by Nathan Keyes on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CompanyWebViewController.h"

@interface CompanyWebViewController ()

@end

@implementation CompanyWebViewController
@synthesize webView, companyURL, companyName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = self.companyName;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://buybackyourvote.herokuapp.com/company/%@?iphone=true", companyURL]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSLog(@"The NSURLRequest is %@", request);
    [self.webView loadRequest:request];

	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
