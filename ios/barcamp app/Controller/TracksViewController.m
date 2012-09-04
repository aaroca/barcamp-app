//
//  TracksViewController.m
//  barcamp app
//
//  Created by Álvaro Aroca Munoz on 07/08/12.
//  Copyright (c) 2012 Álvaro Aroca Munoz. All rights reserved.
//

#import "TracksViewController.h"
#import "XMLtoTrackService.h"

@interface TracksViewController ()

- (NSArray*) getTracks;

@end

@implementation TracksViewController

@synthesize tracks = _tracks;
@synthesize loadingTracksView = _loadingTracksView;

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
    
    // Get Tracks from local
    
    // If no local tracks, we get from online file
    if (!self.tracks || self.tracks.count == 0) {
        self.tracks = [self getTracks];
    }
    
    // Hide loading tracks view.
    self.loadingTracksView.hidden = YES;
}

- (void)viewDidUnload
{
    [self setLoadingTracksView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [_loadingTracksView release];
    [super dealloc];
}

#pragma mark - Tracks operations

- (NSArray*) getTracks {
    NSArray* results = nil;
    
    // Get online XML.
    NSError* error;
    NSString* xml = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://dl.dropbox.com/u/3837140/barcamp%20app/tracks.xml"] encoding:NSUTF8StringEncoding error:&error];
    
    if (!error) {
        // Parse Tracks.
        results = [XMLtoTrackService getTracksFromXML:xml];
    
        if (results.count > 0) {
            // Update local db.
            
        } else {
            // Show no tracks found message.
            
        }
        
    } else {
        // Show error message.
        
    }
    
    return results;
}

@end
