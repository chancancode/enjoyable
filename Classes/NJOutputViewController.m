//
//  NJOutputController.m
//  Enjoy
//
//  Created by Sam McCall on 5/05/09.
//

#import "NJOutputViewController.h"

#import "NJMapping.h"
#import "NJInput.h"
#import "NJEvents.h"
#import "NJInputController.h"
#import "NJKeyInputField.h"
#import "NJOutputMapping.h"
#import "NJOutputViewController.h"
#import "NJOutputKeyPress.h"
#import "NJOutputMouseButton.h"
#import "NJOutputMouseMove.h"
#import "NJOutputMouseAim.h"
#import "NJOutputMouseCenter.h"
#import "NJOutputMouseScroll.h"

@implementation NJOutputViewController {
    NJInput *_input;
}

enum {
    kNJOutputNothing     = 0,
    kNJOutputKeyPress    = 1,
    kNJOutputMapping     = 2,
    kNJOutputMouseMove   = 3,
    kNJOutputMouseAim    = 4,
    kNJOutputMouseCenter = 5,
    kNJOutputMouseButton = 6,
    kNJOutputMouseScroll = 7,
};

- (id)init {
    if ((self = [super init])) {
        [NSNotificationCenter.defaultCenter
            addObserver:self
            selector:@selector(mappingListDidChange:)
            name:NJEventMappingListChanged
            object:nil];
    }
    return self;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)cleanUpInterface {
    NSInteger row = self.radioButtons.selectedRow;

    if (row != kNJOutputKeyPress) {
        self.keyInput.keyCode = NJKeyInputFieldEmpty;
        [self.keyInput resignIfFirstResponder];
    }

    if (row != kNJOutputMapping) {
        [self.mappingPopup selectItemAtIndex:-1];
        [self.mappingPopup resignIfFirstResponder];
        self.unknownMapping.hidden = YES;
    }

    if (row != kNJOutputMouseMove) {
        self.mouseMoveDirSelect.selectedSegment = -1;
        self.mouseMoveAmountSlider.doubleValue = self.mouseMoveAmountSlider.minValue;
        [self.mouseMoveDirSelect resignIfFirstResponder];
    } else {
        if (self.mouseMoveDirSelect.selectedSegment == -1)
            self.mouseMoveDirSelect.selectedSegment = 0;
        if (self.mouseMoveAmountSlider.floatValue == 0)
            self.mouseMoveAmountSlider.floatValue = 10;
    }

    if (row != kNJOutputMouseAim) {
        self.mouseAimDirSelect.selectedSegment = -1;
        self.mouseAimAmountSlider.doubleValue = self.mouseMoveAmountSlider.minValue;
        [self.mouseAimDirSelect resignIfFirstResponder];
    } else {
        if (self.mouseAimDirSelect.selectedSegment == -1)
            self.mouseAimDirSelect.selectedSegment = 0;
        if (self.mouseAimAmountSlider.floatValue == 0)
            self.mouseAimAmountSlider.floatValue = 10;
    }

    if (row != kNJOutputMouseCenter) {
        self.mouseCenterModeSelect.selectedSegment = -1;
        [self.mouseCenterModeSelect resignFirstResponder];
    } else {
        if (self.mouseCenterModeSelect.selectedSegment == -1)
            self.mouseCenterModeSelect.selectedSegment = 0;
    }

    if (row != kNJOutputMouseButton) {
        self.mouseBtnSelect.selectedSegment = -1;
        [self.mouseBtnSelect resignIfFirstResponder];
    } else if (self.mouseBtnSelect.selectedSegment == -1)
        self.mouseBtnSelect.selectedSegment = 0;

    if (row != kNJOutputMouseScroll) {
        self.scrollDirSelect.selectedSegment = -1;
        self.scrollSpeedSlider.doubleValue = self.scrollSpeedSlider.minValue;
        self.smoothCheck.state = NSOffState;
        [self.scrollDirSelect resignIfFirstResponder];
        [self.scrollSpeedSlider resignIfFirstResponder];
        [self.smoothCheck resignIfFirstResponder];
    } else {
        if (self.scrollDirSelect.selectedSegment == -1)
            self.scrollDirSelect.selectedSegment = 0;
    }
}

- (IBAction)outputTypeChanged:(NSView *)sender {
    [sender.window makeFirstResponder:sender];
    if (self.radioButtons.selectedRow == kNJOutputKeyPress)
        [self.keyInput.window makeFirstResponder:self.keyInput];
    [self commit];
}

- (void)keyInputField:(NJKeyInputField *)keyInput didChangeKey:(CGKeyCode)keyCode {
    [self.radioButtons selectCellAtRow:kNJOutputKeyPress column:0];
    [self.radioButtons.window makeFirstResponder:self.radioButtons];
    [self commit];
}

- (void)keyInputFieldDidClear:(NJKeyInputField *)keyInput {
    [self.radioButtons selectCellAtRow:kNJOutputNothing column:0];
    [self commit];
}

- (void)mappingChosen:(id)sender {
    [self.radioButtons selectCellAtRow:kNJOutputMapping column:0];
    [self.mappingPopup.window makeFirstResponder:self.mappingPopup];
    self.unknownMapping.hidden = YES;
    [self commit];
}

- (void)mouseMoveDirectionChanged:(NSView *)sender {
    [self.radioButtons selectCellAtRow:kNJOutputMouseMove column:0];
    [sender.window makeFirstResponder:sender];
    [self commit];
}

- (void)mouseMoveAmountChanged:(NSSlider *)sender {
    [self.radioButtons selectCellAtRow:kNJOutputMouseMove column:0];
    [sender.window makeFirstResponder:sender];
    [self commit];
}

- (void)mouseAimDirectionChanged:(NSView *)sender {
    [self.radioButtons selectCellAtRow:kNJOutputMouseAim column:0];
    [sender.window makeFirstResponder:sender];
    [self commit];
}

- (void)mouseAimAmountChanged:(NSSlider *)sender {
    [self.radioButtons selectCellAtRow:kNJOutputMouseAim column:0];
    [sender.window makeFirstResponder:sender];
    [self commit];
}

- (void)mouseCenterModeChanged:(NSView *)sender {
    [self.radioButtons selectCellAtRow:kNJOutputMouseCenter column:0];
    [sender.window makeFirstResponder:sender];
    [self commit];
}

- (void)mouseButtonChanged:(NSView *)sender {
    [self.radioButtons selectCellAtRow:kNJOutputMouseButton column:0];
    [sender.window makeFirstResponder:sender];
    [self commit];
}

- (void)scrollDirectionChanged:(NSView *)sender {
    [self.radioButtons selectCellAtRow:kNJOutputMouseScroll column:0];
    [sender.window makeFirstResponder:sender];
    [self commit];
}

- (void)scrollSpeedChanged:(NSSlider *)sender {
    [self.radioButtons selectCellAtRow:kNJOutputMouseScroll column:0];
    [sender.window makeFirstResponder:sender];
    [self commit];
}

- (IBAction)scrollTypeChanged:(NSButton *)sender {
    [self.radioButtons selectCellAtRow:kNJOutputMouseScroll column:0];
    [sender.window makeFirstResponder:sender];
    if (sender.state == NSOnState) {
        self.scrollSpeedSlider.doubleValue =
            self.scrollSpeedSlider.minValue
            + (self.scrollSpeedSlider.maxValue - self.scrollSpeedSlider.minValue) / 2;
        self.scrollSpeedSlider.enabled = YES;
    } else {
        self.scrollSpeedSlider.doubleValue = self.scrollSpeedSlider.minValue;
        self.scrollSpeedSlider.enabled = NO;
    }
    [self commit];
}

- (NJOutput *)makeOutput {
    switch (self.radioButtons.selectedRow) {
        case kNJOutputNothing:
            return nil;
        case kNJOutputKeyPress:
            if (self.keyInput.hasKeyCode) {
                NJOutputKeyPress *k = [[NJOutputKeyPress alloc] init];
                k.keyCode = self.keyInput.keyCode;
                return k;
            } else {
                return nil;
            }
        case kNJOutputMapping: {
            NJOutputMapping *c = [[NJOutputMapping alloc] init];
            c.mapping = [self.delegate outputViewController:self
                                            mappingForIndex:self.mappingPopup.indexOfSelectedItem];
            return c;
        }
        case kNJOutputMouseMove: {
            NJOutputMouseMove *mm = [[NJOutputMouseMove alloc] init];
            mm.direction = (int)self.mouseMoveDirSelect.selectedSegment;
            mm.amount = self.mouseMoveAmountSlider.floatValue;
            return mm;
        }
        case kNJOutputMouseAim: {
            NJOutputMouseAim *ma = [[NJOutputMouseAim alloc] init];
            ma.direction = (int)self.mouseAimDirSelect.selectedSegment;
            ma.amount = self.mouseAimAmountSlider.floatValue;
            return ma;
        }
        case kNJOutputMouseCenter: {
            NJOutputMouseCenter *mc = [[NJOutputMouseCenter alloc] init];
            mc.mode = (int)self.mouseCenterModeSelect.selectedSegment;
            return mc;
        }
        case kNJOutputMouseButton: {
            NJOutputMouseButton *mb = [[NJOutputMouseButton alloc] init];
            mb.button = (int)[self.mouseBtnSelect.cell tagForSegment:self.mouseBtnSelect.selectedSegment];
            return mb;
        }
        case kNJOutputMouseScroll: {
            NJOutputMouseScroll *ms = [[NJOutputMouseScroll alloc] init];
            ms.direction = (int)[self.scrollDirSelect.cell tagForSegment:self.scrollDirSelect.selectedSegment];
            ms.speed = self.scrollSpeedSlider.floatValue;
            ms.smooth = self.smoothCheck.state == NSOnState;
            return ms;
        }
        default:
            return nil;
    }
}

- (void)commit {
    [self cleanUpInterface];
    [self.delegate outputViewController:self
                              setOutput:[self makeOutput]
                               forInput:_input];
}

- (BOOL)enabled {
    return self.radioButtons.isEnabled;
}

- (void)setEnabled:(BOOL)enabled {
    self.radioButtons.enabled = enabled;
    self.keyInput.enabled = enabled;
    self.mappingPopup.enabled = enabled;
    self.mouseMoveDirSelect.enabled = enabled;
    self.mouseMoveAmountSlider.enabled = enabled;
    self.mouseAimDirSelect.enabled = enabled;
    self.mouseAimAmountSlider.enabled = enabled;
    self.mouseCenterModeSelect.enabled = enabled;
    self.mouseBtnSelect.enabled = enabled;
    self.scrollDirSelect.enabled = enabled;
    self.smoothCheck.enabled = enabled;
    self.scrollSpeedSlider.enabled = enabled && self.smoothCheck.state;
    if (!enabled)
        self.unknownMapping.hidden = YES;
}

- (void)loadOutput:(NJOutput *)output forInput:(NJInput *)input {
    _input = input;
    if (!input) {
        [self setEnabled:NO];
        self.title.stringValue = @"";
    } else {
        [self setEnabled:YES];
        NSString *inpFullName = input.name;
        for (NJInputPathElement *cur = input.parent; cur; cur = cur.parent) {
            inpFullName = [[NSString alloc] initWithFormat:@"%@ ▸ %@", cur.name, inpFullName];
        }
        self.title.stringValue = inpFullName;
    }

    if ([output isKindOfClass:NJOutputKeyPress.class]) {
        [self.radioButtons selectCellAtRow:kNJOutputKeyPress column:0];
        self.keyInput.keyCode = [(NJOutputKeyPress*)output keyCode];
    }
    else if ([output isKindOfClass:NJOutputMapping.class]) {
        [self.radioButtons selectCellAtRow:kNJOutputMapping column:0];
        NSMenuItem *item = [self.mappingPopup itemWithIdenticalRepresentedObject:
                            [(NJOutputMapping *)output mapping]];
        [self.mappingPopup selectItem:item];
        self.unknownMapping.hidden = !!item;
        self.unknownMapping.title = [(NJOutputMapping *)output mappingName];
    }
    else if ([output isKindOfClass:NJOutputMouseAim.class]) {
        [self.radioButtons selectCellAtRow:kNJOutputMouseAim column:0];
        self.mouseAimDirSelect.selectedSegment = [(NJOutputMouseAim *)output direction];
        self.mouseAimAmountSlider.floatValue = [(NJOutputMouseAim *)output amount];
    }
    else if ([output isKindOfClass:NJOutputMouseCenter.class]) {
        [self.radioButtons selectCellAtRow:kNJOutputMouseCenter column:0];
        self.mouseCenterModeSelect.selectedSegment = [(NJOutputMouseCenter *)output mode];
    }
    else if ([output isKindOfClass:NJOutputMouseMove.class]) {
        [self.radioButtons selectCellAtRow:kNJOutputMouseMove column:0];
        self.mouseMoveDirSelect.selectedSegment = [(NJOutputMouseMove *)output direction];
        self.mouseMoveAmountSlider.floatValue = [(NJOutputMouseMove *)output amount];
    }
    else if ([output isKindOfClass:NJOutputMouseButton.class]) {
        [self.radioButtons selectCellAtRow:kNJOutputMouseButton column:0];
        [self.mouseBtnSelect selectSegmentWithTag:[(NJOutputMouseButton *)output button]];
    }
    else if ([output isKindOfClass:NJOutputMouseScroll.class]) {
        [self.radioButtons selectCellAtRow:kNJOutputMouseScroll column:0];
        int direction = [(NJOutputMouseScroll *)output direction];
        float speed = [(NJOutputMouseScroll *)output speed];
        BOOL smooth = [(NJOutputMouseScroll *)output smooth];
        [self.scrollDirSelect selectSegmentWithTag:direction];
        self.scrollSpeedSlider.floatValue = speed;
        self.smoothCheck.state = smooth ? NSOnState : NSOffState;
        self.scrollSpeedSlider.enabled = smooth;
    } else {
        [self.radioButtons selectCellAtRow:self.enabled ? kNJOutputNothing : -1 column:0];
    }
    [self cleanUpInterface];
}

- (void)focusKey {
    if (self.radioButtons.selectedRow <= kNJOutputNothing)
        [self.keyInput.window makeFirstResponder:self.keyInput];
    else
        [self.keyInput resignIfFirstResponder];
}

- (void)mappingListDidChange:(NSNotification *)note {
    NSArray *mappings = note.userInfo[NJMappingListKey];
    NJMapping *current = self.mappingPopup.selectedItem.representedObject;
    [self.mappingPopup.menu removeAllItems];
    for (NJMapping *mapping in mappings) {
        NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:mapping.name
                                                      action:@selector(mappingChosen:)
                                               keyEquivalent:@""];
        item.target = self;
        item.representedObject = mapping;
        [self.mappingPopup.menu addItem:item];
    }
    [self.mappingPopup selectItemWithIdenticalRepresentedObject:current];
}

@end
