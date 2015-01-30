//
//  ConfigurationManager.m
//  SPHBaseProject
//
//  Created by Siba Prasad Hota  on 1/30/15.
//  Copyright (c) 2015 wemakeappz. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ConfigurationManager.h"

#define ConfigurationOauthUrl        @"OauthUrl"
#define ConfigurationApiUrl          @"ApiUrl"
#define ConfigurationLoggingEnabled  @"LoggingEnabled"

@interface ConfigurationManager ()

@property (copy, nonatomic) NSString *configuration;
@property (nonatomic, strong) NSDictionary *variables;

@end

@implementation ConfigurationManager

#pragma mark -
#pragma mark Shared Configuration
+ (ConfigurationManager *)sharedConfiguration {
    static ConfigurationManager *_sharedConfiguration = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedConfiguration = [[self alloc] init];
    });
    
    return _sharedConfiguration;
}

#pragma mark -
#pragma mark Private Initialization
- (id)init {
    self = [super init];
    
    if (self) {
        // Fetch Current Configuration
        NSBundle *mainBundle = [NSBundle mainBundle];
        
        self.configuration = [[mainBundle infoDictionary] objectForKey:@"Configuration"];
        
        // Load Configurations
        NSString *path = [mainBundle pathForResource:@"Configurations" ofType:@"plist"];
        NSDictionary *configurations = [NSDictionary dictionaryWithContentsOfFile:path];
        
        // Load Variables for Current Configuration
        self.variables = [configurations objectForKey:self.configuration];
    }
    
    return self;
}

#pragma mark - Configuration
+ (NSString *)configuration {
    return [[ConfigurationManager sharedConfiguration] configuration];
}

#pragma mark - Urls
+ (NSString *)OauthUrl {
    ConfigurationManager *sharedConfiguration = [ConfigurationManager sharedConfiguration];
    
    if (sharedConfiguration.variables) {
        return [sharedConfiguration.variables objectForKey:ConfigurationOauthUrl];
    }
    
    return nil;
}

+(NSString *)ApiUrl
{
    ConfigurationManager *sharedConfiguration = [ConfigurationManager sharedConfiguration];
    
    if (sharedConfiguration.variables) {
        return [sharedConfiguration.variables objectForKey:ConfigurationApiUrl];
    }
    
    return nil;
}

#pragma mark - Logging
+ (BOOL)isLoggingEnabled{
    ConfigurationManager *sharedConfiguration = [ConfigurationManager sharedConfiguration];
    
    if (sharedConfiguration.variables) {
        return [[sharedConfiguration.variables objectForKey:ConfigurationLoggingEnabled] boolValue];
    }
    
    return NO;
}



@end
