//
//  TracksViewController.m
//  barcamp app
//
//  Created by Álvaro Aroca Munoz on 07/08/12.
//  Copyright (c) 2012 Álvaro Aroca Munoz. All rights reserved.
//

#import "TracksViewController.h"
#import "XMLtoTrackService.h"
#import "GCPagedScrollView.h"
#import "Track.h"
#import "MeetingsViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface TracksViewController ()

@property (nonatomic, readonly) GCPagedScrollView* scrollView;

- (NSArray*) getTracks;
- (void) renderPages;

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

- (void)loadView {
    [super loadView];
    
    GCPagedScrollView* scrollView = [[GCPagedScrollView alloc] initWithFrame:self.view.frame];
    scrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    scrollView.backgroundColor = [UIColor colorWithRed:0.847 green:0.847 blue:0.847 alpha:1] /*#d8d8d8*/;
    
    self.view = scrollView;
    [scrollView release];
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
    
    // Render each track page.
    [self renderPages];
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

#pragma mark - Rendering pages

- (void) renderPages {
    for (Track* track in self.tracks) {
        MeetingsViewController* meetingsViewController = [[MeetingsViewController alloc] initWithNibName:@"MeetingsView" bundle:nil andMeetings:track.meetings];
        [(GCPagedScrollView*)self.view addContentSubview:meetingsViewController.view];
    }
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
