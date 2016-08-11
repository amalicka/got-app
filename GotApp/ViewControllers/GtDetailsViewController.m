//
//  GtDetailsViewController.m
//  GotApp
//
//  Created by Ola Skierbiszewska on 08.08.2016.
//  Copyright © 2016 Ola Skierbiszewska. All rights reserved.
//

#import "GtDetailsViewController.h"
#import "Masonry.h"
#import "UIColor+Gt.h"

@interface GtDetailsViewController ()

@property (nonatomic, strong) UIScrollView * scrollView;

@property (nonatomic, strong) UIImageView * photoView;

@property (nonatomic, strong) UIImageView * favView;

@property (nonatomic, strong) UILabel * labelTitle;

@property (nonatomic, strong) UILabel * labelDescription;

@property (nonatomic, strong) UIButton * buttonGoToDetails;

@property (nonatomic, strong) NSLayoutConstraint * constraintScrollviewTop;

@end

@implementation GtDetailsViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = self.character.title;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.photoView = [[UIImageView alloc] init];
    self.favView = [[UIImageView alloc] init];
    self.labelTitle = [[UILabel alloc] init];
    self.labelDescription = [[UILabel alloc] init];
    self.buttonGoToDetails = [[UIButton alloc] init];
    
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    self.labelTitle.font = [UIFont boldSystemFontOfSize:18];
    self.labelDescription.numberOfLines = 0;
    self.labelDescription.lineBreakMode = NSLineBreakByWordWrapping;
    self.buttonGoToDetails.backgroundColor = [UIColor grayColor];
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.basePath, self.character.url]];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [self.buttonGoToDetails setTitle:AS(@"readMore") forState:UIControlStateNormal];
        [self.buttonGoToDetails addTarget:self action:@selector(buttonGoToDetailsTapped) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [self.buttonGoToDetails setTitle:AS(@"noDetailsAvailable") forState:UIControlStateNormal];
    }
    
    NSString *imgName;
    (self.character.isInFav) ? (imgName = @"ico_star_big_full") : (imgName = @"ico_star_big_empty");
    UIImage *favImage = [[UIImage imageNamed:imgName]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.favView setImage:favImage];
    [self.favView setTintColor:[UIColor gtStarsColor]];
    self.favView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.favView.layer.shadowOffset = CGSizeMake(0, 1);
    self.favView.layer.shadowOpacity = 0.8;
    self.favView.layer.shadowRadius = 0.5;
    self.favView.clipsToBounds = NO;
    
    self.labelTitle.text = self.character.title;
    self.labelDescription.text = self.character.abstract;
    
    [self.view addSubview: self.scrollView];
    [self.scrollView addSubview: self.photoView];
    [self.photoView addSubview:self.favView];
    [self.scrollView addSubview: self.labelTitle];
    [self.scrollView addSubview: self.labelDescription];
    [self.scrollView addSubview:self.buttonGoToDetails];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
    }];
    
    self.constraintScrollviewTop = [NSLayoutConstraint constraintWithItem:self.scrollView
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1.0
                                                                 constant:64];
    
    [self.view addConstraint: self.constraintScrollviewTop];
    
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.scrollView.mas_centerX);
        make.height.mas_equalTo(self.photoView.mas_width);
        make.top.equalTo(self.scrollView.mas_top).with.offset(-64);
        make.left.equalTo(self.scrollView.mas_left).with.offset(0);
        make.right.equalTo(self.scrollView.mas_right).with.offset(0);
    }];
    
    [self.favView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(36);
        make.height.mas_equalTo(36);
        make.bottom.equalTo(self.photoView.mas_bottom).with.offset(-10);
        make.right.equalTo(self.photoView.mas_right).with.offset(-10);
    }];
    
    [self.labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.top.equalTo(self.photoView.mas_bottom).with.offset(0);
        make.left.equalTo(self.scrollView.mas_left).with.offset(8);
        make.right.equalTo(self.scrollView.mas_right).with.offset(-8);
    }];
    
    [self.labelDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labelTitle.mas_bottom).with.offset(0);
        make.left.equalTo(self.scrollView.mas_left).with.offset(8);
        make.right.equalTo(self.scrollView.mas_right).with.offset(-8);
    }];
    
    [self.buttonGoToDetails mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(45);
        make.top.equalTo(self.labelDescription.mas_bottom).with.offset(20);
        make.bottom.equalTo(self.scrollView.mas_bottom).with.offset(-30);
        make.left.equalTo(self.scrollView.mas_left).with.offset(60);
        make.right.equalTo(self.scrollView.mas_right).with.offset(-60);
    }];

    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString: self.character.thumbnail] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.photoView.image = image;
                });
            }
        }
    }];
    [task resume];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if(UIInterfaceOrientationIsPortrait(orientation)) {
        self.constraintScrollviewTop.constant = 64;
    } else if(UIInterfaceOrientationIsLandscape(orientation)){
        self.constraintScrollviewTop.constant = 32;
    }
}

- (void)buttonGoToDetailsTapped{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:nil
                                          message: AS(@"goToSafari")
                                          preferredStyle:UIAlertControllerStyleAlert];

    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle: AS(@"cancel")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action){
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle: AS(@"ok")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action) {
                                   NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.basePath, self.character.url]];
                                   if ([[UIApplication sharedApplication] canOpenURL:url]) {
                                       [[UIApplication sharedApplication] openURL:url];
                                   }
                               }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
