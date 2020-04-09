//
//  NJOutputMouseMove.h
//  Enjoy
//
//  Created by Yifeng Huang on 7/26/12.
//

#import "NJOutput.h"

@interface NJOutputMouseMove : NJOutput

@property (nonatomic, assign) int direction;
@property (nonatomic, assign) float amount;

- (BOOL)moveMouseToPoint:(NSPoint)point withInputController:(NJInputController *)ic;

@end
