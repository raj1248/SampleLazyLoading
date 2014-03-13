//
//  DetailViewController.h
//  SampleLazyLoading
//
//  Created by Raj Kumar S L on 26/02/14.
//  Copyright (c) 2014 Raj Kumar S L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
