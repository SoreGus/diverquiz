//
//  SingleTrofeus.m
//  MiniChallenge2
//
//  Created by Rodrigo Soldi Lopes on 14/05/14.
//  Copyright (c) 2014 RENANSANTOSSOARES. All rights reserved.
//

#import "SingleTrofeus.h"
#import "Trofeus.h"

@implementation SingleTrofeus

- (id)init {
    self = [super init];
    if (self) {
        _trofeus = [[NSMutableArray alloc] init];
    }
    return self;
}


+ (SingleTrofeus *)sharedInstance {
    static SingleTrofeus *instance;
    if (!instance) {
        instance = [[self alloc] init];
    }
    return instance;
}


- (void)addTrofeuObject:(Trofeus *)object {
    [_trofeus addObject:object];
}


- (void)removeTrofeuObject:(Trofeus *)object {
    [_trofeus removeObject:object];
}


- (void)removeTrofeuAtIndex:(NSUInteger)index {
    [_trofeus removeObjectAtIndex:index];
}

@end
