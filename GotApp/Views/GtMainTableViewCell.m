//
//  GtMainTableViewCell.m
//  GotApp
//
//  Created by Ola Skierbiszewska on 09.08.2016.
//  Copyright © 2016 Ola Skierbiszewska. All rights reserved.
//

#import "GtMainTableViewCell.h"
#import "Masonry.h"
#import "UIColor+Gt.h"

@implementation GtMainTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.thumbnailView = [[UIImageView alloc] init];
        self.labelTitle = [[UILabel alloc] init];
        self.labelDescription = [[UILabel alloc] init];
        self.favView = [[UIImageView alloc] init];
        
        self.thumbnailView.backgroundColor = [UIColor lightGrayColor];
        UIImage *favImage = [[UIImage imageNamed:@"ico_star_small_full"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self.favView setImage:favImage];
        [self.favView setTintColor:[UIColor gtStarsColor]];
        self.favView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        self.favView.layer.shadowOffset = CGSizeMake(0, 1);
        self.favView.layer.shadowOpacity = 0.8;
        self.favView.layer.shadowRadius = 0.5;
        self.favView.clipsToBounds = NO;
        
        [self addSubview: self.thumbnailView];
        [self addSubview: self.labelTitle];
        [self addSubview: self.labelDescription];
        [self addSubview:self.favView];
        
        [self.thumbnailView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.thumbnailView.mas_height);
            make.top.equalTo(self.mas_top).with.offset(8);
            make.left.equalTo(self.mas_left).with.offset(8);
            make.bottom.equalTo(self.mas_bottom).with.offset(-8);
        }];
        
        [self.labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
            make.left.equalTo(self.thumbnailView.mas_right).with.offset(8);
            make.top.equalTo(self.mas_top).with.offset(8);
            make.right.equalTo(self.mas_right).with.offset(-8);
        }];
        
        [self.labelDescription mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
            make.left.equalTo(self.thumbnailView.mas_right).with.offset(8);
            make.top.equalTo(self.labelTitle.mas_bottom).with.offset(0);
            make.right.equalTo(self.mas_right).with.offset(-8);
            make.bottom.equalTo(self.mas_bottom).with.offset(-8);

        }];
        
        [self.favView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(23);
            make.height.mas_equalTo(23);
            make.top.equalTo(self.mas_top).with.offset(4);
            make.right.equalTo(self.mas_right).with.offset(-4);
        }];
        
        self.labelTitle.numberOfLines = 0;
        self.labelTitle.font = [UIFont boldSystemFontOfSize:14];
        self.labelDescription.numberOfLines = 2;
        self.labelDescription.font = [UIFont systemFontOfSize:12];
    }
    return self;
}

@end
