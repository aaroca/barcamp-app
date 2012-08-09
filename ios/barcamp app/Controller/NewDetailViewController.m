//
//  NewDetailViewController.m
//  barcamp app
//
//  Created by Álvaro Aroca Munoz on 07/08/12.
//  Copyright (c) 2012 Álvaro Aroca Munoz. All rights reserved.
//

#import "NewDetailViewController.h"
#import "CFeedEntry.h"

@interface NewDetailViewController ()

@end

@implementation NewDetailViewController
@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil content:(CFeedEntry*)entry
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSMutableString* htmlContent = [NSMutableString stringWithString:[[entry.extraXML objectForKey:@"encoded"] description]];
        NSRange start = [htmlContent rangeOfString:@"<![CDATA["];
        htmlContent = [NSMutableString stringWithString:[htmlContent substringFromIndex:start.location + start.length]];
        NSRange end = [htmlContent rangeOfString:@"]]>"];
        htmlContent = [NSMutableString stringWithString:[htmlContent substringToIndex:end.location]];
        
        content = htmlContent;
        title = entry.title;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.webView.backgroundColor = self.view.backgroundColor;
    [self.webView loadHTMLString:content baseURL:[NSURL URLWithString:nil]];
    self.navigationItem.title = title;
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

#pragma mark - UIWebViewDelegate protocol

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    BOOL loading = YES;

    if (![request.URL.description isEqualToString:@"about:blank"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: request.URL.description]];
        loading = NO;
    }
    
    return loading;
}

@end
