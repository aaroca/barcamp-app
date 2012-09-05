//
//  MeetingDetailViewController.h
//  barcamp app
//
//  Created by Álvaro Aroca Munoz on 07/08/12.
//  Copyright (c) 2012 Álvaro Aroca Munoz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareableViewController.h"

@class Meeting;

@interface MeetingDetailViewController : ShareableViewController {
    Meeting* meeting;
}
@property (retain, nonatomic) IBOutlet UIImageView *ponenteImage;
@property (retain, nonatomic) IBOutlet UIButton *ponenteTwitter;
@property (retain, nonatomic) IBOutlet UIButton *ponenteWeb;
@property (retain, nonatomic) IBOutlet UITextView *ponenteNombre;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *loadingPonenteImage;
@property (retain, nonatomic) IBOutlet UITextView *ponenciaDescripcion;
@property (retain, nonatomic) IBOutlet UILabel *lugarHoraPonencia;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withMeetingData:(Meeting*)data;
- (IBAction)openTwitterAccount:(id)sender;
- (IBAction)openWebsite:(id)sender;

@end
