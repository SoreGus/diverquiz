//
//  SingleTrofeus.h
//  MiniChallenge2
//
//  Created by Rodrigo Soldi Lopes on 14/05/14.
//  Copyright (c) 2014 RENANSANTOSSOARES. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Trofeus.h"

@interface SingleTrofeus : NSObject
@property NSMutableArray *trofeus;


+ (SingleTrofeus *)sharedInstance;
- (void)addTrofeuObject:(Trofeus *)object;
- (void)removeTrofeuObject:(Trofeus *)object;
- (void)removeTrofeuAtIndex:(NSUInteger)index;

@end
