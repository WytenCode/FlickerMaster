//
//  ViewController.m
//  LCTUrlProj
//
//  Created by Владимир on 21/04/2019.
//  Copyright © 2019 Владимир. All rights reserved.
//

#import "ViewController.h"
#import "NetworkService.h"
#import "FlickrCollectionView.h"
#import "AppDelegate.h"
#import "Searches+CoreDataClass.h"

@import CoreData;

static const CGFloat borderOffset = 5.0f;
@import UserNotifications;

static const NSString *identifierforActions = @"LCTReminderCategory";

typedef NS_ENUM(NSInteger , LCTTriggerType){
    LCTTriggerTypeInterval = 0,
    LCTTriggerTypeDate = 1,
    LCTTriggerTypeLocation = 2,
};

@interface ViewController () <NetworkServiceOutputProtocol>

@property (nonatomic, strong) NetworkService *networkService;
@property (nonatomic, strong) FlickrCollectionView *myFCV;
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) CustomPhotoViewController *myCustomVC;
@property (nonatomic, strong) NSFetchRequest *fetchRequest;
@property (nonatomic, strong) NSManagedObjectContext *coreDataContext;


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    [self setupSearchBar];
    [self setupNetworkService];
    [self setupFlickrCollectionViewWithPhotos:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    //[super viewWillAppear:animated];
    NSLog(@"here again");
}

-(void)setupSearchBar
{
    self.searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(borderOffset, 20, self.view.bounds.size.width - 2 * borderOffset, 40)];
    self.searchTextField.borderStyle = UITextBorderStyleLine;
    self.searchTextField.delegate = self;
    self.searchTextField.text = @"Nature";
    self.searchTextField.placeholder = @"Введите запрос";
    [self.view addSubview:self.searchTextField];
}

-(void)setupFlickrCollectionViewWithPhotos:(NSArray *)photos
{
    CGFloat startY = 65;
    self.myFCV = [[FlickrCollectionView alloc] initWithFrame:CGRectMake(borderOffset, startY, self.view.bounds.size.width - 2 * borderOffset, self.view.bounds.size.height - startY - borderOffset) ];
    self.delegate = self.myFCV;
    self.myFCV.customDelegate = self;
    self.networkService.collectionOutput = self.myFCV;
    self.myFCV.inpDelegate = self.networkService;
    [self.delegate setPhotoDataWithArray:photos];
    [self.view addSubview:self.myFCV];
}

-(void)setupNetworkService
{
    self.networkService = [NetworkService new];
    self.networkService.output = self;
    [self.networkService configureUrlSessionWithParams:nil];
}

-(void)findNetworkServiceResultsWithRequest:(NSString *)request
{
    [self.networkService findFlickrPhotoWithSearchString:request];
}

#pragma mark UITextFieldDelegate

-(void)textFieldDidEndEditing:(UITextField *)textField
{
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self addNewSearch];
    [self sheduleAnotherNotification];
    [self findNetworkServiceResultsWithRequest:textField.text];
    return YES;
}

#pragma mark - NetworkServiceOutputProtocol

-(void)photoInfoReceivedWithArray:(NSArray *)array
{
    [self setupFlickrCollectionViewWithPhotos:array];
}

#pragma makr - CustomPhoto

-(void)runImageOnCustomControllerWithImage:(UIImage *)image
{
    if (!self.myCustomVC)
        self.myCustomVC = [CustomPhotoViewController new];
    self.myCustomVC.delegate = self;
    [self.myCustomVC setupImageViewWithImage:image];
    [self presentViewController:self.myCustomVC animated:YES completion:nil];
}

-(void)getResultPhotoWithImage:(UIImage *)image
{
    [self.myCustomVC dismissViewControllerAnimated:YES completion:nil];
    NSString *title = [NSString stringWithFormat:@"Image changed!"];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmActionButton = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:confirmActionButton];
    
    [self presentViewController:alertController animated:YES completion:nil];
    self.myCustomVC = nil;
    [self.delegate changeCellImageWithImage:image];
    [self sheduleLocalNotification];
}

#pragma NotificationStuff
-(void)sheduleLocalNotification
{
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    
    content.title = @"Напоминание";
    content.body = @"Недавно вы изменили картинку";
    content.sound = [UNNotificationSound defaultSound];
    
    content.badge = @ ([self giveNewBadgeNumber] + 1);
    
    UNNotificationAttachment *attachment = [self imageAttachment];
    [content setAttachments:@[attachment]];
    
    [content setCategoryIdentifier:[NSString stringWithFormat:@"%@", identifierforActions]];
    
    NSDictionary *userDict = @{
                               @"color": @"yellowColor"
                               };
    [content setUserInfo:userDict];
    UNNotificationTrigger *secondTrigger = [self triggerWithType:LCTTriggerTypeInterval];
    
    NSString *identifier = @"NotificationId";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:secondTrigger];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error)
        {
            NSLog(@"Что-то пошло не так ... %@", error);
        }
    }];
}

-(void)sheduleAnotherNotification
{
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    
    NSArray *searchesPool = [self updatedArray];
    NSInteger randIndex = arc4random_uniform([searchesPool count]);
    Searches *someSearch = [searchesPool objectAtIndex:randIndex];
    
    content.title = @"Напоминание";
    content.body = [NSString stringWithFormat: @"Недавно вы искали картинки по запросу: %@. Хотите повторить?", someSearch.searchString ];
    
    content.sound = [UNNotificationSound defaultSound];
    
    content.badge = @ ([self giveNewBadgeNumber] + 1);
    
    UNNotificationAttachment *attachment = [self imageAttachment];
    [content setAttachments:@[attachment]];
    
    [content setCategoryIdentifier:[NSString stringWithFormat:@"%@", identifierforActions]];
    
    NSDictionary *userDict = @{
                               @"request": someSearch.searchString
                               };
    [content setUserInfo:userDict];
    UNNotificationTrigger *secondTrigger = [self triggerWithType:LCTTriggerTypeInterval];
    
    NSString *identifier = @"NotificationId";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:secondTrigger];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error)
        {
            NSLog(@"Что-то пошло не так ... %@", error);
        }
    }];
}




-(UNNotificationAttachment *)imageAttachment
{
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"blackHole" withExtension:@"jpg"];
    NSError *error;
    UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"pushImage" URL:fileURL options:nil error:&error];
    
    return attachment;
}

-(UNTimeIntervalNotificationTrigger * )intervalTrigger
{
    return [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:10 repeats:NO];
}

-(UNCalendarNotificationTrigger *)dateTrigger
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:3600];
    NSDateComponents *triggerDate = [[NSCalendar currentCalendar]components:NSCalendarUnitYear + NSCalendarUnitMonth + NSCalendarUnitDay + NSCalendarUnitHour + NSCalendarUnitMinute + NSCalendarUnitSecond fromDate:date];
    return [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:triggerDate repeats:NO];
}

-(UNLocationNotificationTrigger *)locationTrigger
{
    return nil;
}

-(NSInteger)giveNewBadgeNumber
{
    return [UIApplication sharedApplication].applicationIconBadgeNumber;
}

-(UNNotificationTrigger *)triggerWithType:(LCTTriggerType)triggerType
{
    switch(triggerType)
    {
        case LCTTriggerTypeInterval:
            return [self intervalTrigger];
        case LCTTriggerTypeDate:
            return [self dateTrigger];
        case LCTTriggerTypeLocation:
            return [self locationTrigger];
        default:
            break;
    }
    return nil;
}

-(void)addCustomActions
{
    UNNotificationAction *checkAction = [UNNotificationAction actionWithIdentifier:@"Check ID" title:@"Ага" options:UNNotificationActionOptionNone];
    
    UNNotificationAction *deleteAction = [UNNotificationAction actionWithIdentifier:@"Delete ID" title:@"Удалить" options:UNNotificationActionOptionDestructive];
    
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"LCTReminderCategory" actions:@[checkAction, deleteAction] intentIdentifiers:@[] options:UNNotificationCategoryOptionNone];
    NSSet *categories = [NSSet setWithObject:category];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center setNotificationCategories:categories];
}

#pragma mark CoreDataStuff
- (NSManagedObjectContext *)coreDataContext
{
    if (_coreDataContext)
    {
        return _coreDataContext;
    }
    
    UIApplication *application = [UIApplication sharedApplication];
    NSPersistentContainer *container = ((AppDelegate *)(application.delegate)).
    persistentContainer;
    NSManagedObjectContext *context = container.viewContext;
    
    return context;
}

- (NSArray *)updatedArray;
{
    NSError *error = nil;
    
    NSArray *result = [self.coreDataContext executeFetchRequest:self.fetchRequest ? : [Searches fetchRequest] error:&error];
    return result;
}

- (void)addNewSearch
{
    Searches *search = [NSEntityDescription insertNewObjectForEntityForName:@"Searches" inManagedObjectContext:self.coreDataContext];
    search.searchString = self.searchTextField.text;
    
    if (search.searchString.length == 0)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Ошибка" message:@"Нужен непустой запрос" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ок" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        NSError *error = nil;
        
        if (![search.managedObjectContext save:&error])
        {
            NSLog(@"Не удалось сохранить объект");
            NSLog(@"%@, %@", error, error.localizedDescription);
        }
        else
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}



@end

