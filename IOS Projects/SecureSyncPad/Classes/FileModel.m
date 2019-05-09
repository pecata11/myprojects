//
//  FileModel.m
//  SecureSync
//
//  Created by Petko Yanakiev on 3/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FileModel.h"

@implementation FileModel

@synthesize fileName=_fileName;
@synthesize filePath=_filePath;
@synthesize fileDate=_fileDate;
@synthesize encrypted=_encrypted;
@synthesize decrypted=_decrypted;
@synthesize directory=_directory;
@synthesize sync=_sync;

- (void)encodeWithCoder:(NSCoder *)encoder
{
      [encoder encodeObject:self.fileName forKey:@"filename"];
      [encoder encodeObject:self.filePath forKey:@"filepath"];
      [encoder encodeObject:self.fileDate forKey:@"filedate"];
      [encoder encodeInt:self.encrypted forKey:@"encrypted"];
      [encoder encodeInt:self.decrypted forKey:@"decrypted"];
      [encoder encodeInt:self.directory forKey:@"directory"];
      [encoder encodeInt:self.sync forKey:@"sync"];
    
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    self.fileName = [[decoder decodeObjectForKey:@"filename"] retain];
    self.filePath = [[decoder decodeObjectForKey:@"filepath"]retain];
    self.fileDate = [[decoder decodeObjectForKey:@"filedate"]retain];
    self.encrypted = [decoder decodeIntForKey:@"encrypted"];
    self.decrypted = [decoder decodeIntForKey:@"decrypted"];
    self.directory = [decoder decodeIntForKey:@"directory"];
    self.sync = [decoder decodeIntForKey:@"sync"];
        
    return self;
}


-(void) dealloc{
    [super dealloc];
    [_fileName release];
    [_fileDate release];
    //[_filePath release];
    
}
@end
