//
//  CenaMenu.h
//  MiniChallenge2
//
//  Created by Gustavo Luís Soré on 02/05/14.
//  Copyright (c) 2014 RENANSANTOSSOARES. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface CenaMenu : SKScene{
}
@property (nonatomic) BOOL criarNuvem;

-(void) criarEstrelasAleatoria;
-(void)criaPontosAleatoria;
@end
