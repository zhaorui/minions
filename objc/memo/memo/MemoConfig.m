//
//  MemoConfig.m
//  memo
//
//  Created by 赵睿 on 3/20/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#import "MemoConfig.h"

#define DEFAULT_LOCATION "~/Document/memo"
#define CONFIG_DIR  "~/.config/memo"
#define CONFIG_PATH CONFIG_DIR"/memoconfig"

typedef NS_ENUM(NSUInteger, EncodeOptions) {
    EncodeOptionsJson,
    EncodeOptionsXML,
    EncodeOptionsBinaryPlist,
};

static EncodeOptions encodeChoice = EncodeOptionsJson;

@interface MemoConfig ()

@property (readwrite, copy) NSString* path;

@end

@interface MemoConfig (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;
@end

#pragma mark - JSON serialization c interface

MemoConfig *_Nullable MemoConfigFromData(NSData *data, NSError **error)
{
    @try {
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:error];
        return *error ? nil : [MemoConfig fromJSONDictionary:json];
    } @catch (NSException *exception) {
        *error = [NSError errorWithDomain:@"JSONSerialization" code:-1 userInfo:@{ @"exception": exception }];
        return nil;
    }
}

MemoConfig *_Nullable MemoConfigFromJSON(NSString *json, NSStringEncoding encoding, NSError **error)
{
    return MemoConfigFromData([json dataUsingEncoding:encoding], error);
}

NSData *_Nullable MemoConfigToData(MemoConfig *topLevel, NSError **error)
{
    @try {
        id json = [topLevel JSONDictionary];
        NSData *data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:error];
        if (error) {
            return *error ? nil : data;
        } else {
            return data;
        }
    } @catch (NSException *exception) {
        *error = [NSError errorWithDomain:@"JSONSerialization" code:-1 userInfo:@{ @"exception": exception }];
        return nil;
    }
}

NSString *_Nullable MemoConfigToJSON(MemoConfig *topLevel, NSStringEncoding encoding, NSError **error)
{
    NSData *data = MemoConfigToData(topLevel, error);
    return data ? [[NSString alloc] initWithData:data encoding:encoding] : nil;
}


@implementation MemoConfig

+ (id)sharedConfig {
    static dispatch_once_t onceToken;
    static MemoConfig* _memo_config;
    dispatch_once(&onceToken, ^{
        
        // create memoconfig if it's not exist
        BOOL isF = NO;
        NSString* memoconfig = [@CONFIG_PATH stringByStandardizingPath];
        NSString* memoconfigDir = [@CONFIG_DIR stringByStandardizingPath];
        BOOL isE = [[NSFileManager defaultManager] fileExistsAtPath:memoconfig isDirectory:&isF];
        
        if (!isE || isF) {
            printf("setup your memo root dir ("DEFAULT_LOCATION"): ");
            
            char *line = NULL;
            size_t linecap = 0;
            ssize_t length = 0;
            _memo_config = [MemoConfig new];
            if ((length = getline(&line, &linecap, stdin)) < 0) {
                perror("getline fail");
                exit(1);
            }
            
            NSString* inputLine = [[NSString stringWithUTF8String:line]
                                   stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            if ([inputLine length] == 0) {
                _memo_config.location = @DEFAULT_LOCATION;
            } else {
                _memo_config.location = inputLine;
            }
            
            NSData* encodedData = nil;
            switch (encodeChoice) {
                case EncodeOptionsBinaryPlist: {
                    NSKeyedArchiver* plistEncoder = [[NSKeyedArchiver alloc] initRequiringSecureCoding:YES];
                    [plistEncoder encodeObject:_memo_config forKey:@"location"];
                    encodedData = plistEncoder.encodedData;
                    break;
                }
                case EncodeOptionsJson: {
                    encodedData = [_memo_config toData:nil];
                    break;
                }
                default:
                    NSAssert(NO, @"Unknown Encode format!");
            }
            
            isE = [[NSFileManager defaultManager] fileExistsAtPath:memoconfigDir isDirectory:&isF];
            if (!isE || !isF) {
                NSError* createFolderErr = nil;
                [[NSFileManager defaultManager] createDirectoryAtPath:memoconfigDir
                                          withIntermediateDirectories:YES
                                                           attributes:nil
                                                                error:&createFolderErr];
                if (createFolderErr) {
                    printf("create %s fail\n", [@CONFIG_DIR UTF8String]);
                    exit(1);
                }
            }
            
            BOOL success = [[NSFileManager defaultManager] createFileAtPath:memoconfig
                                                                   contents:encodedData
                                                                 attributes:nil];
            if (!success) {
                printf("fail to create "CONFIG_PATH"!\n");
                exit(1);
            }
            
        } else {
            NSData* content = [NSData dataWithContentsOfFile:memoconfig];
            NSError* decodeError;
            
            switch (encodeChoice) {
                case EncodeOptionsBinaryPlist: {
                    NSKeyedUnarchiver* decoder = [[NSKeyedUnarchiver alloc] initForReadingFromData:content
                                                                                             error:&decodeError];
                    _memo_config = [[MemoConfig alloc] initWithCoder:decoder];
                    break;
                }
                case EncodeOptionsJson: {
                    _memo_config = MemoConfigFromData(content, &decodeError);
                    break;
                }
                default:
                    NSAssert(NO, @"Unknow Decode format!");
            }
        }
        
        _memo_config.path = memoconfig;
    });
    return _memo_config;
}

- (NSString*)path {
    return self.path?:@CONFIG_PATH;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#pragma mark - NSCoding
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.location = [aDecoder decodeObjectForKey:@"location"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.location forKey:@"location"];
}


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#pragma mark - NSSecureCoding
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ (BOOL)supportsSecureCoding {
    return YES;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#pragma mark - JSON methods
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+(NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
                                                    @"location": @"location",
                                                    };
}

+ (_Nullable instancetype)fromData:(NSData *)data error:(NSError *_Nullable *)error
{
    return MemoConfigFromData(data, error);
}

+ (_Nullable instancetype)fromJSON:(NSString *)json encoding:(NSStringEncoding)encoding error:(NSError *_Nullable *)error
{
    return MemoConfigFromJSON(json, encoding, error);
}

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict
{
    return dict ? [[MemoConfig alloc] initWithJSONDictionary:dict] : nil;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (NSDictionary *)JSONDictionary
{
    return [self dictionaryWithValuesForKeys:MemoConfig.properties.allValues];
}

- (NSData *_Nullable)toData:(NSError *_Nullable *)error
{
    return MemoConfigToData(self, error);
}

- (NSString *_Nullable)toJSON:(NSStringEncoding)encoding error:(NSError *_Nullable *)error
{
    return MemoConfigToJSON(self, encoding, error);
}

@end
