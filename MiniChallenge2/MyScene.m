//
//  MyScene.m
//  MiniChallenge2
//
//  Created by Renan Santos Soares on 4/23/14.
//  Copyright (c) 2014 RENANSANTOSSOARES. All rights reserved.
//

#import "MyScene.h"
#import "CenaMenu.h"
#import "CenaQuiz.h"


@implementation MyScene
{
    CGPoint posicaoInicial;
    CGPoint posicaoNext;
    CGPoint posicaoPrevious;
    int selecionado;
    SKSpriteNode *texto;
    SKSpriteNode *escolhaMundo;
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        selecionado = 0;
        criarNuvem = true;
        /* Setup your scene here */
        
        //largura 768
        //altura 1024
        //container com pageview
        
        bg = [SKSpriteNode spriteNodeWithImageNamed:@"fundo.png"];
        bg.position = CGPointMake(self.frame.size.width/2,self.frame.size.height/2);
        bg.size = CGSizeMake(self.frame.size.width, self.frame.size.height);
        bg.userInteractionEnabled = NO;
        
        [self addChild:bg];
        
        botaoVoltar = [SKSpriteNode spriteNodeWithImageNamed:@"voltar.png"];
        botaoVoltar.position = CGPointMake(60, 70);
        botaoVoltar.name = @"voltar";
        botaoVoltar.userInteractionEnabled = NO;
    
        
        planetaPlanta = [SKSpriteNode spriteNodeWithImageNamed:@"planetaPlanta.png"];
        planetaPlanta.position = CGPointMake(self.frame.size.width/2,self.frame.size.height/2);
        planetaPlanta.userInteractionEnabled = NO;
        planetaPlanta.name = @"planetaPlanta";
        planetaPlanta.zPosition = 1;
        
        planetaSust = [SKSpriteNode spriteNodeWithImageNamed:@"planetaSustentavel2.png"];
        planetaSust.position = CGPointMake(self.frame.size.width + self.size.width, self.frame.size.height/2);
        planetaSust.name = @"planetaSust";
        planetaSust.userInteractionEnabled = NO;
        planetaSust.zPosition = 1;
        
        planetaAqueci = [SKSpriteNode spriteNodeWithImageNamed:@"mundoAquecimento.png"];
        planetaAqueci.position = CGPointMake(self.frame.size.width + self.size.width, self.frame.size.height/2);
        planetaAqueci.name = @"planetaAqueci";
        planetaAqueci.userInteractionEnabled = NO;
        planetaAqueci.zPosition = 1;
        
        planetaHumano = [SKSpriteNode spriteNodeWithImageNamed:@"planetaHumano3.png"];
        planetaHumano.position = CGPointMake(self.frame.size.width + self.size.width, self.frame.size.height/2);
        planetaHumano.name = @"planetaHumano";
        planetaHumano.userInteractionEnabled = NO;
        planetaAqueci.zPosition = 1;
        
        planetaAgua = [SKSpriteNode spriteNodeWithImageNamed:@"planetaAgua.png"];
        planetaAgua.position = CGPointMake(self.frame.size.width + self.size.width, self.frame.size.height/2);
        planetaAgua.name = @"planetaAgua";
        planetaAgua.userInteractionEnabled = NO;
        planetaAgua.zPosition  =1;
        
        planetaCont = [SKSpriteNode spriteNodeWithImageNamed:@"planetaContinente.png"];
        planetaCont.position = CGPointMake(self.frame.size.width + self.size.width, self.frame.size.height/2);
        planetaCont.name = @"planetaCont";
        planetaCont.userInteractionEnabled = NO;
        planetaCont.zPosition = 1;
        
        planetaBio = [SKSpriteNode spriteNodeWithImageNamed:@"planetaBiodivesidade.png"];
        planetaBio.position = CGPointMake(self.frame.size.width + self.size.width, self.frame.size.height/2);
        planetaBio.name = @"planetaBio";
        planetaBio.userInteractionEnabled  = NO;
        planetaBio.zPosition = 1;
        
        planetaAstro = [SKSpriteNode spriteNodeWithImageNamed:@"planetaAstronomia.png"];
        planetaAstro.position = CGPointMake(self.frame.size.width + self.size.width, self.frame.size.height/2);
        planetaAstro.name = @"planetaAstro";
        planetaAstro.userInteractionEnabled  = NO;
        planetaAstro.zPosition = 1;

        escolhaMundo = [SKSpriteNode spriteNodeWithImageNamed:@"escolhaMundo.png"];
        escolhaMundo.position = CGPointMake(400, 870);
        escolhaMundo.userInteractionEnabled  = NO;
        
        planetas = [[NSMutableArray alloc]initWithObjects:planetaPlanta,planetaAqueci,planetaHumano,planetaAgua,planetaSust,planetaAstro,planetaBio,planetaCont, nil];

        posicaoInicial = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        posicaoNext = CGPointMake(self.frame.size.width + self.size.width, self.frame.size.height/2);
        posicaoPrevious = CGPointMake(-500, self.frame.size.height/2);
        
        
        [self addChild:planetaPlanta];
        [self addChild:planetaAqueci];
        [self addChild:planetaHumano];
        [self addChild:planetaAgua];
        [self addChild:planetaSust];
        [self addChild:planetaCont];
        [self addChild:planetaBio];
        [self addChild:planetaAstro];
        [self addChild:botaoVoltar];
        [self addChild:escolhaMundo];
        
        
        
    
        screenCenter = self.frame.size.width/2;
        current = 0;
        
    
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if([node.name isEqualToString:@"voltar"]){
        SKView * skView = (SKView *)self.view;
        SKScene *menu = [[CenaMenu alloc]initWithSize:self.size];
        menu.scaleMode = SKSceneScaleModeAspectFill;
        SKTransition *transicao = [SKTransition fadeWithDuration:1.0];
        [skView presentScene:menu transition:transicao];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint local = [touch locationInView:self.view];
    if(local.x < screenCenter){
        SKAction *mover = [SKAction moveToX:local.x duration:0.1];
                [self.atual runAction:mover];
        SKAction *mover2 = [SKAction moveToX:(self.frame.size.width-130)+local.x duration:0.1];
        [self.next runAction:mover2];
    }
    else if(local.x > screenCenter){
        SKAction *mover = [SKAction moveToX:local.x duration:0.1];
        [self.atual runAction:mover];
        SKAction *mover2 = [SKAction moveToX:(-200)+(local.x-384) duration:0.1];
        [self.previous runAction:mover2];
    }
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint local = [touch locationInView:self.view];
    if(local.x < (self.size.width/2)-100){
        if(current<7) current++;
    }
   else if(local.x > (self.size.width/2)+100){
        if(current>0) current--;
    }
    else if(local.x > 310 && local.x < 560){
            SKView * skView = (SKView *)self.view;
            CenaQuiz *quiz = [[CenaQuiz alloc]initWithSize:self.size andAssunto:current];
            SKTransition *transicao = [SKTransition crossFadeWithDuration:1.0];
            [skView presentScene:quiz transition:transicao];
    }
    SKAction *mover = [SKAction moveToX:posicaoInicial.x duration:0.1];
    [self.atual runAction:mover];

    SKAction *mover2 = [SKAction moveToX:posicaoNext.x duration:0.2];
    [self.next runAction:mover2];

    SKAction *mover3 = [SKAction moveToX:posicaoPrevious.x duration:0.2];
    [self.previous runAction:mover3];

}

- ( void ) willMoveFromView: (SKView *) view {
    
    NSLog(@"Tela dos planetas saiu");
    
}

-(void)update:(CFTimeInterval)currentTime {
    [self criarPontosAleatoria];
    
    [texto removeFromParent];
    if ([self.atual.name isEqualToString:@"planetaPlanta"]) {
        texto = [SKSpriteNode spriteNodeWithImageNamed:@"textoPlanta"];
    }
    else if([self.atual.name isEqualToString:@"planetaAqueci"]){
        texto = [SKSpriteNode spriteNodeWithImageNamed:@"textoAquecimentoGlobal"];
    }
    else if ([self.atual.name isEqualToString:@"planetaHumano"]) {
        texto = [SKSpriteNode spriteNodeWithImageNamed:@"textoCorpoHumano"];
    }
    else if ([self.atual.name isEqualToString:@"planetaAgua"]) {
        texto = [SKSpriteNode spriteNodeWithImageNamed:@"textoAgua"];
    }
    else if ([self.atual.name isEqualToString:@"planetaCont"]) {
        texto = [SKSpriteNode spriteNodeWithImageNamed:@"textoContinente"];
    }
    else if([self.atual.name isEqualToString:@"planetaSust"]) {
        texto = [SKSpriteNode spriteNodeWithImageNamed:@"textoSustentabilidade"];
    }
    else if([self.atual.name isEqualToString:@"planetaBio"]) {
        texto = [SKSpriteNode spriteNodeWithImageNamed:@"textoBiodiversidade"];
    }
    else if([self.atual.name isEqualToString:@"planetaAstro"]) {
        texto = [SKSpriteNode spriteNodeWithImageNamed:@"textoAstronomia"];
    }
    texto.position = CGPointMake(self.frame.size.width/2, 205);
    texto.zPosition = 1;
    [self addChild:texto];
}

-(SKSpriteNode*)previous {
    if(current > 0) return [planetas objectAtIndex:current-1];
    return nil;
}

-(SKSpriteNode *)next {
    if(current < 7) return [planetas objectAtIndex:current+1];
    return nil;
}


-(SKSpriteNode *)atual {
    return [planetas objectAtIndex:current];
}

-(void) criarPontosAleatoria {
    if (!criarNuvem) {
        return;
    }
    
    GLint criar = [self getRandomNumberBetween:0 to:20];
    
    if (criar > 2) {
        return;
    }
    
    GLint escala;
    GLfloat velocidade;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        escala = [self getRandomNumberBetween:1 to:4];
        velocidade = 5 / escala;
    } else {
        escala = [self getRandomNumberBetween:1 to:1];
        velocidade = 9 / escala;
    }
    
    
    GLfloat yPosition = [self getRandomNumberBetween:0 to:self.frame.size.height];
    GLfloat alpha = 1.0;
    
    SKSpriteNode *estrela = [SKSpriteNode spriteNodeWithImageNamed:@"starPoint.png"];
    estrela.zPosition = 0;
    
    [estrela setXScale:escala];
    [estrela setYScale:escala];
    estrela.position = CGPointMake(self.frame.size.width+50, yPosition);
    [estrela setAlpha:alpha];
    [self addChild:estrela];
    
    SKAction *mover = [SKAction moveToX:-self.frame.size.width/2 duration:velocidade];
    SKAction *remover = [SKAction removeFromParent];
    
    [estrela runAction:[SKAction sequence:@[mover,remover]]];
}

-(int)getRandomNumberBetween:(int)from to:(int)to {
    return (int)from + arc4random() % (to-from+1);
}


@end
