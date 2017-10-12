//
//  CAExporter.m
//  Keyframes Player
//
//  Created by Guilherme Rambo on 12/10/17.
//  Copyright © 2017 Guilherme Rambo. All rights reserved.
//

#import "CAExporter.h"

extern NSData *__nonnull CAEncodeLayerTreeWithInfo(CALayer *__nonnull rootLayer, id<NSCoding> __nullable info);
extern BOOL CAMLEncodeLayerTreeToPathWithInfo(CALayer *__nonnull rootLayer, NSString *__nonnull path, id<NSCoding> __nullable info);

NSString * const kCAExporterErrorDomain = @"br.com.guilhermerambo.CAExporter";

@implementation CAExporter
{
    __kindof CALayer *_rootLayer;
}

- (instancetype)initWithRootLayer:(__kindof CALayer *)rootLayer
{
    self = [super init];
    
    _rootLayer = rootLayer;
    
    return self;
}

- (BOOL)exportToFileAtURL:(NSURL *)url error:(NSError *__autoreleasing *)outError
{
    if ([url.pathExtension isEqualToString:@"caar"]) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:@{@"rootLayer": _rootLayer}];
        
        if (!data) {
            *outError = [NSError errorWithDomain:kCAExporterErrorDomain
                                            code:1
                                        userInfo:@{NSLocalizedDescriptionKey: @"Error encoding layer tree."}];
            
            return NO;
        }
        
        return [data writeToURL:url options:NSDataWritingAtomic error:outError];
    } else if ([url.pathExtension isEqualToString:@"ca"]) {
        BOOL r = CAMLEncodeLayerTreeToPathWithInfo(_rootLayer, url.path, nil);
        
        if (!r) {
            *outError = [NSError errorWithDomain:kCAExporterErrorDomain
                                            code:2
                                        userInfo:@{NSLocalizedDescriptionKey: @"Error writing CAML."}];
            return NO;
        } else {
            return YES;
        }
    } else {
        return NO;
    }
}

@end
