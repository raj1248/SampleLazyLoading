//
//  AppRecord.h
//  SampleLazyLoading
//
//  Created by Raj Kumar S L on 27/02/14.
//  Copyright (c) 2014 Raj Kumar S L. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppRecord : NSObject

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *imageURLString;
@property (nonatomic,strong) UIImage *appIcon;

@end
