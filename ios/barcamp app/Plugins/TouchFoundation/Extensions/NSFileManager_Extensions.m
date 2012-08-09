//
//  NSFileManager_Extensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 11/13/08.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are
//  permitted provided that the following conditions are met:
//
//     1. Redistributions of source code must retain the above copyright notice, this list of
//        conditions and the following disclaimer.
//
//     2. Redistributions in binary form must reproduce the above copyright notice, this list
//        of conditions and the following disclaimer in the documentation and/or other materials
//        provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY JONATHAN WIGHT ``AS IS'' AND ANY EXPRESS OR IMPLIED
//  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
//  FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL JONATHAN WIGHT OR
//  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//  ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
//  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
//  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//  The views and conclusions contained in the software and documentation are those of the
//  authors and should not be interpreted as representing official policies, either expressed
//  or implied, of toxicsoftware.com.

#import "NSFileManager_Extensions.h"

#if TARGET_OS_IPHONE
#import <MobileCoreServices/MobileCoreServices.h>
#endif /* TARGET_OS_IPHONE */

@implementation NSFileManager (NSFileManager_Extensions)

+ (NSFileManager *)fileManager;
    {
    // TODO One per thread!
    return([[[NSFileManager alloc] init] autorelease]);
    }

- (NSString *)mimeTypeForPath:(NSString *)inPath
    {
    NSString *thePathExtension = [inPath pathExtension];

    CFStringRef thePreferredIdentifier = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (CFStringRef)thePathExtension, NULL);
    if (thePreferredIdentifier)
        {
        CFStringRef theMIMEType = UTTypeCopyPreferredTagWithClass(thePreferredIdentifier, kUTTagClassMIMEType);

        CFRelease(thePreferredIdentifier);

        return([(id)theMIMEType autorelease]);
        }



    if ([thePathExtension isEqualToString:@"html"])
        {
        return(@"text/html");
        }
    else if ([thePathExtension isEqualToString:@"png"])
        {
        return(@"image/png");
        }
    else if ([thePathExtension isEqualToString:@"css"])
        {
        return(@"text/css");
        }
    else if ([thePathExtension isEqualToString:@"jpg"])
        {
        return(@"image/jpeg");
        }
    else if ([thePathExtension isEqualToString:@"gif"])
        {
        return(@"image/gif");
        }
    else if ([thePathExtension isEqualToString:@"js"])
        {
        return(@"text/javascript");
        }
    else if ([thePathExtension isEqualToString:@"rtf"])
        {
        return(@"application/rtf");
        }
    return(@"application/octet-stream");
    }

- (NSString *)applicationSupportFolder
    {
    // TODO rewrite with URLForDirectory.
    NSArray *thePaths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *theBasePath = ([thePaths count] > 0) ? [thePaths objectAtIndex:0] : NSTemporaryDirectory();

    NSString *theBundleName = [[[[NSBundle mainBundle] bundlePath] lastPathComponent] stringByDeletingPathExtension];
    NSString *theApplicationSupportFolder = [theBasePath stringByAppendingPathComponent:theBundleName];

    if ([self fileExistsAtPath:theApplicationSupportFolder] == NO)
        {
        NSError *theError = NULL;
        // TODO possible race condition
        if ([self createDirectoryAtPath:theApplicationSupportFolder withIntermediateDirectories:YES attributes:NULL error:&theError] == NO)
            return(NULL);
        }

    return(theApplicationSupportFolder);
    }


@end
