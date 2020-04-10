//
//  NJOutputMouseAim.m
//  Enjoyable
//
//  Created by Godfrey Chan on 4/8/20.
//

#import "NJOutputMouseAim.h"

#import "NJInputController.h"

@implementation NJOutputMouseAim

+ (NSString *)serializationCode {
    return @"mouse aim";
}

- (BOOL)update:(NJInputController *)ic {
    CGFloat magnitude = MAX(self.magnitude - 0.3, 0) / 0.7;

    CGSize size = NSScreen.mainScreen.frame.size;
    CGFloat max = 0.5 * MIN(size.width, size.height) / 2;
    
    NSPoint mouseLoc = ic.mouseLoc;
    NSPoint mouseCenter = ic.mouseCenter;

    switch (self.direction) {
        case 0:
            mouseLoc.x = mouseCenter.x - self.magnitude * max;
            break;
        case 1:
            mouseLoc.x = mouseCenter.x + self.magnitude * max;
            break;
        case 2:
            mouseLoc.y = mouseCenter.y + self.magnitude * max;
            break;
        case 3:
            mouseLoc.y = mouseCenter.y - self.magnitude * max;
            break;
    }

    [self moveMouseToPoint:mouseLoc withInputController:ic];

    return magnitude != 0;
}


@end
