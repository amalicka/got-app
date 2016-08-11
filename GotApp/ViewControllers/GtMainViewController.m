//
//  GtMainViewController.m
//  GotApp
//
//  Created by Ola Skierbiszewska on 08.08.2016.
//  Copyright © 2016 Ola Skierbiszewska. All rights reserved.
//

#import "GtMainViewController.h"
#import "GtDetailsViewController.h"
#import "GtMainTableViewCell.h"
#import "Masonry.h"
#import "GtCharacter.h"
#import "GtFavManager.h"
#import "UIColor+Gt.h"

@interface GtMainViewController ()

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) id previewingContext;

@property (nonatomic, strong) NSMutableArray *characters;

@property (nonatomic, strong) NSMutableArray *favCharacters;

@property (atomic) BOOL isFavSelected;

@property (atomic) BOOL isGettingData;

@property (nonatomic, strong) UILabel *noContentLabel;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@end

@implementation GtMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.characters = [[NSMutableArray alloc] init];
    self.favCharacters = [[NSMutableArray alloc] init];
    
    //segmented control
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:AS(@"all"), AS(@"favs"), nil]];
    self.navigationItem.titleView = segmentedControl;
    [segmentedControl setSelectedSegmentIndex:0];
    [segmentedControl addTarget:self action:@selector(segmentedControllChanged:) forControlEvents:UIControlEventValueChanged];
    self.isFavSelected = NO;
    
    //table view
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    //[self.tableView registerClass:[PosServiceTableViewCell class] forCellReuseIdentifier:@"cellForCharacter"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.tableView.superview).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.tableView registerClass:[GtMainTableViewCell class] forCellReuseIdentifier:kMainTableViewCellIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView reloadData];
    
    //getting data
    [self addNoContentLabel];
    [self addActivityIndicator];
    [self getData];
    
    //    if ([self isForceTouchAvailable]) {
    //        self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView:self.view];
    //    }

}

- (void)getData{
    self.isGettingData = YES;
    [GtApiClient sharedSingleton].delegate = self;
    [[GtApiClient sharedSingleton]getData];
}

#pragma  mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger numerOfRows;
    if(self.isFavSelected){
        numerOfRows = self.favCharacters.count;
        self.noContentLabel.hidden = (numerOfRows>0 || self.isGettingData) ? YES : NO;
    }else{
        numerOfRows = self.characters.count;
        self.noContentLabel.hidden = (numerOfRows>0 || self.isGettingData) ? YES : NO;
    }
    
    return numerOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GtMainTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier: kMainTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[GtMainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: kMainTableViewCellIdentifier];
    }
    
    cell.editingAccessoryType = UITableViewCellEditingStyleNone;
    UIView *vc = [[UIView alloc]initWithFrame: CGRectMake(0, 0, 40, 40)];
    vc.backgroundColor = [UIColor redColor];
    cell.editingAccessoryView = vc;
    
    GtCharacter *character = [self getCharacterForIndexPath:indexPath];
    cell.favView.hidden = !character.isInFav;
    cell.labelTitle.text = character.title;
    cell.labelDescription.text = character.abstract;
    
    //load thumbnail
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString: character.thumbnail] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    GtMainTableViewCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                    if (updateCell)
                        updateCell.thumbnailView.image = image;
                });
            }
        }
    }];
    [task resume];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GtDetailsViewController *vc = [[GtDetailsViewController alloc] init];
    vc.character = [self getCharacterForIndexPath:indexPath];
    vc.basePath = self.basePath;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

#pragma  mark -  TableView editing

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __block GtCharacter *character = [self getCharacterForIndexPath:indexPath];
    NSString *buttonTitle;
    if(character.isInFav){
        buttonTitle = AS(@"dislike");
    }else{
        buttonTitle = AS(@"like");
    }
    
    UITableViewRowAction *likeAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title: buttonTitle handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        if(character.isInFav){
            [GtFavManager removeCharacterIdFromFavorites: character.characterId];
            [self.favCharacters removeObject:character];
        }else{
            [GtFavManager saveCharacterIdToFavorites: character.characterId];
            [self.favCharacters addObject:character];
        }
        character.isInFav = !character.isInFav;
        if(self.isFavSelected){
            [self.tableView reloadData];
        }else{
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
        [self.tableView setEditing:NO];
    }];
    likeAction.backgroundColor = [UIColor blueColor];
    return @[likeAction];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma  mark -  UIViewControllerPreviewingDelegate

- (BOOL)isForceTouchAvailable {
    BOOL isForceTouchAvailable = NO;
    if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
        isForceTouchAvailable = self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable;
    }
    return isForceTouchAvailable;
}

- (UIViewController *)previewingContext:(id )previewingContext viewControllerForLocation:(CGPoint)location{
//    if ([self.presentedViewController isKindOfClass:[UIViewController class]]) {
//        return nil;
//    }
//    //get cell based on location
//    CGPoint cellPostion = [self.tableView convertPoint:location fromView:self.view];
//    NSIndexPath *path = [self.tableView indexPathForRowAtPoint:cellPostion];
//    
//    if (path) {
//        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
//        
//        //make na instance of a previewController - view controller with detail
//        
//        previewingContext.sourceRect = cell.frame;
//        return previewController;
//    }
    return nil;
}

- (void)previewingContext:(id )previewingContext commitViewController: (UIViewController *)viewControllerToCommit {
    [self.navigationController showViewController:viewControllerToCommit sender:nil];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
//    [super traitCollectionDidChange:previousTraitCollection];
//    if ([self isForceTouchAvailable]) {
//        if (!self.previewingContext) {
//            self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView:self.view];
//        }
//    } else {
//        if (self.previewingContext) {
//            [self unregisterForPreviewingWithContext:self.previewingContext];
//            self.previewingContext = nil;
//        }
//    }
}

#pragma  mark -  Helper methods

- (void)segmentedControllChanged:(UISegmentedControl*)control{
    if(control.selectedSegmentIndex == 1){
        self.isFavSelected = YES;
    }else{
        self.isFavSelected = NO;
    }
    [self.tableView reloadData];
}

- (GtCharacter*)getCharacterForIndexPath:(NSIndexPath*)indexPath{
    if(self.isFavSelected ){
        return self.favCharacters[indexPath.row];
    }else{
        return self.characters[indexPath.row];
    }
}

- (void)addNoContentLabel {
    UILabel *noItemsLabel;
    noItemsLabel = [[UILabel alloc] init];
    noItemsLabel.text = AS(@"noContentLabelText");
    noItemsLabel.font = [UIFont systemFontOfSize:14];
    noItemsLabel.textColor = [UIColor grayColor];
    noItemsLabel.numberOfLines = 0;
    noItemsLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [noItemsLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:noItemsLabel];
    self.noContentLabel = noItemsLabel;
    self.noContentLabel.hidden = YES;
    [self.view addSubview: self.noContentLabel];
    [self.noContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
    }];
}

- (void)addActivityIndicator{
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:self.activityView];
    
    [self.activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
    }];
    [self.activityView startAnimating];
    self.activityView.color = [UIColor grayColor];
}


#pragma mark - GtApiClientDelegate methods

- (void)retrievedCharacters:(NSArray *)items favCharacters:(NSArray *)favItems andPath:(NSString *)path error:(NSError*) error{
    if (error != nil) {
        self.isGettingData = NO;
        self.noContentLabel.text = AS(@"errorGettingData");
        [self.activityView stopAnimating];
        [self.tableView reloadData];
    }else{
        self.isGettingData = NO;
        [self.favCharacters addObjectsFromArray: favItems];
        [self.characters addObjectsFromArray: items];
        self.basePath = path;
        [self.activityView stopAnimating];
        [self.tableView reloadData];
    }
}

@end
