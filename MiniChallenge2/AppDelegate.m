//
//  AppDelegate.m
//  MiniChallenge2
//
//  Created by Renan Santos Soares on 4/23/14.
//  Copyright (c) 2014 RENANSANTOSSOARES. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "ViewController.h"
#import "Perguntas.h"
#import "SingleTrofeus.h"

@implementation AppDelegate
@synthesize player;
@synthesize gameView;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
//    gameView = [[ViewController alloc] init];
//    self.window.rootViewController = gameView;
    
    
    
    //AUDIO NAO ESTA FUNCIONANDO
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"tema" ofType:@"mp3"]];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    player.numberOfLoops = 100;
    //[player play];
    
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Perguntas" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSArray *perguntas = [NSArray new];
    NSError *error;
    perguntas = [context executeFetchRequest:request error:&error];
    
    if (![perguntas count] >0) {
        [self criaPerguntas];
    }
    
    
    
    //PREENCHENDO ARRAY DE TROFEUS
    NSManagedObjectContext *contexto = [self managedObjectContext];
    NSEntityDescription *entityDescri = [NSEntityDescription entityForName:@"Trofeus" inManagedObjectContext:contexto];
    NSFetchRequest *requesty = [[NSFetchRequest alloc] init];
    [requesty setEntity:entityDescri];
    NSError *erro;
    NSMutableArray *trofeus = [[context executeFetchRequest:requesty error:&erro] mutableCopy];
    SingleTrofeus *single = [SingleTrofeus sharedInstance];
    [single setTrofeus:trofeus];
    
    
    
    //----------------------------

    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreData" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoreData.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Perguntas

-(void)criaPerguntas{
    NSError *error;
    NSManagedObjectContext *context = [self managedObjectContext];
    
    //PLANETA AQUECIMENTO
    Perguntas *p1 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p1 setPergunta: @"O protocolo de kioto visa:"];
    [p1 setAlternativa1:@"A redução dos poluentes"];
    [p1 setAlternativa2:@"A queima das florestas"];
    [p1 setAlternativa3:@"Não aproveitar a energia eletrica"];
    [p1 setAlternativa4:@"alternativa D"];
    [p1 setAssunto:@"planetaAquecimento"];
    [p1 setResposta:@"a"];

    Perguntas *p2 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p2 setPergunta: @"O carvão quando é queimado produz um gás responsável pela:"];
    [p2 setAlternativa1:@"Neblina"];
    [p2 setAlternativa2:@"Chuva Ácida"];
    [p2 setAlternativa3:@"Garoa"];
    [p2 setAlternativa4:@"alternativa D"];
    [p2 setAssunto:@"planetaAquecimento"];
    [p2 setResposta:@"b"];
    
    
    Perguntas *p3 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p3 setPergunta: @"A maioria do aquecimento acontece devido a atividades:"];
    [p3 setAlternativa1:@"Humanas"];
    [p3 setAlternativa2:@"Flora"];
    [p3 setAlternativa3:@"Fauna"];
    [p3 setAlternativa4:@"alternativa D"];
    [p3 setAssunto:@"planetaAquecimento"];
    [p3 setResposta:@"a"];
    
    
    Perguntas *p4 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p4 setPergunta: @"Quem estuda o aquecimento global são os:"];
    [p4 setAlternativa1:@"Metereologistas"];
    [p4 setAlternativa2:@"Astrônomos"];
    [p4 setAlternativa3:@"Cientistas"];
    [p4 setAlternativa4:@"alternativa D"];
    [p4 setAssunto:@"planetaAquecimento"];
    [p4 setResposta:@"a"];
    
    
    Perguntas *p5 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p5 setPergunta: @"Todo ano 2.000 quilômetros quadrados de área \n se transformam em deserto devido à falta de:"];
    [p5 setAlternativa1:@"Maremotos"];
    [p5 setAlternativa2:@"Ventos"];
    [p5 setAlternativa3:@"Chuvas"];
    [p5 setAlternativa4:@"alternativa D"];
    [p5 setAssunto:@"planetaAquecimento"];
    [p5 setResposta:@"a"];
    
    Perguntas *p12 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p12 setPergunta: @"O carvão produz calor, mas também é utilizado para:"];
    [p12 setAlternativa1:@"Fazer corante, sabao e perfumes"];
    [p12 setAlternativa2:@"Desenhar na parede de casa"];
    [p12 setAlternativa3:@"Fazer refrigerante"];
    [p12 setAlternativa4:@"alternativa D"];
    [p12 setAssunto:@"planetaAquecimento"];
    [p12 setResposta:@"a"];
    
    Perguntas *p13 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p13 setPergunta: @"Os fatores responsáveis pelo aquecimento são:"];
    [p13 setAlternativa1:@"Economia de agua"];
    [p13 setAlternativa2:@"Pesca e agricultura"];
    [p13 setAlternativa3:@"Aumento de gases, poluentes e maior uso de agua"];
    [p13 setAlternativa4:@"alternativa D"];
    [p13 setAssunto:@"planetaAquecimento"];
    [p13 setResposta:@"c"];

    Perguntas *p14 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p14 setPergunta: @"Para diminuir o efeito estufa é preciso:"];
    [p14 setAlternativa1:@"Não praticar desmatamentos em florestas"];
    [p14 setAlternativa2:@"Tomar longos banhos"];
    [p14 setAlternativa3:@"Lavar o quintal todos os dias"];
    [p14 setAlternativa4:@"alternativa D"];
    [p14 setAssunto:@"planetaAquecimento"];
    [p14 setResposta:@"a"];
    
    Perguntas *p15 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p15 setPergunta: @"O aquecimento global é:"];
    [p15 setAlternativa1:@"O vazamento de gases"];
    [p15 setAlternativa2:@"O resfriamento da terra"];
    [p15 setAlternativa3:@"O aumento de temperatura"];
    [p15 setAlternativa4:@"alternativa D"];
    [p15 setAssunto:@"planetaAquecimento"];
    [p15 setResposta:@"c"];
    
    Perguntas *p16 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p16 setPergunta: @"As espécies na terra e no mar vão se:"];
    [p16 setAlternativa1:@"Multiplicar"];
    [p16 setAlternativa2:@"Extinguir"];
    [p16 setAlternativa3:@"Dividir"];
    [p16 setAlternativa4:@"alternativa D"];
    [p16 setAssunto:@"planetaAquecimento"];
    [p16 setResposta:@"b"];
    
    //--------------------------
    
    //PLANETA CONTINENTES
    Perguntas *p6 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p6 setPergunta: @"Para facilitar o estudo das áreas habitadas do planeta,\n suas porções de terra foram divididas em seis:"];
    [p6 setAlternativa1:@"Estados"];
    [p6 setAlternativa2:@"Países"];
    [p6 setAlternativa3:@"Continentes"];
    [p6 setAlternativa4:@"alternativa D"];
    [p6 setAssunto:@"planetaContinentes"];
    [p6 setResposta:@"c"];
    
    Perguntas *p17 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p17 setPergunta: @"A maior parte da Terra é de oceanos. Vista da Lua,\n ela apresenta uma coloração que a faz ser conhecida como:"];
    [p17 setAlternativa1:@"\"O planeta verde\""];
    [p17 setAlternativa2:@"\"O planeta azul\""];
    [p17 setAlternativa3:@"\"O planeta dos macacos\""];
    [p17 setAlternativa4:@"alternativa D"];
    [p17 setAssunto:@"planetaContinentes"];
    [p17 setResposta:@"b"];
    
    Perguntas *p18 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p18 setPergunta: @"Neste continente os países que se destacam\n são a Austrália e a Nova Zelândia:"];
    [p18 setAlternativa1:@"Africa"];
    [p18 setAlternativa2:@"Oceania"];
    [p18 setAlternativa3:@"Asia"];
    [p18 setAlternativa4:@"alternativa D"];
    [p18 setAssunto:@"planetaContinentes"];
    [p18 setResposta:@"b"];
    
    Perguntas *p19 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p19 setPergunta: @"O planeta Terra possui dois polos: \na Antártida e Antártica que estão, respectivamente:"];
    [p19 setAlternativa1:@"Ao leste e ao oeste"];
    [p19 setAlternativa2:@"Ao norte e ao sul"];
    [p19 setAlternativa3:@"Ao nordeste e ao sudeste"];
    [p19 setAlternativa4:@"alternativa D"];
    [p19 setAssunto:@"planetaContinentes"];
    [p19 setResposta:@"b"];
    
    Perguntas *p20 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p20 setPergunta: @"É um dos menores continentes do planeta \ne também conhecido como “Velho Mundo”:"];
    [p20 setAlternativa1:@"Asia"];
    [p20 setAlternativa2:@"Europa"];
    [p20 setAlternativa3:@"Antartica"];
    [p20 setAlternativa4:@"alternativa D"];
    [p20 setAssunto:@"planetaContinentes"];
    [p20 setResposta:@"b"];
    
    Perguntas *p21 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p21 setPergunta: @"A Ásia possui o maior país do mundo, a China.\n É o maior continente do mundo e também o mais:"];
    [p21 setAlternativa1:@"Pomposo"];
    [p21 setAlternativa2:@"Poluído"];
    [p21 setAlternativa3:@"Populoso"];
    [p21 setAlternativa4:@"alternativa D"];
    [p21 setAssunto:@"planetaContinentes"];
    [p21 setResposta:@"c"];
    
    Perguntas *p22 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p22 setPergunta: @"Os principais colonizadores da América foram os espanhóis,\n os ingleses, os franceses e os:"];
    [p22 setAlternativa1:@"Chineses"];
    [p22 setAlternativa2:@"Irlandeses"];
    [p22 setAlternativa3:@"Portugueses"];
    [p22 setAlternativa4:@"alternativa D"];
    [p22 setAssunto:@"planetaContinentes"];
    [p22 setResposta:@"c"];
    
    Perguntas *p23 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p23 setPergunta: @"O continente mais gelado do mundo é:"];
    [p23 setAlternativa1:@"A Antartica"];
    [p23 setAlternativa2:@"O Equador"];
    [p23 setAlternativa3:@"A Galileia"];
    [p23 setAlternativa4:@"alternativa D"];
    [p23 setAssunto:@"planetaContinentes"];
    [p23 setResposta:@"a"];
    
    Perguntas *p24 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p24 setPergunta: @"Em 1492, foi descoberta pelo espanhol Cristóvão Colombo:"];
    [p24 setAlternativa1:@"A America"];
    [p24 setAlternativa2:@"A Asia"];
    [p24 setAlternativa3:@"A Europa"];
    [p24 setAlternativa4:@"alternativa D"];
    [p24 setAssunto:@"planetaContinentes"];
    [p24 setResposta:@"a"];
    
    Perguntas *p25 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p25 setPergunta: @"A Terra é dividida nos seguintes continentes:\n África, América, Antártica, Ásia…"];
    [p25 setAlternativa1:@"Europa e Oceania"];
    [p25 setAlternativa2:@"Reino Unido e Uniao Sovietica"];
    [p25 setAlternativa3:@"Mercado comum europeu e Mercosul"];
    [p25 setAlternativa4:@"alternativa D"];
    [p25 setAssunto:@"planetaContinentes"];
    [p25 setResposta:@"a"];
    
    //--------------------
    
    //PLANETA ASTRONOMIA
    Perguntas *p7 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p7 setPergunta: @"Quanto tempo a Terra leva para completar a órbita em torno do Sol?"];
    [p7 setAlternativa1:@"2 Anos"];
    [p7 setAlternativa2:@"1 Ano"];
    [p7 setAlternativa3:@"1 Ano e Meio"];
    [p7 setAlternativa4:@"alternativa D"];
    [p7 setAssunto:@"planetaAstronomia"];
    [p7 setResposta:@"b"];
    
    Perguntas *p26 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p26 setPergunta: @"Marte também pode ser chamado de:"];
    [p26 setAlternativa1:@"Planeta pequeno"];
    [p26 setAlternativa2:@"Planeta vermelho"];
    [p26 setAlternativa3:@"Planeta maior"];
    [p26 setAlternativa4:@"alternativa D"];
    [p26 setAssunto:@"planetaAstronomia"];
    [p26 setResposta:@"b"];
    
    Perguntas *p27 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p27 setPergunta: @"A explosão que pode ter dado origem ao universo é chamada de:"];
    [p27 setAlternativa1:@"Big-Bang"];
    [p27 setAlternativa2:@"Big-Bum"];
    [p27 setAlternativa3:@"Órion"];
    [p27 setAlternativa4:@"alternativa D"];
    [p27 setAssunto:@"planetaAstronomia"];
    [p27 setResposta:@"a"];
    
    Perguntas *p28 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p28 setPergunta: @"O Sol é:"];
    [p28 setAlternativa1:@"Um cometa"];
    [p28 setAlternativa2:@"Uma galáxia"];
    [p28 setAlternativa3:@"Uma estrela"];
    [p28 setAlternativa4:@"alternativa D"];
    [p28 setAssunto:@"planetaAstronomia"];
    [p28 setResposta:@"c"];

    Perguntas *p29 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p29 setPergunta: @"Qual é o nome do satélite Natural da Terra?"];
    [p29 setAlternativa1:@"Tritão"];
    [p29 setAlternativa2:@"Lua"];
    [p29 setAlternativa3:@"Kuiper"];
    [p29 setAlternativa4:@"Sol"];
    [p29 setAssunto:@"planetaAstronomia"];
    [p29 setResposta:@"b"];
    
    Perguntas *p30 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p30 setPergunta: @"A Galáxia onde o Sistema Solar orbita chama-se:"];
    [p30 setAlternativa1:@"Via lactea"];
    [p30 setAlternativa2:@"Andromeda"];
    [p30 setAlternativa3:@"Grande nuvem"];
    [p30 setAlternativa4:@"Alternativa D"];
    [p30 setAssunto:@"planetaAstronomia"];
    [p30 setResposta:@"a"];

    Perguntas *p31 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p31 setPergunta: @"Quais são os planetas rodeados por anéis?"];
    [p31 setAlternativa1:@"Saturno e Urano"];
    [p31 setAlternativa2:@"Marte e Venus"];
    [p31 setAlternativa3:@"Netuno e Plutao"];
    [p31 setAlternativa4:@"Alternativa D"];
    [p31 setAssunto:@"planetaAstronomia"];
    [p31 setResposta:@"a"];
    
    Perguntas *p32 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p32 setPergunta: @"A medida usada para medir grandes distâncias no espaço é:"];
    [p32 setAlternativa1:@"Metro"];
    [p32 setAlternativa2:@"Ano-luz"];
    [p32 setAlternativa3:@"Quilômetro"];
    [p32 setAlternativa4:@"Alternativa D"];
    [p32 setAssunto:@"planetaAstronomia"];
    [p32 setResposta:@"b"];
    
    Perguntas *p33 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p33 setPergunta: @"O terceiro planeta em órbita do Sol é:"];
    [p33 setAlternativa1:@"Terra"];
    [p33 setAlternativa2:@"Mercúrio"];
    [p33 setAlternativa3:@"Urano"];
    [p33 setAlternativa4:@"Marte"];
    [p33 setAssunto:@"planetaAstronomia"];
    [p33 setResposta:@"a"];
    
    Perguntas *p34 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p34 setPergunta: @"Qual o planeta mais próximo do Sol?"];
    [p34 setAlternativa1:@"Saturno"];
    [p34 setAlternativa2:@"Marte"];
    [p34 setAlternativa3:@"Mercúrio"];
    [p34 setAlternativa4:@"Netuno"];
    [p34 setAssunto:@"planetaAstronomia"];
    [p34 setResposta:@"c"];
    //--------------------
    
    //PLANETA HUMANO
    Perguntas *p8 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p8 setPergunta: @"O sistema respiratório é responsável por:"];
    [p8 setAlternativa1:@"Captar oxigenio do ar"];
    [p8 setAlternativa2:@"Enviar funções para o cérebro"];
    [p8 setAlternativa3:@"Absorver os nutrientes dos alimentos"];
    [p8 setAlternativa4:@"alternativa D"];
    [p8 setAssunto:@"planetaHumano"];
    [p8 setResposta:@"a"];
    
    Perguntas *p35 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p35 setPergunta: @"O sistema excretor é responsável por:"];
    [p35 setAlternativa1:@"Eliminar tudo que é ingerido"];
    [p35 setAlternativa2:@"Filtrar e eliminar substancias do organismo"];
    [p35 setAlternativa3:@"Absorver os alimentos ingeridos"];
    [p35 setAlternativa4:@"alternativa D"];
    [p35 setAssunto:@"planetaHumano"];
    [p35 setResposta:@"c"];
    
    Perguntas *p36 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p36 setPergunta: @"Os neurônios são:"];
    [p36 setAlternativa1:@"Glandulas do corpo"];
    [p36 setAlternativa2:@"Células nervosas ligadas a todas as partes do corpo."];
    [p36 setAlternativa3:@"Órgãos que fazem parte do nosso corpo."];
    [p36 setAlternativa4:@"alternativa D"];
    [p36 setAssunto:@"planetaHumano"];
    [p36 setResposta:@"b"];
    
    Perguntas *p37 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p37 setPergunta: @"A função do cerébro é:"];
    [p37 setAlternativa1:@"Captar oxigenio do ar"];
    [p37 setAlternativa2:@"Comandar todas as funcoes do corpo"];
    [p37 setAlternativa3:@"Fornecer nutrientes para nosso organismo"];
    [p37 setAlternativa4:@"alternativa D"];
    [p37 setAssunto:@"planetaHumano"];
    [p37 setResposta:@"b"];
    
    Perguntas *p38 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p38 setPergunta: @"O sistema esquelético é responsável por:"];
    [p38 setAlternativa1:@"Manter o corpo em pé"];
    [p38 setAlternativa2:@"Coordenar as acoes do corpo"];
    [p38 setAlternativa3:@"Manter em funcionamento todos os outros sistemas"];
    [p38 setAlternativa4:@"alternativa D"];
    [p38 setAssunto:@"planetaHumano"];
    [p38 setResposta:@"a"];
    
    Perguntas *p39 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p39 setPergunta: @"O corpo humano é:"];
    [p39 setAlternativa1:@"Um conjunto de órgãos e sistemas \nque trabalham o tempo todo."];
    [p39 setAlternativa2:@"Um conjunto formado somente por órgãos."];
    [p39 setAlternativa3:@"Um conjunto formado pelo sistema esquelético, \n circulatório e respiratório."];
    [p39 setAlternativa4:@"alternativa D"];
    [p39 setAssunto:@"planetaHumano"];
    [p39 setResposta:@"a"];
    
    Perguntas *p40 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p40 setPergunta: @"O sistema imunológico é responsável:"];
    [p40 setAlternativa1:@"Por armazenar substâncias no organismo."];
    [p40 setAlternativa2:@"Por filtrar o sangue nas veias."];
    [p40 setAlternativa3:@"Pela defesa orgânica do corpo."];
    [p40 setAlternativa4:@"alternativa D"];
    [p40 setAssunto:@"planetaHumano"];
    [p40 setResposta:@"c"];
    
    Perguntas *p41 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p41 setPergunta: @"Os alimentos são importantes para:"];
    [p41 setAlternativa1:@"Saciar a fome."];
    [p41 setAlternativa2:@"Dar energia ao corpo"];
    [p41 setAlternativa3:@"Fornecer nutrientes para nosso organismo funcionar."];
    [p41 setAlternativa4:@"alternativa D"];
    [p41 setAssunto:@"planetaHumano"];
    [p41 setResposta:@"c"];
    
    Perguntas *p42 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p42 setPergunta: @"O sistema circulatório é responsável por:"];
    [p42 setAlternativa1:@"Circular o sangue pelo corpo."];
    [p42 setAlternativa2:@"Levar o ar para os pulmões."];
    [p42 setAlternativa3:@"Transportar nutrientes, oxigênio e \ntambém excretas que devem ser eliminadas."];
    [p42 setAlternativa4:@"alternativa D"];
    [p42 setAssunto:@"planetaHumano"];
    [p42 setResposta:@"c"];
    
    Perguntas *p43 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p43 setPergunta: @"O sistema digestório é responsável por:"];
    [p43 setAlternativa1:@"Processar os nutrientes para \nserem absorvidos pelas células."];
    [p43 setAlternativa2:@"Transportar os nutrientes"];
    [p43 setAlternativa3:@"Eliminar os nutrientes dos alimentos."];
    [p43 setAlternativa4:@"alternativa D"];
    [p43 setAssunto:@"planetaHumano"];
    [p43 setResposta:@"a"];
    
    //--------------------
    
    //PLANETA SUSTENTABILIDADE
    Perguntas *p9 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p9 setPergunta: @"O Biogás além de ser um biocombustível,\n pode também ser utilizado:"];
    [p9 setAlternativa1:@"Somente em veículos"];
    [p9 setAlternativa2:@"Para produção de energia elétrica"];
    [p9 setAlternativa3:@"Para o aquecimento da água"];
    [p9 setAlternativa4:@"alternativa D"];
    [p9 setAssunto:@"planetaSustentabilidade"];
    [p9 setResposta:@"b"];
    
    Perguntas *p10 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p10 setPergunta: @"Em que ano a reciclagem começou a ser levada a sério?"];
    [p10 setAlternativa1:@"1970"];
    [p10 setAlternativa2:@"1990"];
    [p10 setAlternativa3:@"2000"];
    [p10 setAlternativa4:@"alternativa D"];
    [p10 setAssunto:@"planetaSustentabilidade"];
    [p10 setResposta:@"a"];
    
    Perguntas *p44 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p44 setPergunta: @"A energia solar é mais utilizada em:"];
    [p44 setAlternativa1:@"Residências para o aquecimento da água"];
    [p44 setAlternativa2:@"Veiculos"];
    [p44 setAlternativa3:@"Industrias"];
    [p44 setAlternativa4:@"alternativa D"];
    [p44 setAssunto:@"planetaSustentabilidade"];
    [p44 setResposta:@"a"];
    
    Perguntas *p45 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p45 setPergunta: @"A energia proveniente de matéria orgânica se chama:"];
    [p45 setAlternativa1:@"Biodiesel"];
    [p45 setAlternativa2:@"Energia Solar"];
    [p45 setAlternativa3:@"Biomassa"];
    [p45 setAlternativa4:@"alternativa D"];
    [p45 setAssunto:@"planetaSustentabilidade"];
    [p45 setResposta:@"c"];
    
    Perguntas *p46 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p46 setPergunta: @"A energia sustentável:"];
    [p46 setAlternativa1:@"Não influencia em nosso cotidiano"];
    [p46 setAlternativa2:@"É utilizada sem danos ao meio\n ambiente e seres vivos"];
    [p46 setAlternativa3:@"Prejudica o meio ambiente"];
    [p46 setAlternativa4:@"alternativa D"];
    [p46 setAssunto:@"planetaSustentabilidade"];
    [p46 setResposta:@"b"];
    
    Perguntas *p47 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p47 setPergunta: @"A energia Geotermal é:"];
    [p47 setAlternativa1:@"Proveniente de matéria orgânica"];
    [p47 setAlternativa2:@"Gerada através do calor proveniente\n do interior da Terra"];
    [p47 setAlternativa3:@"Um combustível renovável"];
    [p47 setAlternativa4:@"alternativa D"];
    [p47 setAssunto:@"planetaSustentabilidade"];
    [p47 setResposta:@"b"];
    
    Perguntas *p48 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p48 setPergunta: @"Por que o uso da energia renovável\n é o mais apropriado?"];
    [p48 setAlternativa1:@"Porque utiliza recursos que \nsão devolvidos ao meio ambiente"];
    [p48 setAlternativa2:@"Porque utiliza combustíveis fósseis"];
    [p48 setAlternativa3:@"Porque não se reitera ao meio ambiente"];
    [p48 setAlternativa4:@"alternativa D"];
    [p48 setAssunto:@"planetaSustentabilidade"];
    [p48 setResposta:@"a"];
    
    Perguntas *p49 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p49 setPergunta: @"Quais são os tipos de energia renovaveis?"];
    [p49 setAlternativa1:@"Eólica ou solar"];
    [p49 setAlternativa2:@"Biogás"];
    [p49 setAlternativa3:@"Geotermal"];
    [p49 setAlternativa4:@"alternativa D"];
    [p49 setAssunto:@"planetaSustentabilidade"];
    [p49 setResposta:@"a"];
    
    Perguntas *p50 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p50 setPergunta: @"A energia eólica é:"];
    [p50 setAlternativa1:@"Gerada pelo vento"];
    [p50 setAlternativa2:@"Gerada através do calor"];
    [p50 setAlternativa3:@"Proveniente do sol"];
    [p50 setAlternativa4:@"alternativa D"];
    [p50 setAssunto:@"planetaSustentabilidade"];
    [p50 setResposta:@"a"];
    
    Perguntas *p51 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p51 setPergunta: @"O que previa o documento “Agenda 21” assinado em 1922?"];
    [p51 setAlternativa1:@"O não uso de energia renovável"];
    [p51 setAlternativa2:@"Estratégias globais de desenvolvimento sustentável"];
    [p51 setAlternativa3:@"Os benefícios da energia renovável"];
    [p51 setAlternativa4:@"alternativa D"];
    [p51 setAssunto:@"planetaSustentabilidade"];
    [p51 setResposta:@"b"];
    //--------------------
    
    //PLANETA BIODIVERSIDADE
    Perguntas *p71 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p71 setPergunta: @"A palavra biodiversidade representa:"];
    [p71 setAlternativa1:@"A quantidade de seres vivos\n que encontramos no planeta"];
    [p71 setAlternativa2:@"A pouca variedade de seres vivos\n que encontramos no planeta"];
    [p71 setAlternativa3:@"A grande variedade de seres vivos\n que encontramos no planeta"];
    [p71 setAlternativa4:@"alternativa D"];
    [p71 setAssunto:@"planetaBiodiversidade"];
    [p71 setResposta:@"c"];
    
    Perguntas *p72 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p72 setPergunta: @"No Brasil temos dois Hotspots importantes, são eles:"];
    [p72 setAlternativa1:@"Amazônia e Mata Atlântica"];
    [p72 setAlternativa2:@"Amazônia e Cerrado"];
    [p72 setAlternativa3:@"Mata Atlântica e Cerrado"];
    [p72 setAlternativa4:@"alternativa D"];
    [p72 setAssunto:@"planetaBiodiversidade"];
    [p72 setResposta:@"c"];
    
    Perguntas *p73 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p73 setPergunta: @"Os cientistas estimam que sejam:"];
    [p73 setAlternativa1:@"1 e 5 milhões de espécies diferentes de vegetais\n e animais no mundo inteiro"];
    [p73 setAlternativa2:@"10 e 50 milhões de espécies diferentes de vegetais\n e animais no mundo inteiro"];
    [p73 setAlternativa3:@"100 e 500 milhões de espécies diferentes de vegetais\n e animais no mundo inteiro"];
    [p73 setAlternativa4:@"alternativa D"];
    [p73 setAssunto:@"planetaBiodiversidade"];
    [p73 setResposta:@"b"];
    
    Perguntas *p74 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p74 setPergunta: @"Segundo estatísticas publicadas pela ONG WWF-Brasil:"];
    [p74 setAlternativa1:@"“A cada ano, aproximadamente 9 milhões de hectares\n de floresta tropical são desmatados”"];
    [p74 setAlternativa2:@"“A cada ano, aproximadamente 17 milhões de hectares\n de floresta tropical são desmatados”"];
    [p74 setAlternativa3:@"“A cada ano, aproximadamente 32 milhões de hectares\n de floresta tropical são desmatados”"];
    [p74 setAlternativa4:@"alternativa D"];
    [p74 setAssunto:@"planetaBiodiversidade"];
    [p74 setResposta:@"b"];
    
    Perguntas *p75 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p75 setPergunta: @"Brasil é considerado o país da megadiversidade porque:"];
    [p75 setAlternativa1:@"20% das espécies conhecidas estão por aqui"];
    [p75 setAlternativa2:@"40% das espécies conhecidas estão por aqui"];
    [p75 setAlternativa3:@"60% das espécies conhecidas estão por aqui"];
    [p75 setAlternativa4:@"alternativa D"];
    [p75 setAssunto:@"planetaBiodiversidade"];
    [p75 setResposta:@"a"];
    
    Perguntas *p76 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p76 setPergunta: @"O que é um Hotspot?"];
    [p76 setAlternativa1:@"Um Hotspot é todo o local com alto nível de biodiversidade e com 75% ou mais da sua vegetação destruída."];
    [p76 setAlternativa2:@"Um Hotspot é todo o local com alto nível de biodiversidade e com 5% ou mais da sua vegetação destruída."];
    [p76 setAlternativa3:@"Um Hotspot é todo o local com baixo nível de biodiversidade e com 5% ou mais da sua vegetação destruída."];
    [p76 setAlternativa4:@"alternativa D"];
    [p76 setAssunto:@"planetaBiodiversidade"];
    [p76 setResposta:@"a"];
    
    Perguntas *p77 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p77 setPergunta: @"Se não cuidarmos do nosso planeta estima-se que:"];
    [p77 setAlternativa1:@"Entre 1% e 5% das espécies que habitam as florestas tropicais poderão estar extintas dentro dos próximos 30 anos"];
    [p77 setAlternativa2:@"Entre 5% e 10% das espécies que habitam as florestas tropicais poderão estar extintas dentro dos próximos 30 anos"];
    [p77 setAlternativa3:@"Entre 10% e 20% das espécies que habitam as florestas tropicais poderão estar extintas dentro dos próximos 30 anos"];
    [p77 setAlternativa4:@"alternativa D"];
    [p77 setAssunto:@"planetaBiodiversidade"];
    [p77 setResposta:@"b"];
    
    Perguntas *p78 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p78 setPergunta: @"Mata Atlântica é um dos locais que mais sofreram com a devastação do homem"];
    [p78 setAlternativa1:@"Atualmente tem apenas 8% da sua mata original"];
    [p78 setAlternativa2:@"Atualmente tem apenas 22% da sua mata original"];
    [p78 setAlternativa3:@"Atualmente tem apenas 48% da sua mata original"];
    [p78 setAlternativa4:@"alternativa D"];
    [p78 setAssunto:@"planetaBiodiversidade"];
    [p78 setResposta:@"a"];
    
    Perguntas *p79 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p79 setPergunta: @"Hoje, quantas regiões são consideradas Hotspots ao redor do planeta?"];
    [p79 setAlternativa1:@"12"];
    [p79 setAlternativa2:@"24"];
    [p79 setAlternativa3:@"34"];
    [p79 setAlternativa4:@"alternativa D"];
    [p79 setAssunto:@"planetaBiodiversidade"];
    [p79 setResposta:@"c"];
    
    Perguntas *p80 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p80 setPergunta: @"Indique os fatores que prejudicam a Biodiversidade do planeta:"];
    [p80 setAlternativa1:@"Controle dos gases tóxicos, o uso consciente dos recursos naturais, expansão urbana e industrial, desmatamento "];
    [p80 setAlternativa2:@"Poluição, o uso abusivo dos recursos naturais, expansão urbana e industrial, caça predatória, desmatamento"];
    [p80 setAlternativa3:@"Poluição, o uso consciente dos recursos naturais, planejamento urbano e industrial, caça limitada"];
    [p80 setAlternativa4:@"alternativa D"];
    [p80 setAssunto:@"planetaBiodiversidade"];
    [p80 setResposta:@"b"];
    //--------------------
    
    //PLANETA AGUA
    Perguntas *p11 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p11 setPergunta: @"A maior parte da água do planeta terra se encontra:"];
    [p11 setAlternativa1:@"Nos rios e lagos"];
    [p11 setAlternativa2:@"Nos mares e oceanos"];
    [p11 setAlternativa3:@"Nos encanamentos das cidades"];
    [p11 setAlternativa4:@"alternativa D"];
    [p11 setAssunto:@"planetaAgua"];
    [p11 setResposta:@"b"];

    Perguntas *p52 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p52 setPergunta: @"A água evapora a quantos graus celsius?"];
    [p52 setAlternativa1:@"100C"];
    [p52 setAlternativa2:@"70C"];
    [p52 setAlternativa3:@"50C"];
    [p52 setAlternativa4:@"alternativa D"];
    [p52 setAssunto:@"planetaAgua"];
    [p52 setResposta:@"a"];
    
    Perguntas *p53 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p53 setPergunta: @"Como é composta a molécula de água?"];
    [p53 setAlternativa1:@"Dois átomos de hidrogênio e dois de oxigênio"];
    [p53 setAlternativa2:@"Dois átomos de hidrogênio e um de oxigênio"];
    [p53 setAlternativa3:@" Um átomos de hidrogênio e um de oxigênio"];
    [p53 setAlternativa4:@"alternativa D"];
    [p53 setAssunto:@"planetaAgua"];
    [p53 setResposta:@"b"];

    Perguntas *p54 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p54 setPergunta: @"Na época das chuvas há transbordamentos e enchentes pelas seguintes causas, exceto:"];
    [p54 setAlternativa1:@"Estreitamento e canalização dos rios (urbanização)"];
    [p54 setAlternativa2:@"Impermeabilização do solo pelo asfalto (impede o escoamento d´água)"];
    [p54 setAlternativa3:@"Coleta seletiva de lixo e limpeza dos bueiros (“bocas de Lobo”)"];
    [p54 setAlternativa4:@"alternativa D"];
    [p54 setAssunto:@"planetaAgua"];
    [p54 setResposta:@"c"];
    
    Perguntas *p55 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p55 setPergunta: @"Qual é o percentual da população mundial que ainda vive sem rede de esgoto?"];
    [p55 setAlternativa1:@"37%"];
    [p55 setAlternativa2:@"35%"];
    [p55 setAlternativa3:@"17%"];
    [p55 setAlternativa4:@"alternativa D"];
    [p55 setAssunto:@"planetaAgua"];
    [p55 setResposta:@"a"];
    
    Perguntas *p56 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p56 setPergunta: @"Segundo as estatísticas da UNESCO parte da população mundial ainda não possui acesso à água potável. Este:"];
    [p56 setAlternativa1:@"17%"];
    [p56 setAlternativa2:@"11%"];
    [p56 setAlternativa3:@"37%"];
    [p56 setAlternativa4:@"alternativa D"];
    [p56 setAssunto:@"planetaAgua"];
    [p56 setResposta:@"b"];
    
    Perguntas *p57 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p57 setPergunta: @"A maior dificuldade em ter os cuidados necessários e manter a água adequada para o consumo é:"];
    [p57 setAlternativa1:@"Nas grandes cidades"];
    [p57 setAlternativa2:@"Nas ilhas"];
    [p57 setAlternativa3:@"Nas montanhas"];
    [p57 setAlternativa4:@"alternativa D"];
    [p57 setAssunto:@"planetaAgua"];
    [p57 setResposta:@"a"];
    
    Perguntas *p58 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p58 setPergunta: @"A campanha mundial da Cooperação pela Água em 2013 foi lançada pela:"];
    [p58 setAlternativa1:@"OMS"];
    [p58 setAlternativa2:@"OIT"];
    [p58 setAlternativa3:@"ONU"];
    [p58 setAlternativa4:@"alternativa D"];
    [p58 setAssunto:@"planetaAgua"];
    [p58 setResposta:@"c"];
    
    Perguntas *p59 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p59 setPergunta: @"Para utilizar a água de nossa casa de forma sustentável, é correto:"];
    [p59 setAlternativa1:@"Não enxaguar a boca com a água do copo ao escovar os dentes."];
    [p59 setAlternativa2:@"Desligar o chuveiro ao ensaboarmos o corpo."];
    [p59 setAlternativa3:@"Lavar o carro com mangueira e nunca usar balde."];
    [p59 setAlternativa4:@"alternativa D"];
    [p59 setAssunto:@"planetaAgua"];
    [p59 setResposta:@"b"];
    
    Perguntas *p60 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p60 setPergunta: @"Em assembleia da ONU de dezembro de 2010 foi eleito um agente para ser líder da campanha pela água. Qual foi?"];
    [p60 setAlternativa1:@"UNESCO"];
    [p60 setAlternativa2:@"UNE"];
    [p60 setAlternativa3:@"UNE"];
    [p60 setAlternativa4:@"alternativa D"];
    [p60 setAssunto:@"planetaAgua"];
    [p60 setResposta:@"a"];
    
    //--------------------
    
    //PLANETA PLANTA
    Perguntas *p61 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p61 setPergunta: @"Pigmento responsável pela absorção da luz\n durante a realização da fotossíntese:"];
    [p61 setAlternativa1:@"Tinta"];
    [p61 setAlternativa2:@"Nanquim"];
    [p61 setAlternativa3:@"Clorofila"];
    [p61 setAlternativa4:@"alternativa D"];
    [p61 setAssunto:@"planetaPlanta"];
    [p61 setResposta:@"c"];
    
    Perguntas *p62 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p62 setPergunta: @"Transporte de água, sais minerais e compostos orgânicos \npor toda a planta através de feixes condutores:"];
    [p62 setAlternativa1:@"Indução"];
    [p62 setAlternativa2:@"Condução"];
    [p62 setAlternativa3:@"Eleição"];
    [p62 setAlternativa4:@"alternativa D"];
    [p62 setAssunto:@"planetaPlanta"];
    [p62 setResposta:@"b"];
    
    Perguntas *p63 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p63 setPergunta: @"O açúcar produzido pela planta é utilizado para:"];
    [p63 setAlternativa1:@"Produção de energia"];
    [p63 setAlternativa2:@"Fazer bolo"];
    [p63 setAlternativa3:@"Adoçar chá"];
    [p63 setAlternativa4:@"alternativa D"];
    [p63 setAssunto:@"planetaPlanta"];
    [p63 setResposta:@"a"];
    
    Perguntas *p64 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p64 setPergunta: @"Conjunto de processos físicos e químicos realizados pela célula:"];
    [p64 setAlternativa1:@"Respiração"];
    [p64 setAlternativa2:@"Metabolismo"];
    [p64 setAlternativa3:@"Digestão"];
    [p64 setAlternativa4:@"alternativa D"];
    [p64 setAssunto:@"planetaPlanta"];
    [p64 setResposta:@"b"];
    
    Perguntas *p65 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p65 setPergunta: @"A água é uma das matérias-primas da fotossíntese, ela entra pelas:"];
    [p65 setAlternativa1:@"Raízes"];
    [p65 setAlternativa2:@"Canaletas"];
    [p65 setAlternativa3:@"Folhas"];
    [p65 setAlternativa4:@"alternativa D"];
    [p65 setAssunto:@"planetaPlanta"];
    [p65 setResposta:@"a"];
    
    Perguntas *p66 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p66 setPergunta: @"A transformação da energia solar em energia química,\n com a produção de alimento para a planta chama-se:"];
    [p66 setAlternativa1:@"Fotossíntese"];
    [p66 setAlternativa2:@"Biossíntese"];
    [p66 setAlternativa3:@"Síntese"];
    [p66 setAlternativa4:@"alternativa D"];
    [p66 setAssunto:@"planetaPlanta"];
    [p66 setResposta:@"a"];
    
    Perguntas *p67 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p67 setPergunta: @"No processo da fotossíntese, a planta absorve a luz do:"];
    [p67 setAlternativa1:@"Abajur"];
    [p67 setAlternativa2:@"Lampião"];
    [p67 setAlternativa3:@"Sol"];
    [p67 setAlternativa4:@"alternativa D"];
    [p67 setAssunto:@"planetaPlanta"];
    [p67 setResposta:@"c"];
    
    Perguntas *p68 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p68 setPergunta: @"Gás fundamental para a respiração dos seres vivos"];
    [p68 setAlternativa1:@"Gás carbônico"];
    [p68 setAlternativa2:@"Gás metano"];
    [p68 setAlternativa3:@"Oxigênio"];
    [p68 setAlternativa4:@"alternativa D"];
    [p68 setAssunto:@"planetaPlanta"];
    [p68 setResposta:@"c"];
    
    Perguntas *p69 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p69 setPergunta: @"Principal processo de perda de água em forma\n de vapor pelas plantas e demais organismos"];
    [p69 setAlternativa1:@"Transpiração"];
    [p69 setAlternativa2:@"Respiração"];
    [p69 setAlternativa3:@"Absorção"];
    [p69 setAlternativa4:@"alternativa D"];
    [p69 setAssunto:@"planetaPlanta"];
    [p69 setResposta:@"a"];
    
    Perguntas *p70 = [NSEntityDescription insertNewObjectForEntityForName:@"Perguntas" inManagedObjectContext:context];
    [p70 setPergunta: @"A fotossíntese inicia a maior parte das cadeias alimentares na"];
    [p70 setAlternativa1:@"Terra"];
    [p70 setAlternativa2:@"Água"];
    [p70 setAlternativa3:@"Floresta"];
    [p70 setAlternativa4:@"alternativa D"];
    [p70 setAssunto:@"planetaPlanta"];
    [p70 setResposta:@"a"];
    //--------------------
    
    [context save:&error];
}

@end
