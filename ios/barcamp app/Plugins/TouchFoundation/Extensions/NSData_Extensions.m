//
//  NSData_Extensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 05/09/09.
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

#import "NSData_Extensions.h"

@implementation NSData (NSData_Extensions)

+ (id)dataWithHexString:(NSString *)inHexString;
	{
	static char digits[] = {
		-1 /* 0x0 */,    -1 /* 0x1 */,    -1 /* 0x2 */,    -1 /* 0x3 */,    -1 /* 0x4 */,    -1 /* 0x5 */,    -1 /* 0x6 */,    -1 /* 0x7 */,
		-1 /* 0x8 */,    -1 /* 0x9 */,    -1 /* 0xa */,    -1 /* 0xb */,    -1 /* 0xc */,    -1 /* 0xd */,    -1 /* 0xe */,    -1 /* 0xf */,
		-1 /* 0x10 */,   -1 /* 0x11 */,   -1 /* 0x12 */,   -1 /* 0x13 */,   -1 /* 0x14 */,   -1 /* 0x15 */,   -1 /* 0x16 */,   -1 /* 0x17 */,
		-1 /* 0x18 */,   -1 /* 0x19 */,   -1 /* 0x1a */,   -1 /* 0x1b */,   -1 /* 0x1c */,   -1 /* 0x1d */,   -1 /* 0x1e */,   -1 /* 0x1f */,
		-1 /* 0x20 */,   -1 /* 0x21 */,   -1 /* 0x22 */,   -1 /* 0x23 */,   -1 /* 0x24 */,   -1 /* 0x25 */,   -1 /* 0x26 */,   -1 /* 0x27 */,
		-1 /* 0x28 */,   -1 /* 0x29 */,   -1 /* 0x2a */,   -1 /* 0x2b */,   -1 /* 0x2c */,   -1 /* 0x2d */,   -1 /* 0x2e */,   -1 /* 0x2f */,
		 0 /* 0x30 */,    1 /* 0x31 */,    2 /* 0x32 */,    3 /* 0x33 */,    4 /* 0x34 */,    5 /* 0x35 */,    6 /* 0x36 */,    7 /* 0x37 */,
		 8 /* 0x38 */,    9 /* 0x39 */,   -1 /* 0x3a */,   -1 /* 0x3b */,   -1 /* 0x3c */,   -1 /* 0x3d */,   -1 /* 0x3e */,   -1 /* 0x3f */,
		-1 /* 0x40 */,    0xA /* 0x41 */,    0xB /* 0x42 */,    0xC /* 0x43 */,    0xD /* 0x44 */,    0xE /* 0x45 */,    0xF /* 0x46 */,   -1 /* 0x47 */,
		-1 /* 0x48 */,   -1 /* 0x49 */,   -1 /* 0x4a */,   -1 /* 0x4b */,   -1 /* 0x4c */,   -1 /* 0x4d */,   -1 /* 0x4e */,   -1 /* 0x4f */,
		-1 /* 0x50 */,   -1 /* 0x51 */,   -1 /* 0x52 */,   -1 /* 0x53 */,   -1 /* 0x54 */,   -1 /* 0x55 */,   -1 /* 0x56 */,   -1 /* 0x57 */,
		-1 /* 0x58 */,   -1 /* 0x59 */,   -1 /* 0x5a */,   -1 /* 0x5b */,   -1 /* 0x5c */,   -1 /* 0x5d */,   -1 /* 0x5e */,   -1 /* 0x5f */,
		-1 /* 0x60 */,    0xa /* 0x61 */,    0xb /* 0x62 */,    0xc /* 0x63 */,    0xd /* 0x64 */,    0xe /* 0x65 */,    0xf /* 0x66 */,   -1 /* 0x67 */,
		-1 /* 0x68 */,   -1 /* 0x69 */,   -1 /* 0x6a */,   -1 /* 0x6b */,   -1 /* 0x6c */,   -1 /* 0x6d */,   -1 /* 0x6e */,   -1 /* 0x6f */,
		-1 /* 0x70 */,   -1 /* 0x71 */,   -1 /* 0x72 */,   -1 /* 0x73 */,   -1 /* 0x74 */,   -1 /* 0x75 */,   -1 /* 0x76 */,   -1 /* 0x77 */,
		-1 /* 0x78 */,   -1 /* 0x79 */,   -1 /* 0x7a */,   -1 /* 0x7b */,   -1 /* 0x7c */,   -1 /* 0x7d */,   -1 /* 0x7e */,   -1 /* 0x7f */,
		};

	NSMutableData *theData = [NSMutableData dataWithLength:inHexString.length / 2];
	char *OUT = (char *)theData.mutableBytes;
	
	
	const char *INX = [inHexString UTF8String];
	char  *OUTX = OUT;
	while (*INX != 0)
		{
		char HI = digits[*INX++];
		if (HI >= 0)
			{
			while (*INX != 0)
				{
				char LO = digits[*INX++];
				if (LO >= 0)
					{
					*OUTX++ = (char)(HI << 4 | LO);
					break;
					}
				}
			}
		}
		
	theData.length = OUTX - OUT;
	return([[theData copy] autorelease]);
	}

- (NSString *)hexString
	{
	return([self hexString:YES]);
	}

- (NSString *)hexString:(BOOL)inLowercase
	{
	NSUInteger theLength = [self length];
	NSMutableData *theHex = [NSMutableData dataWithLength:theLength * 2];
	const char *IN = [self bytes];
	char *OUT = [theHex mutableBytes];
	char *theHexTable = NULL;
	if (inLowercase)
		theHexTable = "0123456789abcdef";
	else
		theHexTable = "0123456789ABCDEF";
	size_t INX = 0;
	for (; INX < theLength; ++INX)
		{
		const UInt8 theOctet = IN[INX];
		*OUT++ = theHexTable[(theOctet >> 4) & 0x0F];
		*OUT++ = theHexTable[theOctet & 0x0F];
		}

	NSString *theString = [[[NSString alloc] initWithData:theHex encoding:NSASCIIStringEncoding] autorelease];
	return(theString);
	}


@end
