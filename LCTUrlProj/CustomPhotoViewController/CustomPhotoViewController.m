//
//  CustomPhotoViewController.m
//  LCTUrlProj
//
//  Created by Владимир on 20/04/2019.
//  Copyright © 2019 Владимир. All rights reserved.
//

#import "CustomPhotoViewController.h"

@interface CustomPhotoViewController ()

@property (nonatomic, strong) UIImage *startImage;
@property (nonatomic, strong) UIImageView *myImageView;


@property (nonatomic, strong) UIButton *recoverButton;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) MyButtons *firstFilterButton;
@property (nonatomic, strong) MyButtons *secondFilterButton;
@property (nonatomic, strong) MyButtons *thirdFilterButton;

@property (nonatomic, assign) NSString *firstFilterName;
@property (nonatomic, assign) NSString *secondFilterName;

@end

@implementation CustomPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupRecoverButton];
    [self setupSaveButton];
    [self setupFirstFilterButton];
    [self setupSecondFilterButton];
    [self setupThirdFilterButton];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

-(void)setupRecoverButton
{
    self.recoverButton = [[UIButton alloc] initWithFrame:CGRectMake(5, self.view.frame.size.height - 30 + 5 , 200, 20)];
    [self.recoverButton setTitle:@"Отменить изменения" forState:UIControlStateNormal];
    self.recoverButton.backgroundColor = [UIColor lightGrayColor];
    self.recoverButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.recoverButton.layer.borderWidth = 1.0f;
    [self.recoverButton addTarget:self action:@selector(makeRestoreImage) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.recoverButton];
}

-(void)setupSaveButton
{
    self.saveButton = [[UIButton alloc] initWithFrame:CGRectMake(210, self.view.frame.size.height - 30 + 5 , 160, 20)];
    [self.saveButton setTitle:@"Сохранить" forState:UIControlStateNormal];
    
    self.saveButton.backgroundColor = [UIColor lightGrayColor];
    self.saveButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.saveButton.layer.borderWidth = 1.0f;
    [self.saveButton addTarget:self action:@selector(makeSaveImage) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.saveButton];
}

-(void)setupFirstFilterButton
{
    self.firstFilterButton = [[MyButtons alloc] initWithFrame:CGRectMake(5, self.view.frame.size.height - 60 + 5 , 118.33, 20)];
    [self.firstFilterButton setTitle:@"SepiaTone" forState:UIControlStateNormal];
    [self.firstFilterButton setFilterToUse:@"CISepiaTone"];
    
    self.firstFilterButton.backgroundColor = [UIColor lightGrayColor];
    self.firstFilterButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.firstFilterButton.layer.borderWidth = 1.0f;
    [self.firstFilterButton addTarget:self action:@selector(releaseFilter:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.firstFilterButton];
}

-(void)setupSecondFilterButton
{
    self.secondFilterButton = [[MyButtons alloc] initWithFrame:CGRectMake(128.33, self.view.frame.size.height - 60 + 5 , 118.33, 20)];
    [self.secondFilterButton setTitle:@"Edges" forState:UIControlStateNormal];
    [self.secondFilterButton setFilterToUse:@"CIEdges"];
    
    self.secondFilterButton.backgroundColor = [UIColor lightGrayColor];
    self.secondFilterButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.secondFilterButton.layer.borderWidth = 1.0f;
    [self.secondFilterButton addTarget:self action:@selector(releaseFilter:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.secondFilterButton];
}

-(void)setupThirdFilterButton
{
    self.thirdFilterButton = [[MyButtons alloc] initWithFrame:CGRectMake(251.66, self.view.frame.size.height - 60 + 5 , 118.33, 20)];
    [self.thirdFilterButton setTitle:@"Black-white" forState:UIControlStateNormal];
    [self.thirdFilterButton setFilterToUse:@"CIPhotoEffectNoir"];
    
    self.thirdFilterButton.backgroundColor = [UIColor lightGrayColor];
    self.thirdFilterButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.thirdFilterButton.layer.borderWidth = 1.0f;
    [self.thirdFilterButton addTarget:self action:@selector(releaseDistortionFilter:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.thirdFilterButton];
}

-(void)setupImageViewWithImage:(UIImage *)image
{
    self.myImageView.image = nil;
    
    CGFloat frmWidth = self.view.frame.size.width - 40;
    CGFloat frmHeight = self.view.frame.size.height - 80;
    CGFloat frmStartX = 20;
    CGFloat frmStartY = 20;
    if (image.size.width < frmWidth)
    {
        frmWidth = image.size.width;
        frmStartX = self.view.center.x - (frmWidth/2);
    }
    if (image.size.height < frmHeight)
    {
        frmHeight = image.size.height;
        frmStartY = self.view.center.y - (frmHeight/2) - 40;
    }
    
    self.myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(frmStartX, frmStartY, frmWidth, frmHeight)];
    self.myImageView.image = image;
    self.startImage = image;
    [self.view addSubview:self.myImageView];
    
}

-(void)makeSaveImage
{
    [self.delegate getResultPhotoWithImage:self.myImageView.image];
}

-(void)makeRestoreImage
{
    self.myImageView.image = self.startImage;
    //NSLog(@"Image recharged");
}

-(void)releaseFilter:(MyButtons *)sender
{
    CIImage *workCIImage = [[CIImage alloc] initWithImage:self.startImage];
    if (workCIImage == nil)
    {
        NSLog(@"problems uiimage -> ciimage");
        return;
    }
    
    CIFilter *firstFilter = [CIFilter filterWithName:sender.filterToUse keysAndValues:kCIInputImageKey, workCIImage , @"inputIntensity", @0.8, nil];
    
    CIImage *outputImage = [firstFilter outputImage];
    UIImage *resultImage = [UIImage imageWithCIImage:outputImage];
    self.myImageView.image = resultImage;
    //NSLog(@"%@ filter activated", sender.filterToUse);
}

-(void)releaseDistortionFilter:(MyButtons *)sender
{
    CIImage *workCIImage = [[CIImage alloc] initWithImage:self.startImage];
    if (workCIImage == nil)
    {
        NSLog(@"problems uiimage -> ciimage");
        return;
    }
    
    CIFilter *firstFilter = [CIFilter filterWithName:sender.filterToUse keysAndValues:kCIInputImageKey, workCIImage , nil];
    
    CIImage *outputImage = [firstFilter outputImage];
    UIImage *resultImage = [UIImage imageWithCIImage:outputImage];
    self.myImageView.image = resultImage;
    //NSLog(@"%@ filter activated", sender.filterToUse);
}

@end

@implementation MyButtons

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    return self;
}

-(void)setFilterToUse:(NSString *)filterToUse
{
    _filterToUse = filterToUse;
}

@end
