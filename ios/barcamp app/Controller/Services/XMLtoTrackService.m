//
//  XMLtoTrackService.m
//  barcamp app
//
//  Created by Álvaro Aroca Munoz on 03/09/12.
//  Copyright (c) 2012 Álvaro Aroca Munoz. All rights reserved.
//

#import "XMLtoTrackService.h"
#import "TouchXML.h"
#import "Meeting.h"
#import "Track.h"

@implementation XMLtoTrackService

+ (NSArray*) getTracksFromXML:(NSData*)data {
    NSMutableArray* tracks = [NSMutableArray array];
    
    // XML Parser
    NSError* error = nil;
    CXMLDocument* documentRoot = [[[CXMLDocument alloc] initWithData:data options:0 error:&error] autorelease];
    
    // If not error parsing XML
    if (!error) {
        NSArray* tracksNodes = [[documentRoot nodeForXPath:@"tracks" error:&error] nodesForXPath:@"track" error:&error];
        
        for (CXMLElement* trackNode in tracksNodes) {
            NSMutableArray* meetings = [NSMutableArray array];
            NSArray* meetingsNodes = [trackNode nodesForXPath:@"meeting" error:&error];
            
            for (CXMLElement* meetingNode in meetingsNodes) {
                Meeting* meeting = [Meeting new];
                meeting.titulo = [[meetingNode nodeForXPath:@"titulo" error:&error] stringValue];
                meeting.ponente = [[meetingNode nodeForXPath:@"ponente" error:&error] stringValue];
                meeting.twitter = [[meetingNode nodeForXPath:@"twitter" error:&error] stringValue];
                meeting.web = [[meetingNode nodeForXPath:@"web" error:&error] stringValue];
                meeting.sala = [[meetingNode nodeForXPath:@"sala" error:&error] stringValue];
                meeting.hora = [[meetingNode nodeForXPath:@"hora" error:&error] stringValue];
                meeting.descripcion = [[meetingNode nodeForXPath:@"descripcion" error:&error] stringValue];
                
                [meetings addObject:meeting];
            }
            
            Track* track = [Track new];
            track.meetings = meetings;
            [tracks addObject:track];
        }
    }
    
    return tracks;
}

@end
