//
//  CenaQuiz.h
//  MiniChallenge2
//
//  Created by Gustavo Luís Soré on 03/05/14.
//  Copyright (c) 2014 RENANSANTOSSOARES. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface CenaQuiz : SKScene

@property (nonatomic) int assunto;

-(id)initWithSize:(CGSize)size andAssunto:(int )a;

@end
