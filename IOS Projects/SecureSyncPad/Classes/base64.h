//
//  base64.h
//  LeoAction
//
//  Created by Snow Leopard User on 07/10/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface base64 : NSObject {
	
}

+ (NSString *)encodeBase64WithString:(NSString *)strData;
+ (NSString *)encodeBase64WithData:(NSData *)objData;
+ (NSData *)decodeBase64WithString:(NSString *)strBase64;
+ (NSData*)decodeBase64FromString:(NSString*) encodedString;
@end
