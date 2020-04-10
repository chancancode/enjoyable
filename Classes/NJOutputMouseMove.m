//
//  NJOutputMouseMove.m
//  Enjoy
//
//  Created by Yifeng Huang on 7/26/12.
//

#import "NJOutputMouseMove.h"

#import "NJInputController.h"

@implementation NJOutputMouseMove

+ (NSString *)serializationCode {
    return @"mouse move";
}

- (NSDictionary *)serialize {
    return @{ @"type": self.class.serializationCode,
              @"direction": @(self.direction),
              @"amount": @(self.amount),
              };
}

+ (NJOutput *)outputWithSerialization:(NSDictionary *)serialization {
    NJOutputMouseMove *output = [[self alloc] init];

    if (serialization[@"direction"] != nil) {
        output.direction = [serialization[@"direction"] intValue];
    } else {
        output.direction = [serialization[@"axis"] intValue];
    }

    if (serialization[@"amount"] != nil) {
        output.amount = [serialization[@"amount"] floatValue];
    } else {
        output.amount = [serialization[@"speed"] floatValue];
    }

    if (output.amount == 0)
        output.amount = 10;

    return output;
}

- (BOOL)isContinuous {
    return YES;
}

- (BOOL)update:(NJInputController *)ic {
    if (self.magnitude < 0.08)
        return NO; // dead zone

    CGFloat dx = 0, dy = 0;

    switch (self.direction) {
        case 0:
            dx = -self.magnitude * self.amount;
            break;
        case 1:
            dx = self.magnitude * self.amount;
            break;
        case 2:
            dy = -self.magnitude * self.amount;
            break;
        case 3:
            dy = self.magnitude * self.amount;
            break;
    }

    NSPoint mouseLoc = ic.mouseLoc;

    mouseLoc.x = mouseLoc.x + dx;
    mouseLoc.y = mouseLoc.y - dy;

    [self moveMouseToPoint:mouseLoc withInputController:ic];

    return YES;
}

#define CLAMP(a, l, h) MIN(h, MAX(a, l))

- (BOOL)moveMouseToPoint:(NSPoint)target withInputController:(NJInputController *)ic {
    CGSize size = NSScreen.mainScreen.frame.size;

    NSPoint current = ic.mouseLoc;

    target.x = CLAMP(target.x, 0, size.width - 1);
    target.y = CLAMP(target.y, 0, size.height - 1);

    ic.mouseLoc = target;

    CGEventRef move = CGEventCreateMouseEvent(NULL, kCGEventMouseMoved,
                                              CGPointMake(target.x, size.height - target.y),
                                              0);
    CGEventSetIntegerValueField(move, kCGMouseEventDeltaX, (int)(target.x - current.x));
    CGEventSetIntegerValueField(move, kCGMouseEventDeltaY, (int)(current.y - target.y));
    CGEventPost(kCGHIDEventTap, move);

    if (CGEventSourceButtonState(kCGEventSourceStateHIDSystemState, kCGMouseButtonLeft)) {
        CGEventSetType(move, kCGEventLeftMouseDragged);
        CGEventSetIntegerValueField(move, kCGMouseEventButtonNumber, kCGMouseButtonLeft);
        CGEventPost(kCGHIDEventTap, move);
    }

    if (CGEventSourceButtonState(kCGEventSourceStateHIDSystemState, kCGMouseButtonRight)) {
        CGEventSetType(move, kCGEventRightMouseDragged);
        CGEventSetIntegerValueField(move, kCGMouseEventButtonNumber, kCGMouseButtonRight);
        CGEventPost(kCGHIDEventTap, move);
    }

    if (CGEventSourceButtonState(kCGEventSourceStateHIDSystemState, kCGMouseButtonCenter)) {
        CGEventSetType(move, kCGEventOtherMouseDragged);
        CGEventSetIntegerValueField(move, kCGMouseEventButtonNumber, kCGMouseButtonCenter);
        CGEventPost(kCGHIDEventTap, move);
    }

    CFRelease(move);

    return YES;
}

@end
