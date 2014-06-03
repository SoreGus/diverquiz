//
//  MyScene.h
//  MiniChallenge2
//

//  Copyright (c) 2014 RENANSANTOSSOARES. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>


@interface MyScene : SKScene <UIGestureRecognizerDelegate>
{
    SKSpriteNode *bg;
    SKSpriteNode *planetaPlanta;
    NSMutableArray *planetas;
    NSInteger current;
    SKSpriteNode *planeta;
    SKSpriteNode *planetaAqueci;
    SKSpriteNode *planetaHumano;
    SKSpriteNode *planetaCont;
    SKSpriteNode *planetaAgua;
    SKSpriteNode *planetaSust;
    SKSpriteNode *botaoVoltar;
    SKSpriteNode *planetaBio;
    SKSpriteNode *planetaAstro;
    int screenCenter;
    BOOL criarNuvem;

}

@end
