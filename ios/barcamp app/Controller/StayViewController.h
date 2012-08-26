//
//  StayViewController.h
//  barcamp app
//
//  Created by Álvaro Aroca Munoz on 26/08/12.
//  Copyright (c) 2012 Álvaro Aroca Munoz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StayViewController : UIViewController <UIWebViewDelegate>

@property (retain, nonatomic) IBOutlet UIWebView *webView;
@end
