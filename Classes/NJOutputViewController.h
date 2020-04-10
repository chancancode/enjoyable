//
//  NJOutputController.h
//  Enjoy
//
//  Created by Sam McCall on 5/05/09.
//  Copyright 2009 University of Otago. All rights reserved.
//

#import "NJKeyInputField.h"

@class NJInput;
@class NJOutput;
@class NJMapping;

@protocol NJOutputViewControllerDelegate;

@interface NJOutputViewController : NSObject <NJKeyInputFieldDelegate>

@property (nonatomic, strong) IBOutlet NJKeyInputField *keyInput;
@property (nonatomic, strong) IBOutlet NSMatrix *radioButtons;
@property (nonatomic, strong) IBOutlet NSSegmentedControl *mouseMoveDirSelect;
@property (nonatomic, strong) IBOutlet NSSlider *mouseMoveAmountSlider;
@property (nonatomic, strong) IBOutlet NSSegmentedControl *mouseAimDirSelect;
@property (nonatomic, strong) IBOutlet NSSlider *mouseAimAmountSlider;
@property (nonatomic, strong) IBOutlet NSSegmentedControl *mouseCenterModeSelect;
@property (nonatomic, strong) IBOutlet NSSegmentedControl *mouseBtnSelect;
@property (nonatomic, strong) IBOutlet NSSegmentedControl *scrollDirSelect;
@property (nonatomic, strong) IBOutlet NSSlider *scrollSpeedSlider;
@property (nonatomic, strong) IBOutlet NSTextField *title;
@property (nonatomic, strong) IBOutlet NSPopUpButton *mappingPopup;
@property (nonatomic, strong) IBOutlet NSButton *smoothCheck;
@property (nonatomic, strong) IBOutlet NSButton *unknownMapping;

@property (nonatomic, weak) IBOutlet id <NJOutputViewControllerDelegate> delegate;

- (void)loadOutput:(NJOutput *)output forInput:(NJInput *)input;
- (void)focusKey;

- (IBAction)outputTypeChanged:(id)sender;
- (IBAction)mouseMoveDirectionChanged:(id)sender;
- (IBAction)mouseMoveAmountChanged:(id)sender;
- (IBAction)mouseAimDirectionChanged:(id)sender;
- (IBAction)mouseAimAmountChanged:(id)sender;
- (IBAction)mouseCenterModeChanged:(id)sender;
- (IBAction)mouseButtonChanged:(id)sender;
- (IBAction)scrollDirectionChanged:(id)sender;
- (IBAction)scrollSpeedChanged:(id)sender;
- (IBAction)scrollTypeChanged:(id)sender;

@end

@protocol NJOutputViewControllerDelegate

- (NJMapping *)outputViewController:(NJOutputViewController *)ovc
                    mappingForIndex:(NSUInteger)index;
- (void)outputViewController:(NJOutputViewController *)ovc
                   setOutput:(NJOutput *)output
                    forInput:(NJInput *)input;

@end
