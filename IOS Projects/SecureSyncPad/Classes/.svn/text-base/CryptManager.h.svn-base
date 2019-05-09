//
//  CryptManager.h
//  SecureSync
//
//  Created by Petko Yanakiev on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import  <Foundation/Foundation.h>
#import  <CommonCrypto/CommonCryptor.h>
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>

extern NSString * const kRNCryptManagerErrorDomain;

@interface CryptManager : NSObject
+ (BOOL)encryptFromStream:(NSInputStream *)fromStream
                 toStream:(NSOutputStream *)toStream
                 password:(NSString *)password
                    error:(NSError **)error;

+ (BOOL)decryptFromStream:(NSInputStream *)fromStream
                 toStream:(NSOutputStream *)toStream
                 password:(NSString *)password
                    error:(NSError **)error;

+ (NSData *)encryptedDataForData:(NSData *)data
                        password:(NSString *)password
                              iv:(NSData **)iv
                            salt:(NSData **)salt
                           error:(NSError **)error;

+ (NSData *)decryptedDataForData:(NSData *)data
                        password:(NSString *)password 
                              iv:(NSData *)iv
                            salt:(NSData *)salt
                           error:(NSError **)error;

+ (NSData*)encryptData:(NSData*)data key:(NSData*)key iv:(NSData*)iv;
+ (NSData*)decryptData:(NSData*)data key:(NSData*)key iv:(NSData*)iv;

@end