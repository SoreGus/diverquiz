//
//  Perguntas.h
//  MiniChallenge2
//
//  Created by Rodrigo Soldi Lopes on 05/05/14.
//  Copyright (c) 2014 RENANSANTOSSOARES. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Perguntas : NSObject
@property (strong, nonatomic) NSString *pergunta;
@property (strong, nonatomic) NSString *alternativa1;
@property (strong, nonatomic) NSString *alternativa2;
@property (strong, nonatomic) NSString *alternativa3;
@property (strong, nonatomic) NSString *alternativa4;
@property (strong, nonatomic) NSString *assunto;
@property (strong, nonatomic) NSString *resposta;

-(id)initWithPergunta: (NSString *)p andAlternativa1: (NSString *)alt1 andAlternativa2: (NSString *)alt2 andAlternativa3: (NSString *)alt3 andAlternativa4: (NSString *)alt4 andAssunto: (NSString *) ass andResposta: (NSString *)resp;
@end
