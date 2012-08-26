//
//  ShareableViewController.m
//  barcamp app
//
//  Created by Álvaro Aroca Munoz on 09/08/12.
//  Copyright (c) 2012 Álvaro Aroca Munoz. All rights reserved.
//

#import "ShareableViewController.h"
#import "AppDelegate.h"
#import "Config.h"

@interface ShareableViewController ()

// Share content
- (void) shareContent;
- (void) sharingContent;
- (void) shared;
- (void) noShared;
- (void) cancelSharing;

@end

@implementation ShareableViewController
@synthesize contentToShare = _contentToShare;

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
    
    // Add share content button.
    UIBarButtonItem* shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareContent)];
    self.navigationItem.rightBarButtonItem = shareButton;
    [shareButton release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
                                    
#pragma mark - Share content action
                                    
- (void) shareContent {
    FTShare *share = [self shareInstance];
    
    [share showActionSheetWithtitle:@"Compartir con" andOptions:FTShareOptionsFacebook|FTShareOptionsTwitter];
}

- (void) sharingContent {
    self.view.userInteractionEnabled = NO;
    for(UITabBarItem *item in self.tabBarController.tabBar.items)
        item.enabled = NO;
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	HUD.dimBackground = YES;
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"Enviando...";
	
	// Regiser for HUD callbacks so we can remove it from the window at the right time
	HUD.delegate = self;
    
    [HUD show:YES];
}

- (void) shared {
    HUD.mode = MBProgressHUDModeText;
    HUD.labelText = @"Enviado";

	[HUD hide:YES afterDelay:1];
    
    self.view.userInteractionEnabled = YES;
    for(UITabBarItem *item in self.tabBarController.tabBar.items)
        item.enabled = YES;
}

- (void) noShared {
    HUD.mode = MBProgressHUDModeText;
    HUD.labelText = @"Se produjo un error";

	[HUD hide:YES afterDelay:1];
    
    self.view.userInteractionEnabled = YES;
    for(UITabBarItem *item in self.tabBarController.tabBar.items)
        item.enabled = YES;
}

- (void) cancelSharing {
    self.view.userInteractionEnabled = YES;
    for(UITabBarItem *item in self.tabBarController.tabBar.items)
        item.enabled = YES;
    
    [HUD hide:YES];
}

- (FTShare *)shareInstance {
    AppDelegate *appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [appDel.share setReferencedController:self];
    
    // set up sharing components
    [appDel.share setUpTwitterWithConsumerKey:kIKTwitterConsumerKey secret:kIKTwiiterPasscode andDelegate:self];
    [appDel.share setUpFacebookWithAppID:kIKFacebookAppID permissions:FTShareFacebookPermissionRead|FTShareFacebookPermissionPublish|FTShareFacebookPermissionOffLine andDelegate:self];
    
    return appDel.share;
}

#pragma mark - Twitter data

- (FTShareTwitterData *)twitterData {
    FTShareTwitterData *data = [[FTShareTwitterData alloc] init];
    [data setMessage:self.contentToShare];
    [data setHasControllerSupport: YES]; // set to YES to use message controller
    return data;
}

- (void)twitterDidPost:(NSError *)error {
    if (!error) {
        [self shared];
    } else {
        [self noShared];
    }
}

#pragma mark - Facebook data

- (FTShareFacebookData *)facebookShareData {
    FTShareFacebookData *data = [[FTShareFacebookData alloc] init];
    [data setMessage:self.contentToShare];
    [data setLink:@"http://barcampspain.com/"];
    [data setCaption:@"Barcamp app"];
    [data setType:FTShareFacebookRequestTypePost];
    [data setHttpType:FTShareFacebookHttpTypePost];
    [data setHasControllerSupport:YES];  // set to YES to use message controller
    return [data autorelease];
}

- (void)facebookDidPost:(NSError *)error {
    if (!error) {
        [self shared];
    } else {
        [self noShared];
    }
}

#pragma mark - ShareController delegate

- (void)shareMessageController:(FTShareMessageController *)controller didFinishWithMessage:(NSString *)message {
    [self sharingContent];
}

- (void)shareMessageControllerDidCancel:(FTShareMessageController *)controller {
    [self cancelSharing];
}

#pragma mark - MBProgressHUD delegat 

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	[HUD release];
	HUD = nil;
}

@end
