//
//  HeadquarterViewController.h
//  barcamp app
//
//  Created by Álvaro Aroca Munoz on 07/08/12.
//  Copyright (c) 2012 Álvaro Aroca Munoz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class WhereAndWhenViewController;
@class RegistrationViewController;
@class StayViewController;

@interface HeadquarterViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate> {
    @private
    NSArray* headquarterSections;
}
@property (retain, nonatomic) IBOutlet UIWebView *webView;

@end
