//
//  ItemDetailViewController.m
//  beaconReceiver
//
//  Created by hanks on 5/23/15.
//  Copyright (c) 2015 com.hanks. All rights reserved.
//

#import "ItemDetailViewController.h"
#import "EDStarRating.h"
#import "APIManager.h"
#import "Item.h"

@interface ItemDetailViewController () <EDStarRatingProtocol>

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemPriceLabel;
@property (weak, nonatomic) IBOutlet EDStarRating *itemRatingControl;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextarea;

@property (strong, nonatomic) NSNumber *major;
@property (strong, nonatomic) NSNumber *minor;

@end

@implementation ItemDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.itemRatingControl.starImage = [UIImage imageNamed:@"star"];
    self.itemRatingControl.starHighlightedImage = [UIImage imageNamed:@"starhighlighted"];
    self.itemRatingControl.maxRating = 5.0;
    self.itemRatingControl.delegate = self;
    self.itemRatingControl.horizontalMargin = 12;
    self.itemRatingControl.editable=YES;
    self.itemRatingControl.displayMode=EDStarRatingDisplayFull;
    self.itemRatingControl.rating= 2.5;
    
    // set item info
    __weak ItemDetailViewController *weakSelf = self;
    SuccessCallback successcallback = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *aDictionary = (NSDictionary *)responseObject;
                
        Item *item = [[Item alloc] initWithDictionary:aDictionary];
                
        weakSelf.itemNameLabel.text = item.itemName;
        weakSelf.itemPriceLabel.text = [NSString stringWithFormat:@"%ld", item.price];
        weakSelf.descriptionTextarea.text = item.desc;
        
        // call item image api
        SuccessCallback successcallback = ^(AFHTTPRequestOperation *operation, id imageObject) {
            weakSelf.itemImageView.image = imageObject;
        };
        NSString *endpoint = [NSString stringWithFormat:@"/image/%@", item.imageName];
        [APIManager requestImageWithEndpoint:endpoint successCallback:successcallback];
    };
    
    // call item json api
    NSString *endpoint = [NSString stringWithFormat:@"/item/%@/%@", self.major, self.minor];
    [APIManager requestJSONWithEndpoint:endpoint successCallback:successcallback];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"popUpBG"]];
}

- (void)setMajor:(NSNumber *)major {
    _major = major;
}

- (void)setMinor:(NSNumber *)minor {
    _minor = minor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - EDStarRatingProtocol

-(void)starsSelectionChanged:(EDStarRating*)control rating:(float)rating {
    
}

@end
