//
//  HeadquarterViewController.m
//  barcamp app
//
//  Created by Álvaro Aroca Munoz on 07/08/12.
//  Copyright (c) 2012 Álvaro Aroca Munoz. All rights reserved.
//

#import "HeadquarterViewController.h"
#import "WhereAndWhenViewController.h"
#import "RegistrationViewController.h"
#import "StayViewController.h"

@interface HeadquarterViewController ()

- (void) configWebView;

@end

@implementation HeadquarterViewController
@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    headquarterSections = [NSArray arrayWithObjects:@"Donde y cuando", @"Registro", @"Alojamiento", nil];
    [self configWebView];
}

- (void)configWebView {
    NSError* error = nil;
    
    NSString* htmlData = [NSString stringWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"Culpables" ofType:@"html"] encoding:NSUTF8StringEncoding error:&error];
    
    if (!error) {
        [self.webView loadHTMLString:htmlData baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    }
    
    self.webView.scrollView.bounces = NO;
    self.webView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.webView.layer.shadowOpacity = 1.0;
    self.webView.layer.shadowRadius = 10.0;
    self.webView.layer.shadowOffset = CGSizeZero;
    self.webView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.webView.bounds].CGPath;
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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        WhereAndWhenViewController* whereAndWhen = [[WhereAndWhenViewController alloc] initWithNibName:@"WhereAndWhenView" bundle:nil];
        [self.navigationController pushViewController:whereAndWhen animated:YES];
        [whereAndWhen release];
    } else if (indexPath.row == 1) {
        RegistrationViewController* registration = [[RegistrationViewController alloc] initWithNibName:@"RegistrationView" bundle:nil];
        [self.navigationController pushViewController:registration animated:YES];
        [registration release];
    } else if (indexPath.row == 2) {
        StayViewController* stay = [[StayViewController alloc] initWithNibName:@"StayView" bundle:nil];
        [self.navigationController pushViewController:stay animated:YES];
        [stay release];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return headquarterSections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        cell.textLabel.textColor = [UIColor whiteColor];
    }

    if (indexPath.row >= 0 && indexPath.row < headquarterSections.count) {
        cell.textLabel.text = [headquarterSections objectAtIndex:indexPath.row];
    }
    
    return cell;
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
