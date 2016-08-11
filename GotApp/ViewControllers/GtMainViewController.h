//
//  GtMainViewController.h
//  GotApp
//
//  Created by Ola Skierbiszewska on 08.08.2016.
//  Copyright © 2016 Ola Skierbiszewska. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GtBaseViewController.h"
#import "GtApiClient.h"

@interface GtMainViewController : GtBaseViewController <UITableViewDelegate, UITableViewDataSource, /*UIViewControllerPreviewingDelegate, */GtApiClientDelegate>

@end
