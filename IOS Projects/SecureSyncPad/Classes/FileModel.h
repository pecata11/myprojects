//
//  FileModel.h
//  SecureSync
//
//  Created by Petko Yanakiev on 3/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileModel : NSObject<NSCoding>

@property (nonatomic,retain) NSString *fileName;
@property (nonatomic,retain) NSDate *fileDate;
@property (nonatomic,retain) NSString *filePath;
@property (nonatomic,assign,getter = isEncrypted) BOOL encrypted;
@property (nonatomic,assign,getter = isDecrypted) BOOL decrypted;
@property (nonatomic,assign,getter = isDirectory) BOOL directory;
@property (nonatomic,assign,getter = isSync) BOOL sync;
@end