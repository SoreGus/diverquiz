//

//  CenaQuiz.m

//  MiniChallenge2

//

//  Created by Gustavo Luís Soré on 03/05/14.

//  Copyright (c) 2014 RENANSANTOSSOARES. All rights reserved.

//



#import "CenaQuiz.h"
#import "MyScene.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "Perguntas.h"
#import "Trofeus.h"
#import "SingleTrofeus.h"

@implementation CenaQuiz{
    NSMutableArray *arrayPosicoes;
    NSMutableArray *perguntas;
    NSMutableArray *trofeus;
    
    SKSpriteNode *fundoMapa;
    SKSpriteNode *fundoPerguntas;
    SKSpriteNode *botaoVoltar;
    SKSpriteNode *avatar;
    SKSpriteNode *trofeu;
    SKSpriteNode *proximaPergunta;
    SKSpriteNode *pontos;
    SKSpriteNode *spriteFundoRespostaA;
    SKSpriteNode *spriteFundoRespostaB;
    SKSpriteNode *spriteFundoRespostaC;
    SKSpriteNode *spriteFundoRespostaErradaA;
    SKSpriteNode *spriteFundoRespostaErradaB;
    SKSpriteNode *spriteFundoRespostaErradaC;
    
    
    SKLabelNode *mapaLabel;
    SKLabelNode *perguntasLabel;
    SKLabelNode *alternativa1;
    SKLabelNode *alternativa2;
    SKLabelNode *alternativa3;
    SKLabelNode *alternativa4;
    SKLabelNode *acertouPergunta;
    SKLabelNode *continuaPerguntaLabel;
    SKLabelNode *continuaAlternativa1;
    SKLabelNode *continuaAlternativa2;
    SKLabelNode *continuaAlternativa3;
    
    NSNumber *posX;
    NSNumber *posY;
    
    BOOL andou;
    
    int posicaoAtual;
    int indicePergunta;
    int opcao;
    int pontosConquistados;
    
    Perguntas *p;
}

@synthesize assunto;

-(id)initWithSize:(CGSize)size{
    
    if (self = [super initWithSize:size]) {
        [self escolheTrofeu];
        [self desenhaAvatar];
        [self criaArrayPosicoes];
        opcao = 0;

        
        perguntas = [NSMutableArray new];
        
        posicaoAtual = 0;
        self.backgroundColor = [UIColor whiteColor];
        
        fundoMapa = [SKSpriteNode spriteNodeWithImageNamed:@"fundoMapa.png"];
        fundoMapa.position = CGPointMake(size.width/2, size.height-200);
        
        fundoPerguntas = [SKSpriteNode spriteNodeWithImageNamed:@"fundoPerguntas.png"];;
        fundoPerguntas.position = CGPointMake(size.width/2, (size.height-400)-(size.height-400)/2);
        
        
        SKSpriteNode * palavraPontos = [SKSpriteNode spriteNodeWithImageNamed:@"pontos.png"];
        palavraPontos.position = CGPointMake(685, 740);
        
        botaoVoltar = [SKSpriteNode spriteNodeWithImageNamed:@"voltar.png"];
        
        botaoVoltar.position = CGPointMake(60, 70);
        botaoVoltar.name = @"voltar";
        botaoVoltar.userInteractionEnabled = NO;
        
        proximaPergunta = [SKSpriteNode spriteNodeWithImageNamed:@"Certo.png"];
        proximaPergunta.position = CGPointMake(660, 70);
        proximaPergunta.name = @"proxima";
        proximaPergunta.userInteractionEnabled = NO;

        acertouPergunta = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        acertouPergunta.fontColor = [UIColor brownColor];
        acertouPergunta.fontSize = 30.0;
        acertouPergunta.position = CGPointMake(fundoPerguntas.position.x, fundoPerguntas.position.y-280);
        acertouPergunta.text = @"RESPOSTA CERTA";
        acertouPergunta.hidden = YES;
        
        //fundos das respostas
        spriteFundoRespostaA = [SKSpriteNode spriteNodeWithImageNamed:@"opcaoImage.png"];
        spriteFundoRespostaB = [SKSpriteNode spriteNodeWithImageNamed:@"opcaoImage.png"];
        spriteFundoRespostaC = [SKSpriteNode spriteNodeWithImageNamed:@"opcaoImage.png"];
        
        spriteFundoRespostaA.name = @"opcaoA";
        spriteFundoRespostaB.name = @"opcaoB";
        spriteFundoRespostaC.name = @"opcaoC";
        ///////////////////
        
        //fundos das respostas erradas
        spriteFundoRespostaErradaA = [SKSpriteNode spriteNodeWithImageNamed:@"opcaoImageWrong.png"];
        spriteFundoRespostaErradaB = [SKSpriteNode spriteNodeWithImageNamed:@"opcaoImageWrong.png"];
        spriteFundoRespostaErradaC = [SKSpriteNode spriteNodeWithImageNamed:@"opcaoImageWrong.png"];
        
        spriteFundoRespostaErradaA.name = @"opcaoAErrada";
        spriteFundoRespostaErradaB.name = @"opcaoBErrada";
        spriteFundoRespostaErradaC.name = @"opcaoCErrada";
        ///////////////////
        
        proximaPergunta.hidden = YES;
        
        [self desenhaPerguntas];
        
        pontosConquistados = 0;
        
        [self addChild:fundoMapa];
        [self addChild:fundoPerguntas];
        [self addChild:botaoVoltar];
        [self addChild:proximaPergunta];
        [self addChild:trofeu];
        [self addChild:avatar];
        [self addChild:acertouPergunta];
        [self addChild:spriteFundoRespostaErradaA];
        [self addChild:spriteFundoRespostaErradaB];
        [self addChild:spriteFundoRespostaErradaC];
        [self addChild:spriteFundoRespostaA];
        [self addChild:spriteFundoRespostaB];
        [self addChild:spriteFundoRespostaC];

        
        [self addChild:palavraPontos];
        
        
        //POPULANDO ARRAY COM OS DADOS DO CORE DATA
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Perguntas" inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDesc];
        NSError *error;
        
        NSPredicate *pred;
        switch(assunto){
                //planta
            case 0:
                pred = [NSPredicate predicateWithFormat:@"(assunto = %@)",@"planetaPlanta"];break;
                //aquecimento
            case 1:
                pred = [NSPredicate predicateWithFormat:@"(assunto = %@)",@"planetaAquecimento"];break;
                //humano
            case 2:
                pred = [NSPredicate predicateWithFormat:@"(assunto = %@)",@"planetaHumano"];break;
                //agua
            case 3:
                pred = [NSPredicate predicateWithFormat:@"(assunto = %@)",@"planetaAgua"];break;
                //sustentabilidade
            case 4:
                pred = [NSPredicate predicateWithFormat:@"(assunto = %@)",@"planetaSustentabilidade"];break;
                //astronomia
            case 5:
                pred = [NSPredicate predicateWithFormat:@"(assunto = %@)",@"planetaAstronomia"];break;
                //biodiversidade
            case 6:
                pred = [NSPredicate predicateWithFormat:@"(assunto = %@)",@"planetaBiodiversidade"];break;
                //continentes
            case 7:
                pred = [NSPredicate predicateWithFormat:@"(assunto = %@)",@"planetaContinentes"];break;
            default: break;
                
        }
        
        [request setPredicate:pred];
        
        perguntas = [[context executeFetchRequest:request error:&error] mutableCopy];
        
        //------------------------------------------
        
        [self pergunta:fundoPerguntas];
        [self desenhaOpcoesNovo];
        
        [appDelegate.player stop];
    }
    
    return self;
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if([node.name isEqualToString:@"voltar"]){
        SKView * skView = (SKView *)self.view;
        SKScene *menu = [[MyScene alloc]initWithSize:self.size];
        menu.scaleMode = SKSceneScaleModeAspectFill;
        SKTransition *transicao = [SKTransition fadeWithDuration:1.0];
        [skView presentScene:menu transition:transicao];
    }
    
    if([node.name isEqualToString:@"alternativa1"] || [node.name isEqualToString:@"opcaoA"]){
            opcao = 1;
        [self checaResposta];
    }
    
    if([node.name isEqualToString:@"alternativa2"] || [node.name isEqualToString:@"opcaoB"]){
            opcao = 2;
        [self checaResposta];
    }
    
    if([node.name isEqualToString:@"alternativa3"] || [node.name isEqualToString:@"opcaoC"]){
            opcao = 3;
        [self checaResposta];
    }

}

-(void)checaResposta{
    SKAction *somAcerto = [SKAction playSoundFileNamed:@"kids.mp3" waitForCompletion:YES];
    if(opcao == 1){
        if ([[alternativa1.text substringToIndex:1] isEqualToString: [[[perguntas objectAtIndex:indicePergunta] resposta] uppercaseString]]) {
            //SE ACERTOU A PERGUNTA
            [perguntas removeObjectAtIndex:indicePergunta];
            acertouPergunta.hidden = NO;
            
            [self runAction:somAcerto];
            if (!andou) {
                [self proximaPosicao];
                andou = YES;
                pontosConquistados++;
            }
            [self removePergunta];
        }
        
        
        else {
            //SE ERROU A PERGUNTA
            [self errouPergunta];
        }
    }
    else if(opcao == 2){
        if ([[alternativa2.text substringToIndex:1] isEqualToString: [[[perguntas objectAtIndex:indicePergunta] resposta] uppercaseString]]) {
            //SE ACERTOU A PERGUNTA
            [perguntas removeObjectAtIndex:indicePergunta];
            acertouPergunta.hidden = NO;
            [self runAction:somAcerto];
            
            if (!andou) {
                [self proximaPosicao];
                andou = YES;
                pontosConquistados++;
            }
            [self removePergunta];
            
        }
        else{
            //SE ERROU A PERGUNTA
            [self errouPergunta];
        }
    }
    else if(opcao == 3){
        if ([[alternativa3.text substringToIndex:1] isEqualToString: [[[perguntas objectAtIndex:indicePergunta] resposta] uppercaseString]]) {
            //SE ACERTOU A PERGUNTA
            [perguntas removeObjectAtIndex:indicePergunta];
            acertouPergunta.hidden = NO;
            [self runAction:somAcerto];
            
            if (!andou) {
                [self proximaPosicao];
                andou = YES;
                pontosConquistados++;
            }
            [self removePergunta];
        }
        else{
            //SE ERROU A PERGUNTA
            [self errouPergunta];
        }
    }
}

-(void)voltaAzul{
    spriteFundoRespostaA.hidden = NO;
    spriteFundoRespostaB.hidden = NO;
    spriteFundoRespostaC.hidden = NO;
}

-(void)errouPergunta{
    switch (opcao) {
        case 1: spriteFundoRespostaA.hidden = YES;
            break;
        case 2: spriteFundoRespostaB.hidden = YES;
            break;
        case 3: spriteFundoRespostaC.hidden = YES;
            break;
        default:
            break;
    }
    acertouPergunta.color = [UIColor redColor];
    acertouPergunta.text = @"Alternativa errada!";
    acertouPergunta.hidden = NO;
    pontosConquistados--;
    if (pontosConquistados < 0) {
        pontosConquistados = 0;
    }
    SKAction *somErro = [SKAction playSoundFileNamed:@"erro.mp3" waitForCompletion:YES];
    [self runAction:somErro];
    [self mudaPontos];
}

-(id)initWithSize:(CGSize)size andAssunto:(int )a{
    self.assunto = a;
    self = [self initWithSize:size];
    return self;
}

-(void)escondeOpcao{
    spriteFundoRespostaA.hidden = YES;
    spriteFundoRespostaB.hidden = YES;
    spriteFundoRespostaC.hidden = YES;
    spriteFundoRespostaErradaA.hidden = YES;
    spriteFundoRespostaErradaB.hidden = YES;
    spriteFundoRespostaErradaC.hidden = YES;
    acertouPergunta.hidden = YES;
}

-(void)removePergunta{
    [self voltaAzul];
    [perguntasLabel removeFromParent];
    [continuaPerguntaLabel removeFromParent];
    [alternativa1 removeFromParent];
    [alternativa2 removeFromParent];
    [alternativa3 removeFromParent];
    [alternativa4 removeFromParent];
    [continuaAlternativa1 removeFromParent];
    [continuaAlternativa2 removeFromParent];
    [continuaAlternativa3 removeFromParent];
    [self pergunta:fundoPerguntas];
}

-(void)desenhaPerguntas{//usar apenas uma vez no initWithSize
    
    //PERGUNTA
    perguntasLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    perguntasLabel.fontColor = [UIColor blackColor];
    perguntasLabel.fontSize = 24.0;
    perguntasLabel.position= CGPointMake(fundoPerguntas.position.x, fundoPerguntas.position.y+255);
    
    continuaPerguntaLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    continuaPerguntaLabel.fontColor = [UIColor blackColor];
    continuaPerguntaLabel.fontSize = 24.0;
    continuaPerguntaLabel.position= CGPointMake(fundoPerguntas.position.x, fundoPerguntas.position.y+230);
 
    //ALTERNATIVAS
    alternativa1 = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    alternativa1.fontColor = [UIColor whiteColor];
    alternativa1.fontSize = 22.0;
    alternativa1.position = CGPointMake(fundoPerguntas.position.x, fundoPerguntas.position.y+160);
    
    continuaAlternativa1 = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    continuaAlternativa1.fontColor = [UIColor whiteColor];
    continuaAlternativa1.fontSize = 22.0;
    continuaAlternativa1.position = CGPointMake(fundoPerguntas.position.x, fundoPerguntas.position.y+135);
    
    alternativa2 = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    alternativa2.fontColor = [UIColor whiteColor];
    alternativa2.fontSize = 22.0;
    alternativa2.position = CGPointMake(fundoPerguntas.position.x, fundoPerguntas.position.y+40);
    
    continuaAlternativa2 = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    continuaAlternativa2.fontColor = [UIColor whiteColor];
    continuaAlternativa2.fontSize = 22.0;
    continuaAlternativa2.position = CGPointMake(fundoPerguntas.position.x, fundoPerguntas.position.y+15);
    
    alternativa3 = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    alternativa3.fontColor = [UIColor whiteColor];
    alternativa3.fontSize = 22.0;
    alternativa3.position = CGPointMake(fundoPerguntas.position.x, fundoPerguntas.position.y-80);
    
    continuaAlternativa3 = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    continuaAlternativa3.fontColor = [UIColor whiteColor];
    continuaAlternativa3.fontSize = 22.0;
    continuaAlternativa3.position = CGPointMake(fundoPerguntas.position.x, fundoPerguntas.position.y-105);
    
    alternativa4 = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    alternativa4.fontColor = [UIColor blueColor];
    alternativa4.fontSize = 22.0;
    alternativa4.position = CGPointMake(fundoPerguntas.position.x, fundoPerguntas.position.y-200);
    
    perguntasLabel.name = @"pergunta";
    continuaPerguntaLabel.name = @"continauPergunta";
    alternativa1.name = @"alternativa1";
    alternativa2.name = @"alternativa2";
    alternativa3.name = @"alternativa3";
    alternativa4.name = @"alternativa4";
    continuaAlternativa1.name = @"continuaAlternativa1";
    continuaAlternativa2.name = @"continuaAlternativa2";
    continuaAlternativa3.name = @"continuaAlternativa3";
}

-(void)pergunta: (SKSpriteNode *)fundoPerguntas{
    if ([perguntas count] <= 0 && pontosConquistados == 10) {
        [self mudaPontos];
        NSLog(@"%d",pontosConquistados);
        SKAction *mover = [SKAction moveTo:CGPointMake(self.size.width/2, self.size.height/2-100) duration:1.0];
        SKAction *crescer = [SKAction scaleBy:2.0 duration:1.0];
        SKAction *group = [SKAction group:@[mover,crescer]];
        
        [trofeu runAction:group];
        [self salvarTrofeu];
        [self escondeOpcao];
        return;
    }
    else if ([perguntas count] <=0 && pontosConquistados < 10){
        SKLabelNode * labelSorry = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        labelSorry.text =  [NSString stringWithFormat:@"Parábens você fez %d pontos",pontosConquistados - 1];
        labelSorry.position = CGPointMake(self.size.width/2, self.size.height/2-100);
        labelSorry.fontColor = [UIColor redColor];
        
        SKLabelNode * labelSorry3= [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        labelSorry3.text = @"Para ganhar o troféu você precisa de 10 pontos.";
        labelSorry3.position = CGPointMake(self.size.width/2, self.size.height/2-130);
           labelSorry3.fontColor = [UIColor redColor];

        SKLabelNode * labelSorry2= [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        labelSorry2.text = @"Tente novamente!";
           labelSorry2.fontColor = [UIColor redColor];
        labelSorry2.position = CGPointMake(self.size.width/2, self.size.height/2-160);
        [self addChild:labelSorry];
        [self addChild:labelSorry3];
        [self addChild:labelSorry2];
        [self escondeOpcao];
        return;
    }
    [self mudaPontos];
    acertouPergunta.hidden = YES;
    proximaPergunta.hidden = YES;
    andou = NO;
    indicePergunta = arc4random()%[perguntas count];
    p = [perguntas objectAtIndex:indicePergunta];
    
    //CONFIGURACOES
    
    //PERGUNTA
    int aux = 0;
    NSString *p1;
    NSString *p2;
    if(p.pergunta.length > 60){
        aux = 60;
        if([p.pergunta characterAtIndex:aux] != ' '){
            aux = 59;
            while([p.pergunta characterAtIndex:aux] != ' ') aux--;
        }
        p1 = [p.pergunta substringToIndex:aux];
        p2 = [p.pergunta substringFromIndex:aux];
        perguntasLabel.text = p1;
        continuaPerguntaLabel.text = p2;
    }
    else{
        perguntasLabel.text = p.pergunta;
        continuaPerguntaLabel.text = @"";
    }
    
    
    //ALTERNATIVAS
    if(p.alternativa1.length > 60){
        aux = 60;
        if([p.alternativa1 characterAtIndex:aux] != ' '){
            aux = 59;
            while ([p.alternativa1 characterAtIndex:aux] != ' ')aux--;
        }
        p1 = [p.alternativa1 substringToIndex:aux];
        p2 = [p.alternativa1 substringFromIndex:aux];
        alternativa1.text = [@"A. " stringByAppendingString: p1];
        continuaAlternativa1.text = p2;
    }
    else{
        alternativa1.text = [@"A. " stringByAppendingString: p.alternativa1];
        continuaAlternativa1.text = @"";
    }
    
    if(p.alternativa2.length > 60){
        aux = 60;
        if([p.alternativa2 characterAtIndex:aux] != ' '){
            aux = 59;
            while ([p.alternativa2 characterAtIndex:aux] != ' ')aux--;
        }
        p1 = [p.alternativa2 substringToIndex:aux];
        p2 = [p.alternativa2 substringFromIndex:aux];
        alternativa2.text = [@"B. " stringByAppendingString: p1];
        continuaAlternativa2.text = p2;
    }
    else{
        alternativa2.text = [@"B. " stringByAppendingString: p.alternativa2];
        continuaAlternativa2.text = @"";
    }
    
    if(p.alternativa3.length > 60){
        aux = 60;
        if([p.alternativa3 characterAtIndex:aux] != ' '){
            aux = 59;
            while ([p.alternativa3 characterAtIndex:aux] != ' ')aux--;
        }
        p1 = [p.alternativa3 substringToIndex:aux];
        p2 = [p.alternativa3 substringFromIndex:aux];
        alternativa3.text = [@"C. " stringByAppendingString: p1];
        continuaAlternativa3.text = p2;
    }
    else{
        alternativa3.text = [@"C. " stringByAppendingString: p.alternativa3];
        continuaAlternativa3.text = @"";
    }
    
    [self addChild:perguntasLabel];
    [self addChild:continuaPerguntaLabel];
    [self addChild:alternativa1];
    [self addChild:alternativa2];
    [self addChild:alternativa3];
    [self addChild:alternativa4];
    [self addChild:continuaAlternativa1];
    [self addChild:continuaAlternativa2];
    [self addChild:continuaAlternativa3];
}

-(void)escolheTrofeu{
    
    switch (assunto) {
        case 0: trofeu = [SKSpriteNode spriteNodeWithImageNamed:@"trofeuPlanta.png"];break;
        case 1: trofeu = [SKSpriteNode spriteNodeWithImageNamed:@"trofeuAquecimentoGlobal.png"];break;
        case 2: trofeu = [SKSpriteNode spriteNodeWithImageNamed:@"trofeuCorpoHumano.png"];break;
        case 3: trofeu = [SKSpriteNode spriteNodeWithImageNamed:@"trofeuAgua.png"];break;
        case 4: trofeu = [SKSpriteNode spriteNodeWithImageNamed:@"trofeuEnergiaSustentavel.png"];break;
        case 5: trofeu = [SKSpriteNode spriteNodeWithImageNamed:@"trofeuAstronomia.png"];break;
        case 6: trofeu = [SKSpriteNode spriteNodeWithImageNamed:@"trofeuBiodiversidade.png"];break;
        case 7: trofeu = [SKSpriteNode spriteNodeWithImageNamed:@"trofeuContinentes.png"];break;
        default:break;
    }
    trofeu.position = CGPointMake(self.size.width-100, self.size.height-150);
}

-(void)desenhaAvatar{//usar apenas uma vez para desenhar o avatar
    
    avatar = [SKSpriteNode spriteNodeWithImageNamed:@"avatar.png"];
    
    avatar.position = CGPointMake(41, 818);
}

-(void)criaArrayPosicoes{
    arrayPosicoes = [[NSMutableArray alloc] init];
    [arrayPosicoes addObject:@141];
    [arrayPosicoes addObject:@676];
    [arrayPosicoes addObject:@282];
    [arrayPosicoes addObject:@673];
    [arrayPosicoes addObject:@213];
    [arrayPosicoes addObject:@807];
    [arrayPosicoes addObject:@168];
    [arrayPosicoes addObject:@934];
    [arrayPosicoes addObject:@339];
    [arrayPosicoes addObject:@893];
    [arrayPosicoes addObject:@369];
    [arrayPosicoes addObject:@759];
    [arrayPosicoes addObject:@470];
    [arrayPosicoes addObject:@675];
    [arrayPosicoes addObject:@471];
    [arrayPosicoes addObject:@892];
    [arrayPosicoes addObject:@575];
    [arrayPosicoes addObject:@838];
    [arrayPosicoes addObject:@670];
    [arrayPosicoes addObject:@838];
}

-(void)proximaPosicao{
    posX = [arrayPosicoes objectAtIndex:0+posicaoAtual];
    posY = [arrayPosicoes objectAtIndex:1+posicaoAtual];
    
    SKAction *mover = [SKAction moveToX:[posX integerValue] duration:1.5];
    SKAction *mover2 = [SKAction moveToY:[posY integerValue] duration:1.5];
    SKAction *pular = [SKAction moveByX:20 y:0 duration:0.5];
    SKAction *sequence = [SKAction group:@[mover,mover2,pular]];

    [avatar runAction:sequence];

    if(posicaoAtual < arrayPosicoes.count-2)posicaoAtual += 2;
    
}

-(void)desenhaOpcoesNovo{
    spriteFundoRespostaA.position = CGPointMake(self.size.width/2, alternativa1.position.y-8);
    spriteFundoRespostaB.position = CGPointMake(alternativa2.position.x, alternativa2.position.y-8);
    spriteFundoRespostaC.position = CGPointMake(alternativa3.position.x, alternativa3.position.y-8);
    
    spriteFundoRespostaErradaA.position = CGPointMake(self.size.width/2, alternativa1.position.y-8);
    spriteFundoRespostaErradaB.position = CGPointMake(alternativa2.position.x, alternativa2.position.y-8);
    spriteFundoRespostaErradaC.position = CGPointMake(alternativa3.position.x, alternativa3.position.y-8);
}

-(void)salvarTrofeu{
    if ([self trofeuJaExiste]) {
    NSString *tr;
    NSError *error;
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [app managedObjectContext];
    switch(assunto){
            //planta
        case 0:
            tr = @"planetaPlanta";break;
            //aquecimento
        case 1:
            tr = @"planetaAquecimento";break;
            //humano
        case 2:
            tr = @"planetaHumano";break;
            //agua
        case 3:
            tr = @"planetaAgua";break;
            //sustentabilidade
        case 4:
            tr = @"planetaSustentabilidade";break;
            //astronomia
        case 5:
            tr = @"planetaAstronomia";break;
            //biodiversidade
        case 6:
            tr = @"planetaBiodiversidade";break;
            //continentes
        case 7:
            tr = @"planetaContinentes";break;
        default: break;
            
    }
    Trofeus *t1 = [NSEntityDescription insertNewObjectForEntityForName:@"Trofeus" inManagedObjectContext:context];
    [t1 setNomeTrofeu:tr];
    SingleTrofeus *single = [SingleTrofeus sharedInstance];
    [single addTrofeuObject:t1];
    [context save:&error];
}
}

-(void)mudaPontos{
    [pontos removeFromParent];
    switch (pontosConquistados) {
        case 0:
            pontos = [SKSpriteNode spriteNodeWithImageNamed:@"0.png"];
            break;
        case 1:
            pontos = [SKSpriteNode spriteNodeWithImageNamed:@"1.png"];
            break;
        case 2:
            pontos = [SKSpriteNode spriteNodeWithImageNamed:@"2.png"];
            break;
        case 3:
            pontos = [SKSpriteNode spriteNodeWithImageNamed:@"3.png"];
            break;
        case 4:
            pontos = [SKSpriteNode spriteNodeWithImageNamed:@"4.png"];
            break;
        case 5:
            pontos = [SKSpriteNode spriteNodeWithImageNamed:@"5.png"];
            break;
        case 6:
            pontos = [SKSpriteNode spriteNodeWithImageNamed:@"6.png"];
            break;
        case 7:
            pontos = [SKSpriteNode spriteNodeWithImageNamed:@"7.png"];
            break;
        case 8:
            pontos = [SKSpriteNode spriteNodeWithImageNamed:@"8.png"];
            break;
        case 9:
            pontos = [SKSpriteNode spriteNodeWithImageNamed:@"9.png"];
            break;
        case 10:
            pontos = [SKSpriteNode spriteNodeWithImageNamed:@"10.png"];
            break;
        default:
            break;
    }
    pontos.position = CGPointMake(680, 680);
    [self addChild:pontos];
}

-(BOOL)trofeuJaExiste{
    //POPULANDO ARRAY COM OS DADOS DO CORE DATA
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Trofeus" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSError *error;
    
    NSPredicate *pred;
    switch(assunto){
            //planta
        case 0:
            pred = [NSPredicate predicateWithFormat:@"(nomeTrofeu = %@)",@"planetaPlanta"];break;
            //aquecimento
        case 1:
            pred = [NSPredicate predicateWithFormat:@"(nomeTrofeu = %@)",@"planetaAquecimento"];break;
            //humano
        case 2:
            pred = [NSPredicate predicateWithFormat:@"(nomeTrofeu = %@)",@"planetaHumano"];break;
            //agua
        case 3:
            pred = [NSPredicate predicateWithFormat:@"(nomeTrofeu = %@)",@"planetaAgua"];break;
            //sustentabilidade
        case 4:
            pred = [NSPredicate predicateWithFormat:@"(nomeTrofeu = %@)",@"planetaSustentabilidade"];break;
            //astronomia
        case 5:
            pred = [NSPredicate predicateWithFormat:@"(nomeTrofeu = %@)",@"planetaAstronomia"];break;
            //biodiversidade
        case 6:
            pred = [NSPredicate predicateWithFormat:@"(nomeTrofeu = %@)",@"planetaBiodiversidade"];break;
            //continentes
        case 7:
            pred = [NSPredicate predicateWithFormat:@"(nomeTrofeu = %@)",@"planetaContinentes"];break;
        default: break;
            
    }
    
    [request setPredicate:pred];
    
    trofeus = [[context executeFetchRequest:request error:&error] mutableCopy];
    
    //------------------------------------------
    SingleTrofeus *single = [SingleTrofeus sharedInstance];
    
    for (int i = 0; i< trofeus.count; i++) {
        for(int x = 0; x< [[single trofeus] count]; x++){
            if ([[single trofeus] objectAtIndex:x] == [trofeus objectAtIndex:x]) {
                return NO;
            }
        }
    }
    
    
    return YES;
}

@end

