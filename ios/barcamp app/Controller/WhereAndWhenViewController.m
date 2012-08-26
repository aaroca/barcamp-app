//
//  WhereAndWhenViewController.m
//  barcamp app
//
//  Created by Álvaro Aroca Munoz on 26/08/12.
//  Copyright (c) 2012 Álvaro Aroca Munoz. All rights reserved.
//

#import "WhereAndWhenViewController.h"

@interface WhereAndWhenViewController ()

@end

@implementation WhereAndWhenViewController
@synthesize webView;

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
	// Do any additional setup after loading the view.
    
    NSError* error = nil;

    NSString* htmlData = [NSString stringWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"DondeCuando" ofType:@"html"] encoding:NSUTF8StringEncoding error:&error];
    
    if (!error) {
        [self.webView loadHTMLString:htmlData baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    }
    
    self.navigationItem.title = @"Donde y Cuando";
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

- (void)dealloc {
    [webView release];
    [super dealloc];
}

#pragma mark - UIWebViewDelegat

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    BOOL loading = YES;
    
    if ([request.URL.description rangeOfString:@"http"].location != NSNotFound) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: request.URL.description]];
        loading = NO;
    }
    
    return loading;
}

@end
