//
//  NJOutputMouseCenter.m
//  Enjoyable
//
//  Created by Godfrey Chan on 4/9/20.
//

#import "NJOutputMouseCenter.h"

#import "NJInputController.h"

@implementation NJOutputMouseCenter

enum {
    kNJSetMouseCenter = 0,
    kNJRestoreMouseCenter = 1,
};

+ (NSString *)serializationCode {
    return @"mouse center";
}

- (NSDictionary *)serialize {
    return @{ @"type": self.class.serializationCode,
              @"mode": @(self.mode),
              };
}

+ (NJOutput *)outputWithSerialization:(NSDictionary *)serialization {
    NJOutputMouseCenter *output = [[self alloc] init];

    output.mode = [serialization[@"mode"] intValue];

    if (output.mode != kNJRestoreMouseCenter)
        output.mode = kNJSetMouseCenter;

    return output;
}

- (BOOL)isContinuous {
    return YES;
}

- (BOOL)update:(NJInputController *)ic {
    if (self.mode == kNJSetMouseCenter) {
        ic.mouseCenter = ic.mouseLoc;
    } else {
        [self moveMouseToPoint:ic.mouseCenter withInputController:ic];
    }

    return NO;
}


@end
