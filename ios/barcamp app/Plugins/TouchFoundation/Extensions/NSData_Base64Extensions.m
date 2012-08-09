//
//  NSData_Base64Extensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 5/10/06.
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

#import "NSData_Base64Extensions.h"

#import "Base64Transcoder.h"

@implementation NSData (NSData_Base64Extensions)

+ (id)dataWithBase64EncodedString:(NSString *)inString
{
NSData *theEncodedData = [inString dataUsingEncoding:NSASCIIStringEncoding];
size_t theDecodedDataSize = EstimateBas64DecodedDataSize([theEncodedData length], Base64Flags_IncludeNewlines);
void *theDecodedData = malloc(theDecodedDataSize);
Base64DecodeData([theEncodedData bytes], [theEncodedData length], theDecodedData, &theDecodedDataSize, Base64Flags_IncludeNewlines);
theDecodedData = reallocf(theDecodedData, theDecodedDataSize);
if (theDecodedData == NULL)
	return(NULL);
id theData = [self dataWithBytesNoCopy:theDecodedData length:theDecodedDataSize freeWhenDone:YES];
return(theData);
}

- (NSString *)asBase64EncodedString;
{
return([self asBase64EncodedString:Base64Flags_IncludeNewlines]);
}

- (NSString *)asBase64EncodedString:(NSInteger)inFlags;
{
size_t theEncodedDataSize = EstimateBas64EncodedDataSize([self length], (int32_t)inFlags);
void *theEncodedData = malloc(theEncodedDataSize);
Base64EncodeData([self bytes], [self length], theEncodedData, &theEncodedDataSize, (int32_t)inFlags);
theEncodedData = reallocf(theEncodedData, theEncodedDataSize);
if (theEncodedData == NULL)
	return(NULL);
NSString *theString = [NSString stringWithUTF8String:theEncodedData];
free(theEncodedData);
return(theString);
}

@end
