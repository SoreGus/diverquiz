//
//  CenaTrofeus.m
//  MiniChallenge2
//
//  Created by Gustavo Luís Soré on 03/05/14.
//  Copyright (c) 2014 RENANSANTOSSOARES. All rights reserved.
//

#import "CenaTrofeus.h"
#import "CenaMenu.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "Trofeus.h"

@implementation CenaTrofeus{
    SKSpriteNode *estante;
    SKSpriteNode *trofeuEnergia;
    SKSpriteNode *trofeuCorpo;
    SKSpriteNode *trofeuContinete;
    SKSpriteNode *trofeuBiodiversidade;
    SKSpriteNode *trofeuAqueciento;
    SKSpriteNode *trofeuAgua;
    SKSpriteNode *trofeuPlanta;
    SKSpriteNode *trofeuAstronomia;
    SKSpriteNode *botaoVoltar;
    
    NSMutableArray *trofeus;
}

-(id)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]){
        
        estante = [self criaEstante];
        trofeuEnergia = [self criaTEnergia];
        trofeuCorpo = [self criaTCorpoHumano];
        trofeuContinete = [self criaTContinente];
        trofeuBiodiversidade = [self criaTBiodiversidade];
        trofeuAqueciento = [self criaTAquecimento];
        trofeuAgua = [self criaTAgua];
        trofeuPlanta = [self criaTPlanta];
        trofeuAstronomia = [self criaTAstronomia];
        botaoVoltar = [self criaVoltar];
        SKSpriteNode *fundo = [SKSpriteNode spriteNodeWithImageNamed:@"salaTrofeus.png"];
        fundo.position = CGPointMake(size.width/2, size.height/2);
        
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self addChild:fundo];
        [self addChild:estante];
        [self addChild:botaoVoltar];
        
        
        //POPULANDO ARRAY COM OS DADOS DO CORE DATA
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Trofeus" inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDesc];
        NSError *error;
        trofeus = [[context executeFetchRequest:request error:&error] mutableCopy];
        //------------------------------------------
        
        for (int i = 0; i < trofeus.count; i++) {
            if([[[trofeus objectAtIndex:i] nomeTrofeu] isEqualToString:@"planetaPlanta"]){
                [self addChild:trofeuPlanta];
            }
            if([[[trofeus objectAtIndex:i] nomeTrofeu] isEqualToString:@"planetaAquecimento"]){
                [self addChild:trofeuAqueciento];
            }
            if([[[trofeus objectAtIndex:i] nomeTrofeu] isEqualToString:@"planetaHumano"]){
                [self addChild:trofeuCorpo];
            }
            if([[[trofeus objectAtIndex:i] nomeTrofeu] isEqualToString:@"planetaAgua"]){
                [self addChild:trofeuAgua];
            }
            if([[[trofeus objectAtIndex:i] nomeTrofeu] isEqualToString:@"planetaSustentabilidade"]){
                [self addChild:trofeuEnergia];
            }
            if([[[trofeus objectAtIndex:i] nomeTrofeu] isEqualToString:@"planetaAstronomia"]){
                [self addChild:trofeuAstronomia];
            }
            if([[[trofeus objectAtIndex:i] nomeTrofeu] isEqualToString:@"planetaBiodiversidade"]){
                [self addChild:trofeuBiodiversidade];
            }
            if([[[trofeus objectAtIndex:i] nomeTrofeu] isEqualToString:@"planetaContinentes"]){
                [self addChild:trofeuContinete];
            }
        }
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
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

-(SKSpriteNode*)criaEstante{
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"estanteTrofeus.png"];
    node.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    node.name = @"estante";
    node.userInteractionEnabled = NO;
    return node;
}

-(SKSpriteNode*)criaTEnergia{
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"trofeuEnergiaSustentavel.png"];
    node.position = CGPointMake((self.frame.size.width/2)+138, (self.frame.size.height/2)+287);
    node.name = @"trofeuEnergia";
    node.userInteractionEnabled = NO;
    return node;
}

-(SKSpriteNode*)criaTCorpoHumano{
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"trofeuCorpoHumano.png"];
    node.position = CGPointMake((self.frame.size.width/2)-129, (self.frame.size.height/2)-256);
    node.name = @"trofeuCorpoHumano";
    node.userInteractionEnabled = NO;
    return node;
}

-(SKSpriteNode*)criaTContinente{
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"trofeuContinentes.png"];
    node.position = CGPointMake((self.frame.size.width/2)+137, (self.frame.size.height/2)-77);
    node.name = @"trofeuContinente";
    node.userInteractionEnabled = NO;
    return node;
}

-(SKSpriteNode*)criaTBiodiversidade{
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"trofeuBiodiversidade.png"];
    node.position = CGPointMake((self.frame.size.width/2)-131, (self.frame.size.height/2)-75);
    node.name = @"trofeuBiodiversidade";
    node.userInteractionEnabled = NO;
    return node;
}

-(SKSpriteNode*)criaTAquecimento{
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"trofeuAquecimentoGlobal.png"];
    node.position = CGPointMake((self.frame.size.width/2)-130, (self.frame.size.height/2)+98);
    node.name = @"trofeuAquecimento";
    node.userInteractionEnabled = NO;
    return node;
}

-(SKSpriteNode*)criaTAstronomia{
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"trofeuAstronomia.png"];
    node.position = CGPointMake((self.frame.size.width/2)+135, (self.frame.size.height/2)+98);
    node.name = @"trofeuAstronomia";
    node.userInteractionEnabled = NO;
    return node;
}

-(SKSpriteNode*)criaTAgua{
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"trofeuAgua.png"];
    node.position = CGPointMake((self.frame.size.width/2)-130, (self.frame.size.height/2)+283);
    node.name = @"trofeuAgua";
    node.userInteractionEnabled = NO;
    return node;
}

-(SKSpriteNode*)criaTPlanta{
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"trofeuPlanta.png"];
    node.position = CGPointMake((self.frame.size.width/2)+137, (self.frame.size.height/2)-256);
    node.name = @"trofeuPlanta";
    node.userInteractionEnabled = NO;
    return node;
}

-(SKSpriteNode*)criaVoltar{
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"voltar.png"];
    node.position = CGPointMake(60, 70);
    node.name = @"voltar";
    node.userInteractionEnabled = NO;
    return node;
}

@end
