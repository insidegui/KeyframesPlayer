//
//  CAExporter.h
//  Keyframes Player
//
//  Created by Guilherme Rambo on 12/10/17.
//  Copyright © 2017 Guilherme Rambo. All rights reserved.
//

@import Cocoa;

@interface CAExporter : NSObject

- (instancetype __nonnull)initWithRootLayer:(__kindof CALayer *__nonnull)rootLayer;

- (BOOL)exportToFileAtURL:(NSURL *__nonnull)url error:(NSError **)outError;

@end
