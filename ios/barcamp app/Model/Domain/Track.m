//
//  Track.m
//  barcamp app
//
//  Created by Álvaro Aroca Munoz on 03/09/12.
//  Copyright (c) 2012 Álvaro Aroca Munoz. All rights reserved.
//

#import "Track.h"
#import "Meeting.h"

@implementation Track

@synthesize meetings = _meetings;

- (NSString*) description {
    NSMutableString* description = [NSMutableString string];
    
    for (Meeting* meeting in self.meetings) {
        [description appendFormat:@"%@\r\n", [meeting description]];
    }
    
    return description;
}

@end
