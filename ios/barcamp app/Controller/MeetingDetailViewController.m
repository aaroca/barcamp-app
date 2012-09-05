//
//  MeetingDetailViewController.m
//  barcamp app
//
//  Created by Álvaro Aroca Munoz on 07/08/12.
//  Copyright (c) 2012 Álvaro Aroca Munoz. All rights reserved.
//

#import "MeetingDetailViewController.h"
#import "Meeting.h"

@interface MeetingDetailViewController ()

- (void) getTwitterAvatar;

@end

@implementation MeetingDetailViewController
@synthesize ponenteImage;
@synthesize ponenteTwitter;
@synthesize ponenteWeb;
@synthesize ponenteNombre;
@synthesize loadingPonenteImage;
@synthesize ponenciaDescripcion;
@synthesize lugarHoraPonencia;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withMeetingData:(Meeting*)data
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        meeting = data;
        
        // Init detail meeting title
        self.navigationItem.title = meeting.titulo;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // If meeting has twitter account we get image profile from there and enable twitter button.
    if (meeting.twitter && meeting.twitter.length > 0) {
        [self performSelectorInBackground:@selector(getTwitterAvatar) withObject:nil];
        self.ponenteTwitter.enabled = YES;
    }
    
    // If meeting has website enable button.
    if (meeting.web && meeting.web.length > 0) {
        self.ponenteWeb.enabled = YES;
    }
    
    // Fill another fields.
    self.ponenteNombre.text = meeting.ponente;
    self.ponenciaDescripcion.text = meeting.descripcion;
    self.lugarHoraPonencia.text = [NSString stringWithFormat:@"A las %@ en la sala %@", meeting.hora, meeting.sala];
    
    // Fill content to share strings.
    self.contentToShare = [NSString stringWithFormat:@"Ponencia: %@ en @barcampes", meeting.titulo];
}

- (void)viewDidUnload
{
    [self setPonenteImage:nil];
    [self setPonenteTwitter:nil];
    [self setPonenteWeb:nil];
    [self setPonenteNombre:nil];
    [self setLoadingPonenteImage:nil];
    [self setPonenciaDescripcion:nil];
    [self setLugarHoraPonencia:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [ponenteImage release];
    [ponenteTwitter release];
    [ponenteWeb release];
    [ponenteNombre release];
    [loadingPonenteImage release];
    [ponenciaDescripcion release];
    [lugarHoraPonencia release];
    [super dealloc];
}

#pragma mark - Profile external links operations

- (IBAction)openTwitterAccount:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: [NSString stringWithFormat:@"http://www.twitter.com/%@", meeting.twitter]]];
}

- (IBAction)openWebsite:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: meeting.web]];
}

#pragma mark - Twitter operations

- (void) getTwitterAvatar {
    self.ponenteImage.hidden = YES;
    self.loadingPonenteImage.hidden = NO;
    
    UIImage* twitterAvatar = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.twitter.com/1/users/profile_image?screen_name=%@&size=bigger", meeting.twitter]]]];
    
    if (twitterAvatar) {
        self.ponenteImage.image = twitterAvatar;
    }
    
    self.loadingPonenteImage.hidden = YES;
    self.ponenteImage.hidden = NO;
}

@end
