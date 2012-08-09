//
//  NewDetailViewController.h
//  barcamp app
//
//  Created by Álvaro Aroca Munoz on 07/08/12.
//  Copyright (c) 2012 Álvaro Aroca Munoz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ShareableViewController.h"

@class CFeedEntry;

@interface NewDetailViewController : ShareableViewController<UIWebViewDelegate> {
    @private
    NSString* content;
    NSString* title;
}

@property (retain, nonatomic) IBOutlet UIWebView *webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil content:(CFeedEntry*)entry;

@end
