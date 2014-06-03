//
//  Trofeus.m
//  MiniChallenge2
//
//  Created by Rodrigo Soldi Lopes on 12/05/14.
//  Copyright (c) 2014 RENANSANTOSSOARES. All rights reserved.
//

#import "Trofeus.h"

@implementation Trofeus
@synthesize nomeTrofeu;

-(id)initWithNomeTrofeu: (NSString *)nTrofeu{
    if (self = [super init]){
        nomeTrofeu = nTrofeu;
    }
    return self;
}
@end
