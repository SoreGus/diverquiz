//
//  Perguntas.m
//  MiniChallenge2
//
//  Created by Rodrigo Soldi Lopes on 05/05/14.
//  Copyright (c) 2014 RENANSANTOSSOARES. All rights reserved.
//

#import "Perguntas.h"

@implementation Perguntas
@synthesize pergunta, alternativa1, alternativa2, alternativa3, alternativa4, assunto, resposta;

-(id)initWithPergunta: (NSString *)p andAlternativa1: (NSString *)alt1 andAlternativa2: (NSString *)alt2 andAlternativa3: (NSString *)alt3 andAlternativa4: (NSString *)alt4 andAssunto: (NSString *) ass andResposta: (NSString *)resp{
    if (self = [super init]) {
        pergunta = p;
        alternativa1 = alt1;
        alternativa2 = alt2;
        alternativa3 = alt3;
        alternativa4 = alt4;
        assunto = ass;
        resposta = resp;
    }
    return self;
}
@end
