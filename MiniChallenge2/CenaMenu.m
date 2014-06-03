//
//  CenaMenu.m
//  MiniChallenge2
//
//  Created by Gustavo Luís Soré on 02/05/14.
//  Copyright (c) 2014 RENANSANTOSSOARES. All rights reserved.
//

#import "CenaMenu.h"
#import "MyScene.h"
#import "CenaTrofeus.h"
#import "Ajuste.h"
#import "AppDelegate.h"


@implementation CenaMenu{
    SKSpriteNode *fundo;
    SKSpriteNode *botaoFases;
    SKSpriteNode *botaoTrofeus;
    SKSpriteNode *botaoConfig;
    SKSpriteNode *logo;
    
    BOOL som;
    
    
}

@synthesize criarNuvem;

-(id)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]){

        logo = [SKSpriteNode spriteNodeWithImageNamed:@"logo.png"];
        logo.position = CGPointMake(size.width/2, size.height-200);
        logo.zPosition = 1;
        [self setCriarNuvem:TRUE];
        
        
        fundo = [SKSpriteNode spriteNodeWithImageNamed:@"fundoMenu"];
        fundo.position = CGPointMake(self.frame.size.width/2, size.height/2);
        botaoConfig = [SKSpriteNode spriteNodeWithImageNamed:@"botaoAjustes.png"];
        botaoConfig.position = CGPointMake(self.frame.size.width/2, 300);
        botaoConfig.name =@"botaoAjuste";
        botaoConfig.zPosition = 2;
        [botaoConfig setZPosition:1];
        
        botaoFases = [self botaoFasesNode];
        [botaoFases setZPosition:1];
        botaoTrofeus = [self botaoTrofeusNode];
        
        [self configuracaoSom];
        
        [botaoTrofeus setZPosition:1];
        
        [self addChild:fundo];
        [self addChild:botaoFases];
        [self addChild:botaoTrofeus];
        [self addChild:botaoConfig];
        [self addChild:logo];
        
        self.view.scene.backgroundColor = [UIColor blackColor];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    SKTransition *transicao = [SKTransition crossFadeWithDuration:1.0];
    
    if([node.name isEqualToString:@"botaoFases"]){
        SKView * skView = (SKView *)self.view;
        MyScene *fases = [[MyScene alloc]initWithSize:self.size];
        fases.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:fases transition:transicao];
        
        [self.view presentScene:fases];
    }
    else if([node.name isEqualToString:@"botaoTrofeus"]){
        SKView * skView = (SKView *)self.view;
        SKScene *trofeus = [[CenaTrofeus alloc]initWithSize:self.size];
        trofeus.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:trofeus transition:transicao];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    SKTransition *transicao = [SKTransition crossFadeWithDuration:1.0];
    if([node.name isEqualToString:@"botaoFases"]){
        SKView * skView = (SKView *)self.view;
        MyScene *fases = [[MyScene alloc]initWithSize:self.size];
        fases.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:fases transition:transicao];
        
        [self.view presentScene:fases];
    }
    else if([node.name isEqualToString:@"botaoTrofeus"]){
        SKView * skView = (SKView *)self.view;
        SKScene *trofeus = [[CenaTrofeus alloc]initWithSize:self.size];
        trofeus.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:trofeus transition:transicao];
    }
    
        else if([node.name isEqualToString:@"botaoAjuste"]){
            SKView * skView = (SKView *)self.view;
            SKScene *trofeus = [[Ajuste alloc]initWithSize:self.size];
            trofeus.scaleMode = SKSceneScaleModeAspectFill;
            [skView presentScene:trofeus transition:transicao];
        }
    }


-(SKSpriteNode*)botaoFasesNode{
    
    SKSpriteNode *botao = [SKSpriteNode spriteNodeWithImageNamed:@"botaoJogar.png"];
    botao.position = CGPointMake(self.frame.size.width/2, 500);
    botao.name = @"botaoFases";
    botao.zPosition = 5;
    return botao;
}

-(SKSpriteNode*)botaoTrofeusNode{
    
    SKSpriteNode *botao = [SKSpriteNode spriteNodeWithImageNamed:@"botaoTrofeus.png"];
    botao.position = CGPointMake(self.frame.size.width/2, 400);
    botao.name = @"botaoTrofeus";
    botao.zPosition = 5;
    return botao;
}

- ( void ) willMoveFromView: (SKView *) view {
    NSLog(@"Scene moved from view");    
    //[view removeGestureRecognizer: swipeLeftGesture ];
}

-(void)update:(CFTimeInterval)currentTime {
    
    //[self criarEstrelasAleatoria];
    [self criarPontosAleatoria];
}

-(void) criarEstrelasAleatoria {
    if (!criarNuvem) {
        return;
    }
    
    GLint criar = [self getRandomNumberBetween:0 to:100];
    
    if (criar > 2) {
        return;
    }
    
    GLint escala;
    GLfloat velocidade;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        escala = [self getRandomNumberBetween:1 to:4];
        velocidade = 5 / escala;
    } else {
        escala = [self getRandomNumberBetween:1 to:2];
        velocidade = 6 / escala;
    }
    
    
    GLfloat yPosition = [self getRandomNumberBetween:0 to:self.frame.size.height];
    GLfloat alpha = 1.0;
    
    SKSpriteNode *estrela = [SKSpriteNode spriteNodeWithImageNamed:@"star.png"];
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

-(void) criarPontosAleatoria {
    if (!criarNuvem) {
        return;
    }
    
    GLint criar = [self getRandomNumberBetween:0 to:10];
    
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
        velocidade = 8 / escala;
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


-(void)configuracaoSom{
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    som = [defaults boolForKey:@"somAtivo"];
    
    //IF PARA VERIFICAR SE O SOM ESTA ATIVO OU NAO
    if (som) {
        [[app player] play];
    }else{
        [[app player] stop];
    }
}

@end
