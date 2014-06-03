//
//  Ajuste.m
//  MiniChallenge2
//
//  Created by Renan Santos Soares on 5/12/14.
//  Copyright (c) 2014 RENANSANTOSSOARES. All rights reserved.
//

#import "Ajuste.h"
#import "AppDelegate.h"
#import "CenaMenu.h"
AppDelegate *appDelegate;
SKLabelNode *fasesLabel;
SKSpriteNode *onOff;
SKSpriteNode *off;
BOOL ligado;
SKSpriteNode *fundo;
SKSpriteNode *botaoVoltar;
BOOL som;
@implementation Ajuste

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
    
      appDelegate = [[UIApplication sharedApplication] delegate];
        onOff = [self somOnOffNode];
        //[self addChild:onOff];
        ligado = TRUE;
        
        off = [SKSpriteNode spriteNodeWithImageNamed:@"audioOff.png"];
        off.name = @"off";
        off.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        
        botaoVoltar = [SKSpriteNode spriteNodeWithImageNamed:@"voltar.png"];
        
        botaoVoltar.position = CGPointMake(60, 70);
        botaoVoltar.name = @"back";
        
        fundo = [SKSpriteNode spriteNodeWithImageNamed:@"fundoAjustes.png"];
        fundo.position = CGPointMake(size.width/2, size.height/2);
        
        [self addChild:fundo];
        [self addChild:onOff];
        [self addChild:off];
        
        NSUserDefaults *audio = [NSUserDefaults standardUserDefaults];
        som = [audio boolForKey:@"somAtivo"];
        if (som) {
            ligado = YES;
            off.hidden = YES;
        }else{
            
            ligado = NO;
            off.hidden = NO;
        }

        [self addChild:botaoVoltar];
    }
    return self;
}

-(SKSpriteNode*)somOnOffNode{
    
    SKSpriteNode *botao = [SKSpriteNode spriteNodeWithImageNamed:@"audio.png"];
    botao.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    botao.name = @"botaoOnOff";
    return botao;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint local = [touch locationInNode:self];
    
    SKNode *node = [self nodeAtPoint:local ];
    
    if([node.name isEqualToString:@"botaoOnOff"] || [node.name isEqualToString:@"off"]) {
        
        if (ligado) {
            
            [appDelegate.player stop];
            off.hidden = NO;
            fasesLabel.text = @"Audio Desligado";
            ligado = FALSE;
            
            NSLog(@"pausado");
        }
        else
        { [appDelegate.player play];
            off.hidden = YES;
            fasesLabel.text = @"Audio Ligado";
        ligado = TRUE;
        
        NSLog(@"continua");
        }
        
    }
    if([node.name isEqualToString:@"back"]){
        [self configuracaoSom];
        SKView * skView = (SKView *)self.view;
        SKScene *menu = [[CenaMenu alloc]initWithSize:self.size];
        menu.scaleMode = SKSceneScaleModeAspectFill;
        SKTransition *transicao = [SKTransition fadeWithDuration:1.0];
        [skView presentScene:menu transition:transicao];
    }

}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
   
    
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
   
    
}

-(void)configuracaoSom{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *som = @"somAtivo";
    
    //IF PARA VERIFICAR SE O SOM ESTA ATIVO OU NAO
    if (off.hidden) {
        [defaults setBool:YES forKey:som];
    }else{
        [defaults setBool:NO forKey:som];
    }

    [defaults synchronize];
}


@end
